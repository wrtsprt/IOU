require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  test "simple transaction with one participant" do
    Transaction.create! :name => "transaction1", :creditor_id => User.find(1).id, :debtor_ids => [User.find(4).id], :amount => 10
    assert_equal 0,  User.find(1).owes(User.find(4))
    assert_equal 10, User.find(4).owes(User.find(1)).to_i

    Transaction.create! :name => "transaction2", :creditor_id => User.find(4).id, :debtor_ids => [User.find(1).id], :amount => 5.5
    assert_equal 5.5,  User.find(1).owes(User.find(4)).to_f
    assert_equal 10,    User.find(4).owes(User.find(1)), User.find(4).owes(User.find(1)).to_i
  end

  test "split bill" do
    Transaction.create! :name => "transaction1", :creditor_id => 1, :debtor_ids => [2,3,4], :amount => 9

    assert_equal 3,  User.find(2).owes(User.find(1)).to_f
    assert_equal 3,  User.find(3).owes(User.find(1)).to_f
    assert_equal 3,  User.find(4).owes(User.find(1)).to_f
    assert_equal 0,  User.find(1).owes(User.find(2))
  end

  test "split bill with creditor participating" do
    Transaction.create! :name => "transaction1", :creditor_id => 1, :debtor_ids => [1,2,3,4], :amount => 12

    assert_equal 3,  User.find(2).owes(User.find(1)).to_f
    assert_equal 3,  User.find(3).owes(User.find(1)).to_f
    assert_equal 3,  User.find(4).owes(User.find(1)).to_f
    assert_equal 0,  User.find(1).owes(User.find(2))
  end

  test "split bill with uneven result" do
    Transaction.create! :name => "transaction1", :creditor_id => 1, :debtor_ids => [2,3,4], :amount => 8.1

    sum = User.find(2).owes(User.find(1)) + User.find(3).owes(User.find(1)) + User.find(4).owes(User.find(1))
    assert_equal 8.1, sum
    assert_equal 0, User.find(1).owes(User.find(2))
  end

  test "split bill with uneven result 1" do
    Transaction.create! :name => "transaction1", :creditor_id => 1, :debtor_ids => [2,3,4], :amount => 7.8

    sum = User.find(2).owes(User.find(1)) + User.find(3).owes(User.find(1)) + User.find(4).owes(User.find(1))
    assert_equal 7.8, sum
    assert_equal 0, User.find(1).owes(User.find(2))
  end

  test "split bill with uneven result 2" do
    Transaction.create! :name => "transaction1", :creditor_id => 1, :debtor_ids => [2,3,4], :amount => 7.9

    sum = User.find(2).owes(User.find(1)) + User.find(3).owes(User.find(1)) + User.find(4).owes(User.find(1))
    assert_equal 7.9, sum
    assert_equal 0, User.find(1).owes(User.find(2))
  end

end
