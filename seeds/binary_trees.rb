# frozen_string_literal: true

require_relative '../models/closure_table'

module Seeds
  module BinaryTrees
    SHALLOW_TREE_HEIGHT = 6
    MEDIUM_TREE_HEIGHT = 9
    DEEP_TREE_HEIGHT = 13

    public_constant :SHALLOW_TREE_HEIGHT, :MEDIUM_TREE_HEIGHT, :DEEP_TREE_HEIGHT

    SHALLOW_NODE_NAME_PREFIX = 'shallow_tree_node'
    MEDIUM_NODE_NAME_PREFIX = 'medium_tree_node'
    DEEP_NODE_NAME_PREFIX = 'deep_tree_node'

    public_constant :SHALLOW_NODE_NAME_PREFIX,
                    :MEDIUM_NODE_NAME_PREFIX,
                    :DEEP_NODE_NAME_PREFIX

    # NOTE: folder_paths を作成するため、closure_table の Folder モデルを使用する
    Folder = Models::ClosureTable::Folder
    FolderPath = Models::ClosureTable::FolderPath

    private_constant :Folder, :FolderPath

    def self.create_shallow_binary_tree
      clear_shallow_binary_tree if Folder.exists?(name: "#{SHALLOW_NODE_NAME_PREFIX}_%")
      create_binary_tree(SHALLOW_TREE_HEIGHT, SHALLOW_NODE_NAME_PREFIX)
    end

    def self.create_medium_binary_tree
      clear_medium_binary_tree if Folder.exists?(name: "#{MEDIUM_NODE_NAME_PREFIX}_%")
      create_binary_tree(MEDIUM_TREE_HEIGHT, MEDIUM_NODE_NAME_PREFIX)
    end

    def self.create_deep_binary_tree
      clear_deep_binary_tree if Folder.exists?(name: "#{DEEP_NODE_NAME_PREFIX}_%")
      create_binary_tree(DEEP_TREE_HEIGHT, DEEP_NODE_NAME_PREFIX)
    end

    def self.clear_shallow_binary_tree
      Folder.where(name: "#{SHALLOW_NODE_NAME_PREFIX}_%").destroy_all
    end

    def self.clear_medium_binary_tree
      Folder.where(name: "#{MEDIUM_NODE_NAME_PREFIX}_%").destroy_all
    end

    def self.clear_deep_binary_tree
      Folder.where(name: "#{DEEP_NODE_NAME_PREFIX}_%").destroy_all
    end

    def self.clear_all_binary_trees
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE folders RESTART IDENTITY CASCADE')
      ActiveRecord::Base.connection.execute('TRUNCATE TABLE folder_paths RESTART IDENTITY CASCADE')
    end

    # NOTE: 0-based indexing で深さをカウントする
    def self.create_binary_tree(height, node_name_prefix)
      Folder.transaction do
        (2**(height + 1))

        root = Folder.create!(name: "#{node_name_prefix}_0_0", parent_id: nil)

        current_level_nodes = [root]

        (1..height).each do |level|
          next_level_nodes = []
          node_count_at_level = 0

          current_level_nodes.each_with_index do |parent, _parent_index|
            left_child = Folder.create!(
              name: "#{node_name_prefix}_#{level}_#{node_count_at_level}",
              parent_folder: parent
            )
            next_level_nodes << left_child
            node_count_at_level += 1

            right_child = Folder.create!(
              name: "#{node_name_prefix}_#{level}_#{node_count_at_level}",
              parent_folder: parent
            )
            next_level_nodes << right_child
            node_count_at_level += 1
          end

          current_level_nodes = next_level_nodes
        end
      end
    end
  end
end
