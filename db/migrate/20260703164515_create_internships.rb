class CreateInternships < ActiveRecord::Migration[8.1]
  def change
    create_table :internships do |t|
      t.string :title
      t.text :description
      t.string :location
      t.integer :mode
      t.integer :duration_weeks
      t.decimal :monthly_stipend
      t.date :application_deadline
      t.integer :status
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
