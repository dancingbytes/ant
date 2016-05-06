;(function($) {

  'use strict'

  // Vimeo
  Ant.actions('vimeo', {

    icon: 'vimeo',
    text: 'vimeo',
    handler: function() {

      var self = this;

      this.window({

        title:  'Ссылка на Vimeo',
        body:   Ant.tmpl(Ant.SIMPLE_FORM_TMPL, {
          label: 'Введите ссылку'
        })

      }).on('action', function(evt, c) {

        var val = c.el.find('input.link').val();

        self.setValue('[vimeo {attr} ]', {
          attr: val
        });

        c.hide();

      }).show();

    }

  }); // Vimeo

})(jQuery);
