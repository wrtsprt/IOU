module DashboardHelper

  def show_debtors_for_transaction(transaction)
    show_participant_for_transaction(transaction, :debtor_id)
  end

  def show_creditors_for_transaction(transaction)
    show_participant_for_transaction(transaction, :creditor_id)
  end

  def show_participant_for_transaction(transaction, participant)
    list = transaction.transaction_records.collect do |record|
      "#{User.find(record.send participant).email} (#{number_to_currency(record.amount, :locale => :fr)})"
    end
    list.join(", ")
  end
end
