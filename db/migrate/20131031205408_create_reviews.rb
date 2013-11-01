class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :review
      t.decimal :rating
      t.references :mentor, index: true
      t.references :member, index: true
      t.references :call, index: true

      t.timestamps
    end
  end
end
