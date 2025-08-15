
module AresMUSH
  module Snacks
    class << self
      # Looks up a snack definition by key, case-insensitive, matching exact keys or labels.
      def find_snack_key(name)
        return nil if name.nil?
        n = name.downcase.strip
        defs = get_snack_defs
        return nil if !defs || defs.empty?
        return n if defs.keys.map(&:downcase).include?(n)
        # also allow aliases array on each snack
        defs.each do |key, data|
          aliases = (data['aliases'] || []).map { |a| a.downcase }
          return key if aliases.include?(n)
        end
        nil
      end

      def snack_label(key)
        defs = get_snack_defs
        data = defs[key] || {}
        data['label'] || key.titlecase
      end

      def flavor_for(key, action)
        defs = get_snack_defs
        data = defs[key] || {}
        (data[action] || data[action.to_s] || '').to_s
      end

      def add_to_inventory(char, key, qty=1)
        inv = (char.snack_inventory || {})
        inv[key] = (inv[key] || 0) + qty
        char.update(snack_inventory: inv)
      end

      def remove_from_inventory(char, key, qty=1)
        inv = (char.snack_inventory || {})
        return false unless inv[key] && inv[key] >= qty
        inv[key] -= qty
        inv.delete(key) if inv[key] <= 0
        char.update(snack_inventory: inv)
        true
      end

      def inventory_list(char)
        inv = (char.snack_inventory || {})
        inv.keys.sort.map { |k| [k, inv[k]] }
      end

      def give_snack(recipient, giver, key)
        return t('snacks.cant_give_yourself') if recipient == giver
        add_to_inventory(recipient, key, 1)
        message = t('snacks.snack_received', name: giver.name, snack: snack_label(key), flavor: flavor_for(key, 'give'))
        recipient.client.emit_if_logged_in message rescue nil
        Global.dispatcher.queue_event CharIdledEvent.new(recipient) rescue nil
        nil
      rescue Exception => e
        Global.logger.error "Error giving snack: #{e} #{e.backtrace[0,10]}"
        t('snacks.error')
      end
    end
  end
end
