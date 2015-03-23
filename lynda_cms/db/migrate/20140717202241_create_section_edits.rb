class CreateSectionEdits < ActiveRecord::Migration
  def change
    create_table :section_edits do |t|
      # podsetnik: references isto sto i:
      # t.integer :admin_user_id
      t.references :admin_user
      t.references :section

      t.string :summary

      t.timestamps
    end

    add_index :section_edits, [ "admin_user_id", "section_id" ]
  end
end
