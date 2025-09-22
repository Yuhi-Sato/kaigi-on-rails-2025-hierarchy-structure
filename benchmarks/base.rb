# frozen_string_literal: true

require 'benchmark'

require_relative '../db/connection'
require_relative '../seeds/binary_trees'

module Benchmarks
  class Base
    def self.run
      DB::Connection.establish_connection
      # NOTE: 継承先でベンチマークを実装する
    end
  end
end
