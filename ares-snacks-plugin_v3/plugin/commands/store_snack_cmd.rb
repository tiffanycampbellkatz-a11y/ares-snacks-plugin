
module AresMUSH
  module Snacks
    class StoreSnackCmd
      include CommandHandler

      attr_accessor :snack

      def parse_args
        self.snack = cmd.args ? cmd.args.strip : nil
      end

      def required_args
        [ self.snack ]
      end

      def check_allowed
        return nil if Snacks.allow_self_store?
        t('snacks.store_not_allowed')
      end

      def handle
        key = Snacks.find_snack_key(self.snack)
        if key.nil?
          client.emit_failure t('snacks.invalid_snack')
          return
        end
        Snacks.add_to_inventory(enactor, key, 1)
        client.emit_success t('snacks.snack_stored', snack: Snacks.snack_label(key), flavor: Snacks.flavor_for(key, 'store'))
      end
    end
  end
end
