class TransactionRecord < ActiveRecord::Base

  scope :payers,       where('amount > 0')
  scope :participants, where('amount < 0')

  scope :for_transaction, ->(transaction_id) { where(transaction_id: transaction_id)}

end
