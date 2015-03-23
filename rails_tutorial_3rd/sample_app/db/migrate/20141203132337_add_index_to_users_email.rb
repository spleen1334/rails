class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true # index za db (tabela, column, attr)
  end
end
