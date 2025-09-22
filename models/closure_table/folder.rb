# frozen_string_literal: true

require 'active_record'

module Models
  module ClosureTable
    class Folder < ActiveRecord::Base
      belongs_to :parent_folder, optional: true, class_name: 'Folder',
                                 foreign_key: :parent_id

      has_many :child_folders, class_name: 'Folder',
                               foreign_key: :parent_id, inverse_of: :parent_folder, dependent: :destroy

      has_many :ancestor_paths, class_name: 'FolderPath',
                                foreign_key: 'descendant_id', dependent: :delete_all

      has_many :descendant_paths, class_name: 'FolderPath',
                                  foreign_key: 'ancestor_id', dependent: :delete_all

      after_create :build_path
      after_update :rebuild_path, if: :saved_change_to_parent_id?

      validate :no_cyclic, if: :will_save_change_to_parent_id?

      def ancestors
        Folder.joins(:descendant_paths)
              .where(folder_paths: { descendant_id: id, depth: 1.. })
              .order('folder_paths.depth DESC')
      end

      def descendants
        Folder.joins(:ancestor_paths)
              .where(folder_paths: { ancestor_id: id, depth: 1.. })
              .order('folder_paths.depth ASC')
      end

      def build_path
        path_records = []

        path_records << { ancestor_id: id, descendant_id: id, depth: 0 }

        if parent_id.present?
          parent_paths = FolderPath.where(descendant_id: parent_id).select(:ancestor_id, :depth)

          parent_paths.each do |path|
            path_records << {
              ancestor_id: path.ancestor_id,
              descendant_id: id,
              depth: path.depth + 1
            }
          end
        end

        FolderPath.insert_all(path_records) if path_records.any?
      end

      def rebuild_path
        Folder.transaction do
          target_folders = [self] + descendants.to_a

          FolderPath.where(descendant_id: target_folders.map(&:id)).delete_all

          target_folders.each(&:build_path)
        end
      end

      private

      def no_cyclic
        return unless parent_id.present?

        if parent_id == id
          errors.add(:parent_id, '自分自身を親にはできません')
          return
        end

        return unless FolderPath.exists?(ancestor_id: id, descendant_id: parent_id)

        errors.add(:parent_id, '循環が発生しています')
      end
    end
  end
end
