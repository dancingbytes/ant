;(function($) {

  'use strict'

  function convert(str) {

    return str
      .replace(/\</g, '&lt')
      .replace(/\>/g, '&gt');

  }; // convert

  var TEMPLATE = (

    '<div class="caption">{title}</div>' +
    '<pre>{list}</pre>'

  ); // TEMPLATE

  var LIST = {

    'Выделить текст <b>жирным</b>': [
      convert('<b>текст</b>, <bold>текст</bold>, <strong>текст</strong>, <жирный>текст</жирный>'),
    ],

    'Выделить текст <em>курсивом</em>': [
      '[i]текст[/i], [em]текст[/em], [курсив]текст[/курсив]'
    ],

    '<u>Подчеркнутый</u> текст': [
      '[u]текст[/u], [подчеркнуто]текст[/подчеркнуто]'
    ],

    '<del>Перечеркнутый</del> текст': [
      '[del]текст[/del], [s]текст[/s], [stroke]текст[/stroke], [перечеркнуто]текст[/перечеркнуто]'
    ],

    'Цитата': [
      '[blockquote]текст[/blockquote], [q]текст[/q], [quote]текст[/quote], [цитата]текст[/цитата]'
    ],

    'Ссылка': [
      '[a]текст[/a], [link]текст[/link], [ссылка]текст[/ссылка]'
    ],

    'Изображение': [
      '[img адрес], [image адрес], [картинка адрес], [изображение адрес]'
    ],

    'Инстаграм': [
      '[instagram адрес], [insta адрес], [инстаграм адрес]'
    ],

    'Твиттер': [
      '[tweet адрес], [twit адрес], [twet адрес], [twitter адрес], [твит адрес], [твитер адрес]'
    ],

    'Список': [
      '[ul] [li] элемент списка[/li] [li] элемент списка[/li] [/ul]'
    ]

  };

  var win,
      str = "";

  for(var key in LIST) {

    str += BBEditor.tmpl(TEMPLATE, {
      title: key,
      list:  LIST[key].join('<br />')
    });

  }; // for

  // Info
  BBEditor.actions('info', {

    icon: 'info',
    text: 'info',

    init: function() {

      win = BBEditor.window({

        title:  'Синтаксис разметки',
        cls:    'content-info',
        body:   str

      });

      win
        .el
        .find('button.btn-primary')
        .remove();

    }, // init

    handler: function() {
      win.show();
    } // handler

  });

})(jQuery);