require 'rubygems'
require 'exceptional'

# Re-definitions are appended to existing tasks
namespace :jobs do
  desc "Clear the delayed_job queue."
  task :clear do
    Delayed::Job.delete_all
  end

  desc "Start a delayed_job worker."
  task :work do
    Delayed::Worker.new.start
  end
end
