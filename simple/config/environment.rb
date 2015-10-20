# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Migrate db
config.after_initialize do
  ActiveRecord::Migrator.migrate(Rails.root.join("db/migrate"), nil)
end
