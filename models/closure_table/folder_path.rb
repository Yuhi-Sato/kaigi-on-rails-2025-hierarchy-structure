# frozen_string_literal: true

require 'active_record'

module Models
  module ClosureTable
    class FolderPath < ActiveRecord::Base
      belongs_to :ancestor, class_name: 'Folder'
      belongs_to :descendant, class_name: 'Folder'
    end
  end
end
