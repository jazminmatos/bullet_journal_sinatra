class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.date :date
      t.string :goal
      t.string :log
      t.string :gratitude
      t.integer :user_id
    end
  end
end
