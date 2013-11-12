class AddAggregateColsToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :avg_call_duration, :decimal
    add_column :mentors, :avg_rating, :decimal
    add_column :mentors, :total_reviews, :integer
  end
end
