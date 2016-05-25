class CreateAttachments < ActiveRecord::Migration

  def change
    create_table :attachments do |t|
      t.string :data_file
      t.belongs_to :task, index: true
      t.timestamps null: false
    end
  end

end
