# frozen_string_literal: true

require_relative '../base'
require_relative 'closure_table'

module Benchmarks
  module ClosureTable
    class Medium < Benchmarks::Base
      def self.run
        super

        root = Folder.find_by(name: "#{Seeds::BinaryTrees::MEDIUM_NODE_NAME_PREFIX}_0_0")
        leaf = Folder.find_by(name: "#{Seeds::BinaryTrees::MEDIUM_NODE_NAME_PREFIX}_9_0")

        Benchmark.bm do |x|
          x.report('Closure Table Medium') do
            root.descendant_paths.exists?(descendant_id: leaf.id)
          end
        end
      end
    end
  end
end

Benchmarks::ClosureTable::Medium.run
