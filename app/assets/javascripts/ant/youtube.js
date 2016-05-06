;(function($) {

  'use strict'

  // YouTube
  Ant.actions('youtube', {

    icon: 'youtube',
    text: 'youtube',
    handler: function() {

      var self = this;

      this.window({

        title:  'Ссылка на YouTube',
        body:   Ant.tmpl(Ant.SIMPLE_FORM_TMPL, {
          label: 'Введите ссылку'
        })

      }).on('action', function(evt, c) {

        var val = c.el.find('input.link').val();

        self.setValue('[youtube {attr} ]', {
          attr: val
        });

        c.hide();

      }).show();

    }

  }); // YouTube

})(jQuery);
