module DashboardHelper

  def show_debtors_for_transaction(transaction)
    list = transaction.transaction_records.collect do |record|
      "#{User.find(record.debtor_id).email} (<span class='red'>#{number_to_currency(record.amount, :locale => :fr)}</span>)"
    end
    list.join(", ").html_safe
  end

  def show_creditors_for_transaction(transaction)
    amount = transaction.transaction_records.sum(:amount)
    "#{User.find(transaction.transaction_records.first.creditor_id).email} (<span class='green'>#{number_to_currency(amount, :locale => :fr)}</span>)".html_safe
  end

end
