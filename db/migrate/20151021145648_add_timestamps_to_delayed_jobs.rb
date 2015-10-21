class AddTimestampsToDelayedJobs < ActiveRecord::Migration
  def change
    change_table :delayed_jobs do |table|
      table.timestamps null: false
    end
  end
end
