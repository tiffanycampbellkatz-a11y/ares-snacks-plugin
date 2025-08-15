
module AresMUSH
  module Snacks
    class EatSnackCmd
      include CommandHandler

      attr_accessor :snack

      def parse_args
        self.snack = cmd.args ? cmd.args.strip : nil
      end

      def required_args
        [ self.snack ]
      end

      def handle
        key = Snacks.find_snack_key(self.snack)
        if key.nil?
          client.emit_failure t('snacks.invalid_snack')
          return
        end

        if !Snacks.remove_from_inventory(enactor, key, 1)
          client.emit_failure t('snacks.no_snack_in_inventory', snack: Snacks.snack_label(key))
          return
        end

        client.emit_success t('snacks.snack_eaten_you', snack: Snacks.snack_label(key), flavor: Snacks.flavor_for(key, 'eat'))
        enactor_room.emit_ooc t('snacks.snack_eaten_emit', name: enactor.name, snack: Snacks.snack_label(key), flavor: Snacks.flavor_for(key, 'eat')) if enactor_room
      end
    end
  end
end
