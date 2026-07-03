class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :internship, null: false, foreign_key: true
      t.text :cover_note
      t.integer :status
      t.references :status_changed_by, foreign_key: { to_table: :users }
      t.datetime :status_changed_at

      t.timestamps
    end
    add_index :applications, [:student_id, :internship_id], unique: true
  end
end
