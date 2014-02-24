class CreateRecurringEvents < ActiveRecord::Migration
  def change
    create_table :recurring_events do |t|
      t.datetime :recurring_start_time
      t.datetime :recurring_end_time
      t.time :start_time
      t.time :end_time
      t.boolean :every_monday
      t.boolean :every_tuesday
      t.boolean :every_wednesday
      t.boolean :every_thursday
      t.boolean :every_friday
      t.boolean :every_saturday
      t.boolean :every_sunday
      t.integer :weeks_between
      t.string :name
      t.text :description

      t.belongs_to :user

      t.timestamps
    end
  end
end
