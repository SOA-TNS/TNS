# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:gtvalues) do
      primary_key :id
      foreign_key :query, :stock

      Integer     :values, null: false
      DateTime    :date

      DateTime :created_at
      DateTime :processed_at
    end
  end
end