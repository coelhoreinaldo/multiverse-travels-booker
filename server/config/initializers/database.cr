require "jennifer"
require "jennifer/adapter/mysql"

APP_ENV = ENV["APP_ENV"]? || "development"
Jennifer::Config.configure do |conf|
  conf.read("config/database.yml", APP_ENV)
  conf.from_uri(ENV["DATABASE_URI"]) if ENV.has_key?("DATABASE_URI")
  conf.logger.level = if APP_ENV == "development"
                        Log::Severity::Debug
                      else
                        Log::Severity::Error
                      end
end

Log.setup "db", :debug, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)
