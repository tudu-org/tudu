class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :task_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.string :description
      t.integer :priority
      t.datetime :deadline
      t.belongs_to :user

      t.timestamps
    end
  end
end
