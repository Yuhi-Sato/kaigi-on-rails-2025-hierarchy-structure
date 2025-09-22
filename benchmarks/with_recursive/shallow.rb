# frozen_string_literal: true

require_relative '../base'
require_relative 'with_recursive'

module Benchmarks
  module WithRecursive
    class Shallow < Benchmarks::Base
      def self.run
        super

        root = Folder.find_by(name: "#{Seeds::BinaryTrees::SHALLOW_NODE_NAME_PREFIX}_0_0")
        leaf = Folder.find_by(name: "#{Seeds::BinaryTrees::SHALLOW_NODE_NAME_PREFIX}_6_0")

        Benchmark.bm do |x|
          x.report('With Recursive Shallow') do
            root.descendants.where('descendants.id = ?', leaf.id).exists?
          end
        end
      end
    end
  end
end

Benchmarks::WithRecursive::Shallow.run
