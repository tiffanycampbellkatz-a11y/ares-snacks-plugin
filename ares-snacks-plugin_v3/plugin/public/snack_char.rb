
module AresMUSH
  class Character
    attribute :snack_inventory, :type => DataType::Hash, :default => {}

    def total_snacks_received
      (self.snack_inventory || {}).values.sum
    end
  end
end
