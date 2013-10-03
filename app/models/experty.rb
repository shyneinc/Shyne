class Experty < ActiveRecord::Base
  belongs_to :mentor
  belongs_to :industry
end
