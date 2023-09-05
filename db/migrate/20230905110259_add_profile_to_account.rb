class AddProfileToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :phone_number, :string
    add_column :accounts, :verified, :boolean
    add_column :accounts, :name, :string
    add_column :accounts, :dob, :date
  end
end
