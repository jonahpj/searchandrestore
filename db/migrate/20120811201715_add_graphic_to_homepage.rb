class AddGraphicToHomepage < ActiveRecord::Migration
  def self.up
    add_column :homepages, :graphic, :text
  end

  def self.down
    remove_column :homepages, :graphic
  end
end
