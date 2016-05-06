#
# Парсер
#
module Ant

  class Parser

    TAG_START   = /\[([^\]]+)\]/.freeze
    TAG_END     = /\[\/([^\]]+)\]/.freeze
    TEXT_SPLIT  = /(\[[^\[\]]+\])/i.freeze

    def initialize(text, opts = {})

      @pipe     ||= []
      @raw      = text
      @content  = ""

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
      @content  = tag.compile(@content) if tag
      tag

    end # pop

    def push(tag)

      @pipe << tag
      pop if tag.singular?
      tag

    end # push

    def parse

      @raw.
        split(TEXT_SPLIT).
        select { |s| s.size > 0 }.
        each do |data|

        case data

          # Закрытие тега
          when TAG_END    then pop

          # Открытие тега
          when TAG_START  then push(::Ant::Node.new($1))

          # Обычный текст
          else @content << prepare_text(data)

        end # case

      end # each

      # Если что-то осталось в стеке -- обрабатываем
      while pop do; end

      # Обраатываем переводы строк -- если задано
      new_lines(@content) if new_lines?

      # Возвращаем обработаннй текст
      @content

    end # parse

    def prepare_text(str)

      minuses(str) if minuses?
      quotes(str)  if quotes?
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

      # Убираем переводы строк
      str.gsub!(/\n/, '')

      # Убираем первый символ абзаца после закрывающего тегв
      str.gsub!(/\>\r/, '>')

      # Убираем перевод строки в начале текста и в самом конце
      str.gsub!(/^(\r+)/, '')
      str.gsub!(/(\r+)$/, '')

      # Меняем символ абзаца на тег br
      str.gsub!(/\r/, '<br/>')

      self

    end # new_lines

  end # Parser

end # Ant
