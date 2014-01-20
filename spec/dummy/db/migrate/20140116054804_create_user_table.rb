class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, :last_name
      t.integer :age
    end
  end
end
