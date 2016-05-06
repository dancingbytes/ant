;(function($) {

  'use strict'

  // Coub
  Ant.actions('coub', {

    icon: 'coub',
    text: 'coub',
    handler: function() {

      var self = this;

      this.window({

        title:  'Ссылка на Coub',
        body:   Ant.tmpl(Ant.SIMPLE_FORM_TMPL, {
          label: 'Введите ссылку'
        })

      }).on('action', function(evt, c) {

        var val = c.el.find('input.link').val();

        self.setValue('[coub {attr} ]', {
          attr: val
        });

        c.hide();

      }).show();

    }

  }); // Coub

})(jQuery);
