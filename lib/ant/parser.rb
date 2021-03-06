#
# Парсер
#
module Ant

  class Parser

    TAG_START   = /\[([^\]]+)\]/.freeze
    TAG_END     = /\[\/([^\]]+)\]/.freeze
    TEXT_SPLIT  = /(\[[^\[\]]+\])/i.freeze

    def initialize(text, opts = {}, config)

      @pipe         = []
      @raw          = text.dup
      @roots        = []
      @current_tags = {}
      @level        = 0
      @config       = config

      @opts     = opts.is_a?(Hash) ? opts : {
        quotes:     true,
        minuses:    true,
        new_lines:  true
      }

    end

    def to_html
      @to_html ||= parse
    end

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " pipe:   #{@pipe},\n" <<
      " raw:    '#{@raw}'\n" <<
      " roots:  #{@roots}>"

    end

    private

    def pop

      if (tag = @pipe.pop)

        tag.compile

        @roots << tag if tag.root?
        @level -= 1

      end # if

      tag

    end # pop

    def push(tag)

      # Выбираем родителя на текущем уровне
      parent_tag = @current_tags[@level]

      # Запоминаем родителья для данного тега
      tag.parent = parent_tag

      @level += 1
      @current_tags[@level] = tag

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
            when TAG_END    then
              pop

            # Открытие тега
            when TAG_START  then

              n = ::Ant::Node.new($1, @config)
              if @config.get(n.name).nil?
                push(::Ant::TextNode.new(data, @opts))
              else
                push(n)
              end

            # Обычный текст
            else
              push(::Ant::TextNode.new(data, @opts))

          end # case

        end # each

      # Если что-то осталось в стеке -- обрабатываем
      while pop do; end

      # Возвращаем обработаннй текст
      @roots.map(&:compile).join

    end # parse

  end # Parser

end # Ant
