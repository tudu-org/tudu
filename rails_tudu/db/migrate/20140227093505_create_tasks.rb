class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.text :description
      t.integer :priority
      t.datetime :deadline

      t.timestamps
    end
  end
end
