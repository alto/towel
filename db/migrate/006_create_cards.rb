class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string      :title
      t.text        :description
      t.integer     :effort
      t.integer     :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
