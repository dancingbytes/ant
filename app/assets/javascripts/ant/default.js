;(function($) {

  'use strict'

  // H2
  Ant.actions('h2', {

    text:   'Большой',
    group:  'Заголовки',
    handler: function() {
      this.setValue('[h2]{selection}[/h2]');
    }

  }); // H2

  // H3
  Ant.actions('h3', {

    text:   'Средний',
    group:  'Заголовки',
    handler: function() {
      this.setValue('[h3]{selection}[/h3]');
    }

  }); // H3

  // Bold
  Ant.actions('bold', {

    text: 'B',
    handler: function() {
      this.setValue('[b]{selection}[/b]');
    }

  }); // bold

  // Italic
  Ant.actions('italic', {

    text: 'I',
    handler: function() {
      this.setValue('[i]{selection}[/i]');
    }

  }); // Italic

  // Underline
  Ant.actions('underline', {

    text: 'underline',
    icon: 'underline',
    handler: function() {
      this.setValue('[u]{selection}[/u]');
    }

  }); // Underline

  // Stroke
  Ant.actions('stroke', {

    text: 'stroke',
    icon: 'stroke',
    handler: function() {
      this.setValue('[del]{selection}[/del]');
    }

  }); // Stroke

  // Blockquote
  Ant.actions('blockquote', {

    text: 'Цитата',
    icon: 'quote',
    handler: function() {
      this.setValue('[blockquote]{selection}[/blockquote]');
    }

  }); // Blockquote

  // Link
  Ant.actions('link', {

    icon: 'link',
    text: 'link',
    handler: function() {

      var self = this;

      this.window({

        title:  'Вставить ссылку',
        body:   Ant.tmpl(Ant.SIMPLE_FORM_TMPL, {
          label: 'Введите ссылку на источник'
        })

      }).on('action', function(evt, c) {

        var val = c.el.find('input.link').val();

        self.setValue('[link {attr}]{selection}[/link]', {
          attr: val
        });

        c.hide();

      }).show();

    }

  }); // Link

})(jQuery);
