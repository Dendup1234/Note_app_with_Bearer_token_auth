class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website
      t.text :description
      t.references :recruiter, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
