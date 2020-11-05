# frozen_string_literal: true

class CreateWebsitePages < ActiveRecord::Migration[6.1]
  def change
    create_table :website_pages do |t|
      t.references :website, null: false, index: false, foreign_key: true
      t.text :title, null: false
      t.text :url, null: false
      t.text :sha1, null: false
      t.text :lang, null: false
      t.text :status, null: false
      t.datetime :deleted_at
      t.index %i[website_id url], unique: true, where: '(deleted_at IS NULL)'
      t.index %i[website_id url sha1], unique: true
      t.index :created_at, using: :brin

      t.timestamps
    end
  end
end
