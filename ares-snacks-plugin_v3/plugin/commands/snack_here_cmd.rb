
module AresMUSH
  module Snacks
    class SnackHereCmd
      include CommandHandler

      attr_accessor :snack

      def parse_args
        if cmd.args =~ /here=(.+)/i
          self.snack = $1.strip
        else
          self.snack = nil
        end
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
        if !enactor_room
          client.emit_failure t('snacks.invalid_room')
          return
        end
        recipients = enactor_room.characters.select { |c| c != enactor }
        if recipients.empty?
          client.emit_ooc t('snacks.no_recipients_here')
          return
        end
        recipients.each do |char|
          error = Snacks.give_snack(char, enactor, key)
          client.emit_failure error if error
        end
        enactor_room.emit_ooc t('snacks.snack_give_here_emit', name: enactor.name, snack: Snacks.snack_label(key), flavor: Snacks.flavor_for(key, 'give'))
        client.emit_success t('snacks.snack_given_here', count: recipients.count, snack: Snacks.snack_label(key))
      end
    end
  end
end
