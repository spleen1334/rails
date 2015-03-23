class CreateUsers < ActiveRecord::Migration
  def up
    # create_table :users, { id: false } do |t| # suppress AI primary key
    create_table :users do |t|
      t.column 'first_name', :string, :limit => 25 # long version
      t.string 'last_name', :limit => 50
      t.string 'email', default: '', null: false
      t.string 'password', limit: 40

      # Long
      # t.datetime 'created_at'
      # t.datetime 'updated_at'
      t.timestamps # short
    end
  end

  def down
    drop_table :users
  end
end

# Table column types:
# binary, boolean, date, datetime, decimal, float, integer, string, text, time
#
# Table column options:
# :limit     => size
# :default   => value
# :null      => true/false
# :precision => number
# :scale     => number
