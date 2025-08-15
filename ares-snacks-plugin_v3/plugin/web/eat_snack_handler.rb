
module AresMUSH
  module Snacks
    class EatSnackRequestHandler
      def handle(request)
        enactor = request.enactor
        error = WebHelpers.check_login(request)
        return error if error

        key = request.args[:snack]
        if key.blank?
          return { error: t('snacks.invalid_snack') }
        end

        real_key = Snacks.find_snack_key(key)
        if real_key.nil?
          return { error: t('snacks.invalid_snack') }
        end

        if !Snacks.remove_from_inventory(enactor, real_key, 1)
          return { error: t('snacks.no_snack_in_inventory', snack: Snacks.snack_label(real_key)) }
        end

        # Build updated inventory
        inv = Snacks.inventory_list(enactor).map do |k, qty|
          defn = Snacks.get_snack_defs[k] || {}
          { key: k, label: defn['label'] || k.titlecase, qty: qty, desc: defn['desc'] || "" }
        end

        { ok: true, snacks: inv }
      end
    end
  end
end
