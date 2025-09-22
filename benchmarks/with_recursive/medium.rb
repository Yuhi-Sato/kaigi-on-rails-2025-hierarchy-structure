# frozen_string_literal: true

require_relative '../base'
require_relative 'with_recursive'

module Benchmarks
  module WithRecursive
    class Medium < Benchmarks::Base
      def self.run
        super

        root = Folder.find_by(name: "#{Seeds::BinaryTrees::MEDIUM_NODE_NAME_PREFIX}_0_0")
        leaf = Folder.find_by(name: "#{Seeds::BinaryTrees::MEDIUM_NODE_NAME_PREFIX}_9_0")

        Benchmark.bm do |x|
          x.report('With Recursive Medium') do
            root.descendants.where('descendants.id = ?', leaf.id).exists?
          end
        end
      end
    end
  end
end

Benchmarks::WithRecursive::Medium.run
