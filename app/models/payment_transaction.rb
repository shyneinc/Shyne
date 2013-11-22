class PaymentTransaction < ActiveRecord::Base
  validates :call_request, :type, :amount, :status, :uri, presence: true

  belongs_to :call_request
end
