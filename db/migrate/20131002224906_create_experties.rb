class CreateExperties < ActiveRecord::Migration
  def change
    create_table :experties do |t|
      t.references :mentor
      t.references :industry

      t.timestamps
    end
  end
end
