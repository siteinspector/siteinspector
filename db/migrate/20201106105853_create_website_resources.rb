# frozen_string_literal: true

class CreateWebsiteResources < ActiveRecord::Migration[6.1]
  def change
    create_table :website_resources do |t|
      t.references :website, null: false, foreign_key: true, index: false
      t.text :url, null: false
      t.text :effective_url, null: false
      t.text :status, null: false
      t.text :resource_type, null: false
      t.index %i[website_id url], unique: true
      t.index %i[website_id status]

      t.timestamps
    end
  end
end
