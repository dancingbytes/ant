;(function($) {

  'use strict'

  Ant.actions('instagram', {

    icon: 'instagram',
    text: 'instagram',
    handler: function() {

      var self = this;

      this.window({

        title:  'Ссылка на Instagram',
        body:   Ant.tmpl(Ant.SIMPLE_FORM_TMPL, {
          label: 'Введите ссылку'
        })

      }).on('action', function(evt, c) {

        var val = c.el.find('input.link').val();

        self.setValue('[insta {attr}]', {
          attr: val
        });

        c.hide();

      }).show();

    }

  }); // Instagram

})(jQuery);
