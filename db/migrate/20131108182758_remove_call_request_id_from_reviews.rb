class RemoveCallRequestIdFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :call_request_id
  end
end
