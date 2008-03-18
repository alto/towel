class CardsAddStartedAt < ActiveRecord::Migration
  def self.up
    add_column :cards, :started_at, :datetime
  end

  def self.down
    remove_column :cards, :started_at
  end
end
