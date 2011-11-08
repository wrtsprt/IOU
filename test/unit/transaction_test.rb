require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  test "simple transaction with one participant" do
    Transaction.create! :name => "transaction1", :creditor => User.first.id, :debtors => [User.last.id], :amount => 10
    assert_equal 0,  User.first.owes(User.last)
    assert_equal 10, User.last.owes(User.first).to_i

    Transaction.create! :name => "transaction2", :creditor => User.last.id, :debtors => [User.first.id], :amount => 5.5
    assert_equal 5.5,  User.first.owes(User.last).to_f
    assert_equal 10,    User.last.owes(User.first), User.last.owes(User.first).to_i
  end

  test "split bill" do
    Transaction.create! :name => "transaction1", :creditor => User.first.id, :debtors => [2,3,4], :amount => 9

    assert_equal 3,  User.find(2).owes(User.first).to_f
    assert_equal 3,  User.find(3).owes(User.first).to_f
    assert_equal 3,  User.find(4).owes(User.first).to_f
    assert_equal 0,  User.find(1).owes(User.find(2))
  end

  test "split bill with uneven result" do
    Transaction.create! :name => "transaction1", :creditor => User.first.id, :debtors => [2,3,4], :amount => 8.1

    sum = User.find(2).owes(User.first) + User.find(3).owes(User.first) + User.find(4).owes(User.first)
    assert_equal 8.1, sum
    assert_equal 0, User.find(1).owes(User.find(2))
  end

  test "split bill with uneven result 1" do
    Transaction.create! :name => "transaction1", :creditor => User.first.id, :debtors => [2,3,4], :amount => 7.8

    sum = User.find(2).owes(User.first) + User.find(3).owes(User.first) + User.find(4).owes(User.first)
    assert_equal 7.8, sum
    assert_equal 0, User.find(1).owes(User.find(2))
  end

  test "split bill with uneven result 2" do
    Transaction.create! :name => "transaction1", :creditor => User.first.id, :debtors => [2,3,4], :amount => 7.9

    sum = User.find(2).owes(User.first) + User.find(3).owes(User.first) + User.find(4).owes(User.first)
    assert_equal 7.9, sum
    assert_equal 0, User.find(1).owes(User.find(2))
  end

end
