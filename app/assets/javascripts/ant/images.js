;(function($) {

  'use strict'

  Ant.IMAGES = {

    UPLOAD_FILE_URL:  '/uploads',
    BUTTON_NAME:      'Выберите файл(ы)',
    INFO:             '<b>Выберите один или несколько файлов или перетащите ' +
                      'в эту область</b><br />(фотографии фотографии будут ' +
                      'загружены без обработки)'

  };

  var EDITOR, WIN;
  var FILES  = {};

  var FORM_TMPL = (

    '<div class="tab-pane">' +

      '<div class="row">' +

        '<form action="{url}" accept-charset="UTF-8" method="post" enctype="multipart/form-data">' +
          '<input name="utf8" type="hidden" value="✓">' +
          '<input type="hidden" name="authenticity_token" value="{authenticity_token}">' +

          '<div class="form-group col-md-12 fileupload-progress">' +
            '<div class="progress">' +
              '<div class="progress-bar" role="progressbar" style="width: 0;"></div>' +
            '</div>' +
          '</div>' +

          '<div class="form-group col-md-12 fileupload-btn-cnt">' +
            '<div class="fileupload-btn-dropzone">' +
              '<div class="info">{info}</div>' +
            '</div>' +
          '</div>' +

          '<div class="form-group col-md-12">' +
            '<input type="file" class="btn btn-primary fileupload-btn" title="{button_name}" name="file" multiple>' +
          '</div>' +

        '</form>' +

      '</div>' +

    '</div>' // upload-image

  ); // FORM_TMPL

  // --- Инициализация окна ---------------------------------------------------
  function initWin() {

    WIN = Ant.window({

      title:  'Загрузка изображений',
      cls:    'upload-images',
      body:   Ant.tmpl(FORM_TMPL, {

        url:                  Ant.IMAGES.UPLOAD_FILE_URL,
        authenticity_token:   $('meta[name="csrf-token"]').attr('content'),
        button_name:          Ant.IMAGES.BUTTON_NAME,
        info:                 Ant.IMAGES.INFO

      })

    }).on('action', onAction);

    var id_index  = 0;
    var button    = WIN.el.find('input.fileupload-btn');

    // Стилизируем кнопку загрузки
    button.bootstrapFileInput();

    // Загрузка файлов
    button.uploadFileButton({

      acceptFileTypes:  /(\.|\/)(gif|jpe?g|png)$/i,
      imageContainer:   WIN.el.find('.fileupload-btn-dropzone'),
      dropCls:          'fileupload-drop-over',

      add: function(e, data) {

        var file = data.files[0];
        if (!file) { return; }

        WIN.el
          .find('.fileupload-progress .progress-bar')
          .css('width', 0);

        WIN.el
          .find('.fileupload-btn-dropzone')
          .find('div.info')
          .remove();

        data.id_index = id_index++;
        data.node     = $('<div class="preview" />')
          .append(
            $('<div class="cross" />')
              .one("click", function() {

                delete FILES[data.id_index];
                data.node.remove();

              }),
            $('<div class="loading" />'),
            $('<span/>').text(file.name)
          )
          .appendTo(
            WIN.el.find('.fileupload-btn-dropzone')
          );

        data.submit();

      }, // add

      progress: function (e, data) {

        var progress = parseInt(data.loaded / data.total * 100, 10);
        data.node.find('div.loading').text(progress + '%');

      }, // processalways

      progressall: function (e, data) {

        var progress = parseFloat(data.loaded / data.total * 100);

        WIN.el
          .find('.fileupload-progress .progress-bar')
          .css('width', progress + '%');

      }, // progressall

      done: function (e, data) {

        if (data.result && data.result.url) {

          FILES[data.id_index] = data.result.url;

          data.node
            .find('div.loading')
            .replaceWith($('<img src="' + data.result.url + '" />'));

          data.node
            .find('div.cross')
            .show();

        }

      }, // done

      fail: function (e, data) {

        data.node
          .find('div.loading')
          .replaceWith($('<div class="error" />'));

      } // fail

    });

  }; // initWin

  // --------------------------------------------------------------------------
  function onReset() {

    WIN && WIN.destroy();

    WIN     = null;
    EDITOR  = null;
    FILES   = {};

  }; // onReset

  // --------------------------------------------------------------------------
  function onAction(evt, c) {

    var key;

    for(key in FILES) {

      EDITOR.setValue('[img {attr} ]\n', {
        attr: FILES[key]
      });

    }

    c.hide();
    onReset();

  }; // onAction

  // --- Images ---------------------------------------------------------------
  Ant.actions('image', {

    icon: 'image',
    text: 'image',
    handler: function() {

      if (!WIN) {
        initWin();
      }

      if (!EDITOR) {
        EDITOR = this;
      }

      WIN.show();

    }

  }); // Images

})(jQuery);
