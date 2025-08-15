
module AresMUSH
  module Snacks
    class SnackCmd
      include CommandHandler

      attr_accessor :names, :snack

      def parse_args
        if cmd.args =~ /(.+?)=(.+)/
          self.names = $1.split(' ')
          self.snack = $2.strip
        else
          self.names = []
          self.snack = nil
        end
      end

      def required_args
        [ self.names, self.snack ]
      end

      def check_snack_exists
        key = Snacks.find_snack_key(self.snack)
        return t('snacks.invalid_snack') if key.nil?
        return nil
      end

      def handle
        key = Snacks.find_snack_key(self.snack)
        self.names.each do |name|
          result = Character.find_one_by_name(name)
          if !result
            client.emit_failure t('snacks.invalid_recipient', name: name)
            next
          end

          error = Snacks.give_snack(result, enactor, key)
          if error
            client.emit_failure error
          else
            client.emit_success t('snacks.snack_given', name: result.name, snack: Snacks.snack_label(key))
            message = t('snacks.snack_give_emit', name: enactor.name, target: result.name, snack: Snacks.snack_label(key), flavor: Snacks.flavor_for(key, 'give'))
            enactor_room.emit_ooc message if enactor_room
          end
        end
      end
    end
  end
end
