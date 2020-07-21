class RemoveDelayedJobs < ActiveRecord::Migration[6.0]
  # rubocop:disable Metrics/MethodLength
  def change
    drop_table 'delayed_jobs', id: :serial, force: :cascade do |t|
      t.integer 'priority', default: 0, null: false
      t.integer 'attempts', default: 0, null: false
      t.text 'handler', null: false
      t.text 'last_error'
      t.datetime 'run_at'
      t.datetime 'locked_at'
      t.datetime 'failed_at'
      t.string 'locked_by'
      t.string 'queue', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index %w[priority run_at], name: 'delayed_jobs_priority'
    end
  end
  # rubocop:enable Metrics/MethodLength
end
