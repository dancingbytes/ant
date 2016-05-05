module Ant

  class Parser

    TAG_START   = /\[([^\]]+)\]/.freeze
    TAG_END     = /\[\/([^\]]+)\]/.freeze
    TEXT_SPLIT  = /(\[[^\[\]]+\])/i.freeze

    def initialize(text)

      @pipe     ||= []
      @raw      = text
      @content  = ""

    end # initialize

    def to_html
      @to_html ||= parse
    end # to_html

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
          else @content << data

        end # case

      end # each

      # Если что-то осталось в стеке -- обрабатываем
      while pop do; end

      # Возвращаем обработаннй текст
      @content

    end # parse

  end # Parser

end # Ant
