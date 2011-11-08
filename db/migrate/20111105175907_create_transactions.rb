class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name
      t.decimal :amount, :precision => 8, :scale => 2, :null => false

      t.timestamps
    end
  end
end
