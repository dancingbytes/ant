#
# Парсер
#
module Ant

  class Parser

    TAG_START   = /\[([^\]]+)\]/.freeze
    TAG_END     = /\[\/([^\]]+)\]/.freeze
    TEXT_SPLIT  = /(\[[^\[\]]+\])/i.freeze

    def initialize(text, opts = {})

      @pipe     = []
      @raw      = text
      @content  = ""
      @cur_text = ""

      @opts     = opts.is_a?(Hash) ? opts : {
        quotes:     true,
        minuses:    true,
        new_lines:  true
      }

    end # initialize

    def to_html
      @to_html ||= parse
    end # to_html

    def quotes?
      @opts[:quotes] == true
    end # quotes?

    def minuses?
      @opts[:minuses] == true
    end # minuses?

    def new_lines?
      @opts[:new_lines] == true
    end # new_lines?

    private

    def pop

      tag       = @pipe.pop
      @cur_text = tag.compile(@cur_text) if tag

      flush_text_context
      tag

    end # pop

    def push(tag)

      flush_text_context

      @pipe << tag
      pop if tag.singular?

      tag

    end # push

    def parse

      @raw.
        split(TEXT_SPLIT).
        each do |data|

          case data

            # Закрытие тега
            when TAG_END    then pop

            # Открытие тега
            when TAG_START  then push(::Ant::Node.new($1))

            # Обычный текст
            else save_text_context(data)

          end # case

        end # each

      # Если что-то осталось в стеке -- обрабатываем
      while pop do; end

      # Возвращаем обработаннй текст
      @content

    end # parse

    def save_text_context(txt)

      @cur_text = prepare_text(txt)
      self

    end # save_text_context

    def flush_text_context

      @content  << @cur_text
      @cur_text = ""
      self

    end # flush_text_context

    def prepare_text(str)

      minuses(str)    if minuses?
      quotes(str)     if quotes?
      new_lines(str)  if new_lines?
      str

    end # prepare_text

    # Заменяем все одинарные и двойные кавычки на более красивые
    def quotes(str)

      str.gsub!(/[\"\'](.[^\"\']+)[\"\']/, '«\1»')
      self

    end # quotes

    # Заменяем все двойные минусы на длинное тире
    def minuses(str)

      str.gsub!(/--/, '—')
      self

    end # minuses

    def new_lines(str)

      # Меняем символ абзаца на тег br
      str.gsub!(/\r\n/, '<br/>')

      # Убираем лишнее
      str.gsub!(/[\n\r\t\0]/, '')

      self

    end # new_lines

  end # Parser

end # Ant
