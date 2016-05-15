#
# Объект BBcode
#
module Ant

  #
  # [img http://ya.ru/pics?name=image.png height=100]
  #   ^     ^                                ^
  #  node  args                             options
  #
  class Node

    # Разбор аттрибутов по пустой строке
    ATTR_SPLIT  = /\s+/.freeze

    # Регулярка для разбора парамтеров.
    # Парамерами называется пара ключ-значение, где
    # ключом может быть строка состоящая только из букв и цифр
    #
    PARAMS_SPLIT = /\A(\w+)\=(\S+)/.freeze

    # Убираем пробела в начале и в концн строки
    CLEANER       = /(\A\s+|\s+\Z)/.freeze

    def initialize(raw)

      @args     = []
      @options  = {}
      @name     = ""

      parse(raw)

    end # initialize

    def name
      @name
    end # name

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
      " options:  #{@options}>"

    end # inspect

    private

    # Разбираем сырую строку. Выбираем:
    # -- название тега
    # -- аргументы
    # -- опции
    def parse(raw)

      params = raw.
        gsub(CLEANER, '').
        split(ATTR_SPLIT)

      # Выбираем название тега
      @name  = params.shift

      # Выбираем агрументы и параметры
      while (str = params.shift)

        # Если строка не похожа на параметр -- значит это агрумент
        k, v = str.scan(PARAMS_SPLIT).first
        if k.nil? || v.nil?
          @args << str
        else
          @options[k.to_sym] = v
        end

      end # while

      self

    end # parse

    # Ищем тег подходящий для данной ноды
    def tag

      return @tag if @tag

      @tag = ::Ant.get(self.name) || ::Ant::NullTag
      @tag

    end # tag

  end # Node

end # Ant
