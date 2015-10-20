# don't do this in production
if (Rails.env.development? or Rails.env.test?) and
    # don't do this in a worker or task
    !defined?(Rake)  # SEE BELOW FOR POSSIBLE FIX

  migrations_paths = ActiveRecord::Migrator.migrations_paths
  migrator = ActiveRecord::Migrator.new(:up, migrations_paths, nil)
  pending_migrations = migrator.pending_migrations
  unless pending_migrations.empty?
    puts "Migrating from #{migrator.current_version} to #{pending_migrations.last.version}"
    migrator.migrate

    require 'active_record/schema_dumper'
    filename = ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::Base.establish_connection(Rails.env)
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end

  end

end