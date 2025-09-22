# frozen_string_literal: true

require_relative '../base'
require_relative 'adjacency_list'

module Benchmarks
  module AdjacencyList
    class Shallow < Benchmarks::Base
      def self.run
        super

        root = Folder.find_by(name: "#{Seeds::BinaryTrees::SHALLOW_NODE_NAME_PREFIX}_0_0")
        leaf = Folder.find_by(name: "#{Seeds::BinaryTrees::SHALLOW_NODE_NAME_PREFIX}_6_0")

        Benchmark.bm do |x|
          x.report('Adjacency List Shallow') do
            root.descendants.include?(leaf)
          end
        end
      end
    end
  end
end

Benchmarks::AdjacencyList::Shallow.run
