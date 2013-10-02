class Industry < ActiveRecord::Base
  has_many :experties
  has_many :mentors, :through => :experties
end
