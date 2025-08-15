
import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  gameApi: service(),
  gameSession: service(),
  flashMessages: service(),
  loading: true,
  eating: false,
  snacks: [],
  isSelf: false,

  didInsertElement() {
    this._super(...arguments);
    let id = this.get('char.id') || this.get('charId');
    this.set('isSelf', this.gameSession.charId == id);
    this.get('gameApi').requestOne('profileSnacks', { id: id }, null)
      .then((response) => {
        if (response.error) {
          this.set('snacks', []);
        } else {
          this.set('snacks', response.snacks || []);
        }
        this.set('loading', false);
      });
  },

  actions: {
    eatSnack(key) {
      if (!this.isSelf) { return; }
      if (!confirm("Eat one " + key + "?")) { return; }
      this.set('eating', true);
      this.get('gameApi').requestOne('eatSnack', { snack: key }, null)
        .then((response) => {
          if (response.error) {
            this.flashMessages.danger(response.error);
          } else {
            this.set('snacks', response.snacks || []);
            this.flashMessages.success("Yum!");
          }
        })
        .finally(() => this.set('eating', false));
    }
  }
});
