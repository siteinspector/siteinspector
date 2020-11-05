# frozen_string_literal: true

class CreateWebsitePageErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :website_page_errors do |t|
      t.references :website_page, null: false, foreign_key: true, index: true
      t.text :text, null: false
      t.text :correction, null: false
      t.text :error_type, null: false
      t.text :context, null: false
      t.text :status, null: false

      t.timestamps

      t.index :created_at, using: :brin
      t.index %i[text context website_page_id],
              name: 'website_page_errors_text_context_website_page_id_unique_index',
              unique: true
    end
  end
end
