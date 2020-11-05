# frozen_string_literal: true

class CreateCustomRuleResults < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_rule_results do |t|
      t.references :custom_rule, null: false, index: false, foreign_key: true
      t.references :website_page, null: false, index: true, foreign_key: true
      t.text :message, null: false

      t.datetime :deleted_at
      t.timestamps

      t.index %i[custom_rule_id website_page_id message],
              name: 'custom_rule_results_text_context_website_page_id_unique_index',
              unique: true
    end
  end
end
