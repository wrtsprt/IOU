require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  test "simple transaction with one participant" do
    Transaction.create! :name => "transaction1", :creditor => User.first.id, :debtor => User.last.id, :amount => 10
    assert_equal 0,  User.first.owes(User.last)
    assert_equal 10, User.last.owes(User.first).to_i

    Transaction.create! :name => "transaction2", :creditor => User.last.id, :debtor => User.first.id, :amount => 5.5
    assert_equal 5.5,  User.first.owes(User.last).to_f
    assert_equal 10,    User.last.owes(User.first), User.last.owes(User.first).to_i
  end


end
