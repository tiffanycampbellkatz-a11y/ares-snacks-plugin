
module AresMUSH
  module Snacks
    class SnackSceneCmd
      include CommandHandler

      attr_accessor :snack

      def parse_args
        if cmd.args =~ /scene=(.+)/i
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

        scene = enactor_room && enactor_room.scene
        if !scene
          client.emit_failure t('snacks.invalid_scene')
          return
        end

        recipients = scene.characters.select { |c| c != enactor }
        if recipients.empty?
          client.emit_ooc t('snacks.no_recipients_scene')
          return
        end

        recipients.each do |char|
          error = Snacks.give_snack(char, enactor, key)
          client.emit_failure error if error
        end

        Scenes.add_to_scene(scene, t('snacks.snack_give_scene_emit', name: enactor.name, snack: Snacks.snack_label(key), flavor: Snacks.flavor_for(key, 'give'))) rescue nil
        client.emit_success t('snacks.snack_given_scene', count: recipients.count, snack: Snacks.snack_label(key), scene: scene.id)
      end
    end
  end
end
