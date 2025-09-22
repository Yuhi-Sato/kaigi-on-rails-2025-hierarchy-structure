# frozen_string_literal: true

require 'active_record'

module Models
  module WithRecursive
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
        return [] if parent_id.blank?

        Folder.with_recursive(
          ancestors: [
            Folder.where(id: parent_id),
            Folder.joins('JOIN ancestors ON folders.id = ancestors.parent_id')
          ]
        ).select('ancestors.*').from('ancestors')
      end

      def descendants
        return [] if child_folders.blank?

        Folder.with_recursive(
          descendants: [
            Folder.where(id: child_folders),
            Folder.joins('JOIN descendants ON folders.parent_id = descendants.id')
          ]
        ).select('descendants.*').from('descendants')
      end

      private

      def no_cyclic
        if parent_id == id
          errors.add(:parent_id, '自分自身を親にはできません')
          return
        end

        descendants = Folder.with_recursive(
          descendants: [
            Folder.where(id: child_folders),
            Folder.joins('JOIN descendants ON folders.parent_id = descendants.id')
          ]
        ).select('descendants.*').from('descendants')

        return unless descendants.where('descendants.id = ?', parent_id).exists?

        errors.add(:parent_id, '循環が発生しています')
      end
    end
  end
end
