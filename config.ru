require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride #in order to use patch, put, and delete requests
run ApplicationController
use UserAppController
use EntryAppController