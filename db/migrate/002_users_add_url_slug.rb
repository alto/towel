class UsersAddUrlSlug < ActiveRecord::Migration
  def self.up
    add_column :users, :url_slug, :string
  end

  def self.down
    remove_column :users, :url_slug
  end
end
