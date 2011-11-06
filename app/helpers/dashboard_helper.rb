module DashboardHelper

  def dept_status_for(user1, user2)
    ids = Transaction.for_users(user1, user2).value_of :id
    TransactionRecord.where(:participant_id => user2.id, :transaction_id => ids).sum(:amount)
  end

end
