;(function($) {

  'use strict'

  var SIMPLE_FORM_TMPL = (

    '<div class="row">' +

      '<div class="col-md-12">' +

        '<div class="form-group">' +
          '<textarea class="form-control link"></textarea>' +
        '</div>' +

      '</div>' +

    '</div>'

  );

  var RE = /src\=["'](\S+)["']/i;

  function parseSrc(str) {

    var val = RE.exec(str);
    return (val && val[1] ? val[1] : "");

  }; // parseSrc

  // Script
  Ant.actions('script', {

    icon: 'script',
    text: 'script',
    handler: function() {

      var self = this;

      this.window({

        title:  'Внейшний js-скрипт',
        body:   SIMPLE_FORM_TMPL

      }).on('action', function(evt, c) {

        var val = c.el.find('textarea.link').val();

        self.setValue('[script {attr} ]', {
          attr: parseSrc(val)
        });

        c.hide();

      }).show();

    }

  }); // YouTube

})(jQuery);
