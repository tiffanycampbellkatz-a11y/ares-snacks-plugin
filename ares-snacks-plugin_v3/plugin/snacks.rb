
$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Snacks
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("snacks", "shortcuts")
    end

    def self.get_snack_defs
      Global.read_config("snacks", "snacks") || {}
    end

    def self.allow_self_store?
      Global.read_config("snacks", "allow_self_store")
    end

    def self.locale_hash
      "snacks"
    end

    def self.plugin_version
      "0.1.0"
    end
  end
end

require 'helpers'
require 'commands/snack_cmd'
require 'commands/eat_snack_cmd'
require 'commands/snacks_cmd'
require 'commands/store_snack_cmd'
require 'public/snack_char'

require 'commands/snack_here_cmd'
require 'commands/snack_scene_cmd'
require 'commands/migrate_cookies_cmd'


# Web request handlers
begin
  WebRequestRouter.add_request_handler('profileSnacks', AresMUSH::Snacks::ProfileSnacksRequestHandler)
  WebRequestRouter.add_request_handler('eatSnack', AresMUSH::Snacks::EatSnackRequestHandler)
rescue Exception => e
  Global.logger.warn "Snacks web handlers not registered: #{e}"
end
