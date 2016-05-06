;(function($) {

  'use strict'

  Ant.actions('twitter', {

    icon: 'twitter',
    text: 'twitter',
    handler: function() {

      var self = this;

      this.window({

        title:  'Ссылка на Twitter',
        body:   Ant.tmpl(Ant.SIMPLE_FORM_TMPL, {
          label: 'Введите ссылку'
        })

      }).on('action', function(evt, c) {

        var val = c.el.find('input.link').val();

        self.setValue('[twitter {attr}]', {
          attr: val
        });

        c.hide();

      }).show();

    }

  }); // Twitter

})(jQuery);
