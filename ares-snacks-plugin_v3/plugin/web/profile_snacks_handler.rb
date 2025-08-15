
module AresMUSH
  module Snacks
    class ProfileSnacksRequestHandler
      def handle(request)
        char = Character.find_one_by_id(request.args[:id])
        return { error: t('dispatcher.not_found') } if !char
        inv = (char.snack_inventory || {})
        defs = Snacks.get_snack_defs
        items = inv.map do |key, qty|
          defn = defs[key] || {}
          {
            key: key,
            label: defn['label'] || key.titlecase,
            qty: qty,
            desc: defn['desc'] || ""
          }
        end
        {
          id: char.id,
          name: char.name,
          snacks: items.sort_by { |i| i[:label].downcase }
        }
      end
    end
  end
end
