module TransactionsHelper

  def show_records_list(records)
    lines = []
    records.each do |record|
      user = User.find(record.participant_id)
      lines << "#{user.email} (#{number_to_currency(record.amount, :locale => :fr)})"
    end

    "<div>#{lines.join(',')}</div>".html_safe
  end

end
