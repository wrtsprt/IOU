class Transaction < ActiveRecord::Base

  validates_presence_of :amount

  has_many :transaction_records, :dependent => :destroy

  after_save :create_dependent_records

  scope :for_user, ->(user) {
    joins("JOIN `transaction_records` ON `transaction_records`.`transaction_id` = `transactions`.`id`")
    .where(['`transaction_records`.creditor_id = ? OR `transaction_records`.debtor_id = ?', user.id, user.id])
  }

  scope :for_users, ->(user1, user2) {
    joins("JOIN `transaction_records` ON `transaction_records`.`transaction_id` = `transactions`.`id`").where(['`transaction_records`.creditor_id = ? AND `transaction_records`.debtor_id = ? OR `transaction_records`.creditor_id = ? AND `transaction_records`.debtor_id = ?', user1.id, user2.id, user2.id, user1.id])
  }

  def debtor
    TransactionRecord.for_transaction(self.id).value_of :debtor_id
  end

  def debtor=(id)
    @participant = id
  end

  def creditor
    TransactionRecord.for_transaction(self.id).value_of :creditor_id
  end

  def creditor=(id)
    @payer = id
  end

  private

  def remove_dependent_records
    TransactionRecord.for_transaction(self.id).destroy_all
  end

  def create_dependent_records
    self.transaction_records.destroy_all
    TransactionRecord.new(:transaction_id => self.id, :creditor_id => @payer, :debtor_id => @participant, :amount => self.amount).save!
  end

end
