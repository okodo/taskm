class CreateTasks < ActiveRecord::Migration

  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.belongs_to :user, index: true
      t.string :state

      t.timestamps null: false
    end
  end

end
