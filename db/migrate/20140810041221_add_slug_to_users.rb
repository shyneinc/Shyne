class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string

    User.all.each{ |u| u.save }
  end
end
