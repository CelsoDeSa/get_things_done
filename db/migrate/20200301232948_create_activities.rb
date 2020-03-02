class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.string :name
      t.date :begin
      t.date :end
      t.boolean :finished
      t.belongs_to :project, foreign_key: true

      t.timestamps
    end
  end
end
