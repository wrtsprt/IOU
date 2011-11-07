class CreateTransactionRecords < ActiveRecord::Migration
  def change
    create_table :transaction_records do |t|
      t.integer :transaction_id, :null => false

      t.integer :creditor_id, :null => false
      t.integer :debtor_id,  :null => false

      t.decimal :amount, :precision => 8, :scale => 2, :null => false

      t.timestamps
    end

  end
end
