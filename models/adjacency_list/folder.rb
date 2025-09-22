# frozen_string_literal: true

require 'active_record'

module Models
  module AdjacencyList
    class Folder < ActiveRecord::Base
      belongs_to :parent_folder,
                 optional: true,
                 class_name: 'Folder',
                 foreign_key: :parent_id

      has_many :child_folders,
               class_name: 'Folder',
               foreign_key: :parent_id,
               inverse_of: :parent_folder,
               dependent: :destroy

      validate :no_cyclic, if: :will_save_change_to_parent_id?

      def ancestors
        return [] if parent_folder.blank?

        parent_folder.ancestors + [parent_folder]
      end

      def descendants
        child_folders + child_folders.map(&:descendants).flatten
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

      private

      def no_cyclic
        if parent_id == id
          errors.add(:parent_id, '自分自身を親にはできません')
          return
        end

        return unless descendants.include?(parent_folder)

        errors.add(:parent_id, '循環が発生しています')
      end
    end
  end
end
