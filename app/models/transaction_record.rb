class TransactionRecord < ActiveRecord::Base

  belongs_to :transaction

  scope :for_transaction, ->(transaction_id) { where(transaction_id: transaction_id)}

end
