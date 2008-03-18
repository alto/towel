class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer       :project_id
      t.integer       :card_id
      t.string        :event_type
      t.string        :from
      t.string        :to
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
