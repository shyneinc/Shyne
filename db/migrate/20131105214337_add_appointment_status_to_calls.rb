class AddAppointmentStatusToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :appointment_status, :string
  end
end
