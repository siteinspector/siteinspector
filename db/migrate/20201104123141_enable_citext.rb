# frozen_string_literal: true

class EnableCitext < ActiveRecord::Migration[6.0]
  def up
    enable_extension 'citext'
  end

  def down
    disable_extension 'citext'
  end
end
