;(function($) {

  'use strict'

  var WINDOW_TMPL = (

    '<div class="modal editor-modal-win" tabindex="-1" role="dialog">' +
      '<div class="modal-dialog">' +
        '<div class="modal-content">' +
          '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal" aria-label="Close">' +
              '<span aria-hidden="true">&times;</span>' +
            '</button>' +
            '<h4 class="modal-title">{title}</h4>' +
          '</div>' +
          '<div class="modal-body">{body}</div>' +
          '<div class="modal-footer">' +
            '<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>' +
            '<button type="button" class="btn btn-primary">{button}</button>' +
          '</div>' +
        '</div>' +
      '</div>' +
    '</div>'

  ); // WINDOW_TMPL

  var BASE_TMPL = (

    '<div class="ant-editor">' +
      '<div class="btn-group" role="group">{content}</div>' +
    '</div>'

  );

  var BUTTON_TMPL = (
    '<button type="button" class="btn btn-default {attr} {cls}" data-{attr}="{act}">{text}</button>'
  );

  var BUTTON_ICON_TMPL = (

    '<button type="button" class="btn btn-default {attr} {cls}" data-{attr}="{act}">' +
      '<span class="ed-icon ed-icon-{icon}"></span>' +
    '</button>'

  );

  var DROP_DOWN_TMPL = (

    '<div class="btn-group" role="group">' +
      '<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">' +
        '{group_name} <span class="caret"></span>' +
      '</button>' +
      '<ul class="dropdown-menu">' +
        '{block}' +
      '</ul>' +
    '</div>'

  );

  var BUTTON_DROP_DOWN_TMPL = (

    '<li>' +
      '<a href="#" class="{attr} {cls}" data-{attr}="{act}">{text}</a>' +
    '</li>'

  );

  var LIST_SEPARATOR = (
    '<li role="separator" class="divider"></li>'
  );

  var SIMPLE_FORM_TMPL = (

    '<div class="row">' +

      '<div class="col-md-12">' +

        '<div class="form-group">' +
          '<label>{label}</label>' +
          '<input type="url" class="form-control link" />' +
        '</div>' +

      '</div>' +

    '</div>'

  );

  var Editor = function(c) {

    if (c) {
      this.render(c);
    }

  }; // Editor

  Editor.prototype = {

    actionSelector: 'button',
    actionAttr:     'ed-act',
    actions:        {},
    onInit:         [],

    getId: function() {
      return (this.id = this.id || ("el-" + (+ new Date())));
    }, // getId

    fire : function() {

      var evt = $.Event(arguments[0] + "." + this.getId());
      this.el.trigger(evt, Array.prototype.slice.call( arguments, 1 ));
      return evt.result;

    }, // fire

    on : function(evt, fn, scope) {

      if (typeof fn == "function") {
        this.el.on(evt + "." + this.getId(), $.proxy(fn, scope || this));
      }
      return this;

    }, // on

    one: function(evt, fn, scope) {

      if (typeof fn == "function") {
        this.el.one(evt + "." + this.getId(), $.proxy(fn, scope || this));
      }
      return this;

    }, // one

    onActionSelector: function() {

      return this.tmpl('button.{cls}, a.{cls}', {
        cls: this.actionAttr
      });

    }, // onActionSelector

    render: function(c) {

      if (!this.el) {

        // Editor
        this.cEl = c[0];

        // Render el
        this.el  = $(
          this.tmpl(BASE_TMPL, {
            content: this.onConstructAll()
          })
        ).insertBefore(c);

        this.onEvents();
        this.afterRender();

        $('[data-toggle="dropdown"]').dropdown();

      }; // if

      return this;

    }, // render

    onEvents: function() {

      var self = this,
          name, action;

      this.el.on('click', this.onActionSelector(), function(evt) {

        evt.preventDefault();

        name    = $(this).data(self.actionAttr);
        action  = self.actions[name] || {

          handler: function() {
            console.log('Error. Action `', name, '` is not found');
          }

        };

        action.handler.call(self);

        return false;

      }); // on

      return this;

    }, // onEvents

    afterRender: function() {

      var h;

      this.onInit.reverse();

      while(h = this.onInit.pop()) {
        h.fn.call(this, $(h.el));
      }

      return this;

    }, // afterRender

    onConstructAll: function() {

      var arr     = [],
          acts    = this.actions,
          groups  = {},
          name, obj, gname, fn, el;

      for (name in acts) {

        gname = acts[name].group;
        if (gname) {

          if (groups[gname]) {

            el = this.onCreateLink(name, acts[name])
            groups[gname].arr.push(el);

          } else {

            el = this.onCreateLink(name, acts[name])

            groups[gname] = {
              pos: arr.length,
              arr: [el]
            };

            arr.push(groups[gname]);

          }; // if

        } else {

          el = this.onCreateButton(name, acts[name])
          arr.push(el)

        }; // if

        fn = acts[name].init;
        if (typeof(fn) == 'function') {

          this.onInit.push({
            fn: fn,
            el: el
          });

        }

      }; // for

      for (name in groups) {

        obj = groups[name];

        arr[obj.pos] = this.tmpl(DROP_DOWN_TMPL, {
          group_name: name,
          block:      obj.arr.join('')
        });

      }; // for

      return arr.join('');

    }, // onConstructAll

    onCreateButton: function(action, opts) {

      var btn;

      opts = opts || { text: action };

      if (opts.icon) {

        btn = this.tmpl(BUTTON_ICON_TMPL, {
          icon: opts.icon,
          cls:  opts.cls,
          attr: this.actionAttr,
          act:  action
        });

      } else {

        btn = this.tmpl(BUTTON_TMPL, {
          text: opts.text,
          cls:  opts.cls,
          attr: this.actionAttr,
          act:  action
        });

      }

      return btn;

    }, // onCreateButton

    onCreateLink: function(action, opts) {

      var btn;

      opts  = opts || { text: action };
      btn   = this.tmpl(BUTTON_DROP_DOWN_TMPL, {
        text: opts.text,
        cls:  opts.cls,
        attr: this.actionAttr,
        act:  action
      });

      return btn;

    }, // onCreateLink

    selectionStart: function() {
      return this.cEl ? Number(this.cEl.selectionStart, 10) : 0;
    }, // selectionStart

    selectionEnd: function() {
      return this.cEl ? Number(this.cEl.selectionEnd, 10) : 0;
    }, // selectionEnd

    getSeleted: function() {

      return this.getValue().substring(
        this.selectionStart(),
        this.selectionEnd()
      );

    }, // getSeleted

    hasSelected: function() {
      return (this.selectionStart() + this.selectionEnd() > 0);
    }, // hasSelected

    getValue: function() {
      return this.cEl ? this.cEl.value : "";
    }, // getValue

    getCaret: function() {

      if (!this.cEl) {
        return 0;
      }

      if (this.cEl.selectionStart) {
        return this.cEl.selectionStart;
      } else if (!document.selection) {
        return 0;
      }

    }, // getCaret

    //
    // Example:
    //
    // this.setValue('[link {attr}]{selection}[/link]', {
    //   attr: 'http://ya.ru/pic.png'
    // });
    //
    setValue: function(str, params) {

      if (!this.cEl) {
        return;
      }

      params = params || {};

      // Исходный текст
      var v   = this.cEl.value;
      // Итоговый текст
      var val = "";

      if (this.hasSelected()) {

        // Выбираем текст до выделения
        val += v.substring(0, this.selectionStart());

        // Вставляем текст
        val += this.tmpl(str,

          $.extend({
            selection: this.getSeleted()
          }, params)

        );

        // Выбираем текст после выделения
        val += v.substring(this.selectionEnd(), v.length);

      } else {

        val += v;
        val += this.tmpl(str, params)

      }

      this.cEl.value = val;

      return this;

    }, // setValue

    window: function(p) {

      p = p || {};

      if (!this.win) {
        this.win = new Win();
      }

      this.win.
        title(p.title || 'Заголовок').
        body(p.body || '').
        button(p.button || 'Вставить');

      if (this.win.clsBefore) {
        this.win.el.removeClass(this.win.clsBefore);
      }

      if (p.cls) {
        this.win.clsBefore = p.cls;
        this.win.el.addClass(p.cls);
      }

      // Сбрасываем все обработчики
      this.win.el.unbind();

      return this.win;

    } // window

  }; // Editor

  // --- Class methods --------------------------------------------------------
  Editor.render = function(c) {
    return new Editor(c);
  }; // render

  Editor.tmpl = function(format, obj) {

    return format.replace(/{\w+}/g, function(p1, offset, s) {
      return obj[ p1.replace(/[{}]/g, '') ];
    });

  }; // tmpl

  Editor.prototype.tmpl = Editor.tmpl;

  Editor.actions = function(name, params) {

    params = params || {}
    Editor.prototype.actions[name] = {

      text:     params.text || name,
      icon:     params.icon,
      cls:      params.cls,
      group:    params.group,
      handler:  params.handler,
      init:     params.init

    };
    return Editor;

  }; // actions

  Editor.actionsClearAll = function() {

    Editor.prototype.actions = {};
    return Editor;

  }; // actionsClearAll

  Editor.actionsDelete = function(name) {

    delete Editor.prototype.actions[name];
    return Editor;

  }; // actionsDelete

  // --- Window ---------------------------------------------------------------
  var Win = function(params, c) {
    this.render(params, c);
  }; // Win

  Win.prototype = {

    on: function(evnt, fn) {

      this.el && this.el.on(evnt, fn);
      return this;

    }, // on

    render: function(params, c) {

      if (!this.el) {

        params = $.extend({
          title:  'Заголовок',
          body:   '',
          button: 'Вставить'
        }, params || {})

        this.el = $(
          Editor.tmpl(WINDOW_TMPL, params)
        ).appendTo(c || $('body'));

        this.titleEl  = this.el.find('h4.modal-title');
        this.bodyEl   = this.el.find('div.modal-body');
        this.buttonEl = this.el.find('button.btn-primary');

        if (params.cls) {
          this.el.addClass(params.cls);
        }

        this.el.modal({
          backdrop: false,
          keyboard: false,
          show:     false
        });

        this.onEvents();

        this.el.trigger($.Event('render'), this);

      }; // if

      return this;

    }, // render

    onEvents: function() {

      var self = this;

      this.buttonEl && this.buttonEl.on('click', function(evt) {

        evt.preventDefault();
        self.el.trigger($.Event('action'), self);
        return false;

      });

    }, // onEvents

    title: function(html) {

      if (html) {
        this.titleEl && this.titleEl.html(html);
      }
      return this;

    }, // title

    body: function(html) {

      if (html) {
        this.bodyEl && this.bodyEl.html(html);
      }
      return this;

    }, // body

    button: function(html) {

      if (html) {
        this.buttonEl && this.buttonEl.html(html);
      }
      return this;

    }, // button

    show:   function() {

      this.el && this.el.modal('show');
      return this;

    }, // show

    hide: function() {

      this.el && this.el.modal('hide');
      return this;

    }, // hide

    destroy: function() {

      if (this.el) {

        this.buttonEl.unbind();
        this.el.unbind();
        this.el.remove();

        this.el       = null;
        this.titleEl  = null;
        this.bodyEl   = null;
        this.buttonEl = null;

      }

    } // destroy

  }; // Win

  Editor.window = function(params, c) {
    return new Win(params, c);
  }; // window

  // --- Публичные шаблоны ----------------------------------------------------
  Editor.SIMPLE_FORM_TMPL = SIMPLE_FORM_TMPL;

  // --------------------------------------------------------------------------
  window.Ant = Editor;

})(jQuery);
