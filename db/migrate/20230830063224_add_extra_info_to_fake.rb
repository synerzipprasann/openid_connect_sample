class AddExtraInfoToFake < ActiveRecord::Migration
  def change
    add_column :connect_fakes, :profile, :string
    add_column :connect_fakes, :locale, :string
    add_column :connect_fakes, :phone_number, :string
    add_column :connect_fakes, :verified, :boolean
    add_column :connect_fakes, :email, :string
    add_column :connect_fakes, :password, :string
    add_column :connect_fakes, :name, :string
  end
end
