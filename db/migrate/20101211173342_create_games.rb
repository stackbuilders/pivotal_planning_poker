class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :tracker_story_id, :null => false
      t.integer :tracker_estimate

      t.boolean :revealed, :null => false, :default => false
      t.string :revealed_last_changed_by
      t.text :estimates

      t.timestamps
    end

    add_index :games, :tracker_story_id, :unique => true
  end

  def self.down
    drop_table :games
  end
end
