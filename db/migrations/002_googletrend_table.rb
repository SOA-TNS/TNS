# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:stock) do
      primary_key :id
      foreign_key :query, :gtvalue

      
      DateTime :created_at
      DateTime :processed_at
    end
  end
end
