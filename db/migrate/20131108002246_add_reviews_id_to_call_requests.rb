class AddReviewsIdToCallRequests < ActiveRecord::Migration
  def change
    add_column :reviews, :call_request_id, :integer
  end
end
