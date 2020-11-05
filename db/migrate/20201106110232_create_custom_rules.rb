# frozen_string_literal: true

class CreateCustomRules < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_rules do |t|
      t.references :website, null: false, index: true, foreign_key: true
      t.text :condition, null: false
      t.text :pattern, null: false
      t.jsonb :paths, null: false, default: []

      t.timestamps
    end
  end
end
