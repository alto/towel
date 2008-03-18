class CardsAddDates < ActiveRecord::Migration
  def self.up
    add_column :cards, :finished_at, :datetime
  end

  def self.down
    remove_column :cards, :finished_at
  end
end
