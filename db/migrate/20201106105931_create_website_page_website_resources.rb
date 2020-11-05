# frozen_string_literal: true

class CreateWebsitePageWebsiteResources < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :website_page_website_resources do |t|
      t.references :website_page, null: false, foreign_key: true, index: false
      t.references :website_resource, foreign_key: true, index: true
      t.boolean :is_resolved, default: false, null: false

      t.index %i[website_page_id website_resource_id],
              name: 'website_page_website_resources_index', unique: true
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
