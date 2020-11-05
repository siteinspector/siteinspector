# frozen_string_literal: true

class CreateCrawlSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :crawl_sessions do |t|
      t.references :website, null: false, index: true, foreign_key: true
      t.integer :enqueued_count, null: false, default: 0
      t.integer :processed_count, null: false, default: 0
      t.integer :error_count, null: false, default: 0
      t.text :status, null: false

      t.timestamps
    end
  end
end
