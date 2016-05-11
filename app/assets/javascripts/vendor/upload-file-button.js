;(function($) {

  'use strict'

  var UploadFileButton = function(el, opts) {

    this.opts = opts || {};
    this.render(el);

  }; // UploadFileButton

  UploadFileButton.prototype = {

    autoUpload:         true,
    timeout:            55,     // sec
    replaceFileInput:   false,
    dataType:           'json',
    type:               'post',
    acceptFileTypes:    /(\.|\/)(gif|jpe?g|png|zip|xml|xls|xlsx|tar)$/i,

    waitCls:            'disabled',
    dropCls:            null,

    render: function(el) {

      if (this.el) { return this; }

      this.el             = el;
      this.imageContainer = this.opts.imageContainer;

      this.el.fileupload(
        $.extend({

          autoUpload:         this.autoUpload,
          timeout:            this.timeout * 1000,
          replaceFileInput:   this.replaceFileInput,
          dataType:           this.dataType,
          type:               this.type,
          acceptFileTypes:    this.acceptFileTypes,
          disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent),
          pasteZone:          this.imageContainer,
          dropZone:           this.imageContainer

        }, this.opts)
      );

      this.onEvents();
      return this;

    }, // render

    fileupload: function () {
      return this.el.fileupload();
    }, // fileupload

    onEvents: function() {

      this.fileupload()
        .on('fileuploadstart',      $.proxy(this.onDisable,   this))
        .on('fileuploaddone',       $.proxy(this.onEnable,    this))
        .on('fileuploaddrop',       $.proxy(this.onDragLeave, this))
        .on('fileuploaddragover',   $.proxy(this.onDragOver,  this))
        .on('fileuploaddragleave',  $.proxy(this.onDragLeave, this));

      return this;

    }, // onEvents

    onDisable: function() {

      this.
        fileupload().
        prop('disabled', true).
        parent().
        addClass(this.waitCls);

    }, // onDisable

    onEnable: function() {

      this.
        fileupload().
        prop('disabled', false).
        parent().
        removeClass(this.waitCls);

      return this;

    }, // onEnable

    onDragLeave: function() {

      if (this.imageContainer) {
        this.dropCls && this.imageContainer.removeClass(this.dropCls);
      }

    }, // onDragLeave

    onDragOver: function() {

      if (this.imageContainer) {
        this.dropCls && this.imageContainer.addClass(this.dropCls);
      }

    } // onDragOver

  }; // UploadFileButton.ptototype


  /**
   * Кнопка загрузки файлов
   */
  $.fn.uploadFileButton = function(opts) {

    this.each(function() {
      new UploadFileButton($(this), opts);
    });

    return this;

  }; // uploadFileButton

})(jQuery);
