require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(2.hours, 'Calculate billable call durations') { Delayed::Job.enqueue CalcBillableDurationJob.new }
every(1.day, 'Process payment', :at => '00:00') { Delayed::Job.enqueue ProcessPaymentJob.new }