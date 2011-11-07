class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  scope :without, ->(user) { where ['id != ?', user.id] }

  def owes(other_user)
    TransactionRecord.where(:creditor_id => other_user.id, :debtor_id => self.id).sum(:amount)
  end

end
