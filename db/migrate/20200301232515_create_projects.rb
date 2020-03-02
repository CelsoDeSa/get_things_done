class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :begin
      t.date :end

      t.timestamps
    end
  end
end
