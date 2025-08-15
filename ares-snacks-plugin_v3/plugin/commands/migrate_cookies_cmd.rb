
module AresMUSH
  module Snacks
    class MigrateCookiesCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') unless enactor && enactor.has_permission?("manage")
        return nil
      end

      def handle
        converted = 0
        Character.all.each do |char|
          begin
            total = CookieAward.find(recipient_id: char.id).count
            next if total <= 0
            inv = (char.snack_inventory || {})
            key = 'turnover cookies'
            inv[key] = (inv[key] || 0) + total
            char.update(snack_inventory: inv)
            converted += total
          rescue Exception => e
            Global.logger.error "Snack migrate error for #{char.name}: #{e}"
          end
        end
        client.emit_success t('snacks.migrate_done', total: converted)
      end
    end
  end
end
