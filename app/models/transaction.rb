class Transaction < ActiveRecord::Base

  validates_presence_of :amount

  after_create   :create_dependent_records
  before_destroy :remove_dependent_records


  def participants_records
    TransactionRecord.participants.for_transaction self.id
  end

  def participant
    TransactionRecord.participants.for_transaction(self.id).value_of :participant_id
  end

  def participant=(id)
    @participant = id
  end

  def payers_records
    TransactionRecord.payers.for_transaction self.id
  end

  def payer
    TransactionRecord.payers.for_transaction(self.id).value_of :participant_id
  end

  def payer=(id)
    @payer = id
  end

  private

  def remove_dependent_records
    TransactionRecord.for_transaction(self.id).destroy_all
  end

  def create_dependent_records
    TransactionRecord.new(:transaction_id => self.id, :participant_id => @participant, :amount => -1 * self.amount).save!
    TransactionRecord.new(:transaction_id => self.id, :participant_id => @payer,       :amount =>      self.amount).save!
  end

end
