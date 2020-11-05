# frozen_string_literal: true

class CreateWebsites < ActiveRecord::Migration[6.0]
  def change
    create_table :websites do |t|
      t.citext :domain, null: false, index: { unique: true }
      t.citext :slug, null: false, index: { unique: true }
      t.citext :url, null: false
      t.text :status, null: false
      t.jsonb :preferences, null: false, default: {}

      t.timestamps
    end
  end
end
