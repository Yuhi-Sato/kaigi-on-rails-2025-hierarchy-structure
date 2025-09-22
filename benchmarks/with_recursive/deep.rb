# frozen_string_literal: true

require_relative '../base'
require_relative 'with_recursive'

module Benchmarks
  module WithRecursive
    class Deep < Base
      def self.run
        super

        root = Folder.find_by(name: "#{Seeds::BinaryTrees::DEEP_NODE_NAME_PREFIX}_0_0")
        leaf = Folder.find_by(name: "#{Seeds::BinaryTrees::DEEP_NODE_NAME_PREFIX}_13_0")

        Benchmark.bm do |x|
          x.report('With Recursive Deep') do
            root.descendants.where('descendants.id = ?', leaf.id).exists?
          end
        end
      end
    end
  end
end

Benchmarks::WithRecursive::Deep.run
