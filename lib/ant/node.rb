module Ant

  #
  # [img http://ya.ru/pics?name=image.png height=100]
  #   ^     ^                                ^
  #  node  args                             options
  #
  class Node

    PARAMS_SPLIT  = /\s+/.freeze
    OPTIONS_SPLIT = /=/.freeze
    CLEANER       = /(\A\s+|\s+\Z)/.freeze

    def initialize(raw)

      @args     = []
      @options  = {}
      @name     = ""

      parse(raw)
      get_tag

    end # initialize

    def singular?
      tag.singular?
    end # singular?

    def compile(content)
      tag.compile(@args, @options, content)
    end # compile

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     #{@name},\n"    <<
      " args:     #{@args},\n"    <<
      " options:  #{@options},\n" <<
      " handler:  #{@handler}>\n"

    end # inspect

    private

    # Разбираем сырую строку. Выбираем:
    # -- название тега
    # -- аргументы
    # -- опции
    def parse(raw)

      @name, params = raw.
        gsub(CLEANER, '').
        split(PARAMS_SPLIT)

      params.each { |par|

        k, v = par.split(OPTIONS_SPLIT)
        if v.nil?
          @args << k
        else
          @options[k.to_sym] = v
        end

      }

      self

    end # parse

    # Ищем тег подходящий для данной ноды
    def tag

      return @tag

      @tag = ::Ant.get(self.name) || ::Ant::NullTag
      @tag

    end # tag

  end # Node

end # Ant
