class AddIndustriesToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :industries, :string, :after => :experties
    add_column :mentors, :programs, :string, :after => :industries
  end
end
