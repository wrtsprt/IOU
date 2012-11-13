class Transaction < ActiveRecord::Base

  validates_presence_of :amount
  validates_with ::IdValidator

  has_many :transaction_records, :dependent => :destroy

  after_save :create_dependent_records

  scope :for_user, ->(user) {
    joins("JOIN transaction_records ON transaction_records.transaction_id = transactions.id")
    .where(['transaction_records.creditor_id = ? OR transaction_records.debtor_id = ?', user.id, user.id]).select("DISTINCT transactions.*")
  }

  scope :for_users, ->(user1, user2) {
    joins("JOIN transaction_records ON transaction_records.transaction_id = transactions.id").where(['`transaction_records`.creditor_id = ? AND `transaction_records`.debtor_id = ? OR `transaction_records`.creditor_id = ? AND `transaction_records`.debtor_id = ?', user1.id, user2.id, user2.id, user1.id])
  }

  def debtor_ids
    return @debtor_ids if @debtor_ids
    TransactionRecord.for_transaction(self.id).value_of :debtor_id
  end

  def debtor_ids=(ids)
    @debtor_ids = ids
  end

  def creditor_id
    return @creditor_id if @creditor_id
    TransactionRecord.for_transaction(self.id).value_of :creditor_id
  end

  def creditor_id=(id)
    @creditor_id = id
  end

  private

  def remove_dependent_records
    TransactionRecord.for_transaction(self.id).destroy_all
  end

  def create_dependent_records
    self.transaction_records.destroy_all

    debtor_ids_count = @debtor_ids.count
    amount_per_debtor = (amount / debtor_ids_count).round(2)

    uncorrected_sum = amount_per_debtor * debtor_ids_count
    if uncorrected_sum != amount
      multi = amount_per_debtor * debtor_ids_count
      rest = ((amount_per_debtor * debtor_ids_count - amount).abs / 0.01).to_i

      correction = uncorrected_sum > amount ? BigDecimal.new('-0.01') : BigDecimal.new('0.01')

      random_numbers = []
      while random_numbers.count < rest
        number = rand debtor_ids_count
        random_numbers << number unless random_numbers.include? number
      end
    end

    @debtor_ids.each_with_index do |participants_id, idx|
      amount_to_store = if random_numbers && random_numbers.include?(idx)
        amount_per_debtor + correction
      else
        amount_per_debtor
      end
      TransactionRecord.new(:transaction_id => self.id, :creditor_id => @creditor_id, :debtor_id => participants_id, :amount => amount_to_store).save!
    end
  end

end
