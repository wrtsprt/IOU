class IdValidator < ActiveModel::Validator
  # implement the method where the validation logic must reside
  def validate(record)

    if record.debtor_ids.uniq.count != record.debtor_ids.count
      record.errors[:debtors] << "Every user can participate only once in a bill."
    end

  end
end