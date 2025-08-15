
module AresMUSH
  module Snacks
    class SnacksCmd
      include CommandHandler

      def handle
        list = Snacks.inventory_list(enactor)
        if list.empty?
          client.emit_ooc t('snacks.inventory_empty')
          return
        end
        lines = list.map { |k,qty| "• #{Snacks.snack_label(k)} x#{qty}" }
        client.emit_ooc lines.join("%R")
      end
    end
  end
end
