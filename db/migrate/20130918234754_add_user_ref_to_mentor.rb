class AddUserRefToMentor < ActiveRecord::Migration
  def change
    add_reference :mentors, :user, index: true
  end
end
