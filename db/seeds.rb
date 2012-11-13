# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


u1 = User.new email: 'r@bc.de', :password => 'password1', :password_confirmation => 'password1'
u1.save!
u2 = User.new email: 'a@bc.de', :password => 'password1', :password_confirmation => 'password1'
u2.save!
u3 = User.new email: 'b@bc.de', :password => 'password1', :password_confirmation => 'password1'
u3.save!
User.create! email: 'c@bc.de', :password => 'password1', :password_confirmation => 'password1'


Transaction.create! :amount => 22, :creditor_id => u1.id, :debtor_ids => [u2.id, u3.id]