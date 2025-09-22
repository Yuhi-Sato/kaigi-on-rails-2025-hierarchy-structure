# frozen_string_literal: true

require_relative '../db/connection'
require_relative './binary_trees'

DB::Connection.establish_connection

Seeds::BinaryTrees.create_medium_binary_tree
