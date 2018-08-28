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

    def initialize(raw, config)

      @args     = []
      @options  = {}
      @name     = ""
      @children = []
      @parent   = nil
      @config   = config

      parse(raw)

    end

    def type
      :node
    end

    def <<(node)
      @children << node
    end

    def parent=(node)

      @parent = node
      node << self if node
      node

    end

    def parent
      @parent
    end

    def root?
      parent.nil?
    end

    def name
      @name.to_s
    end

    def singular?
      tag.singular?
    end

    def compile

      return @value if @value

      cnt, slvs = prepare_children

      @value    = tag.compile( @args, @options, cnt, slvs )
      @value

    end

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     #{name},\n"                <<
      " type:     #{type},\n"                 <<
      " args:     #{@args},\n"                <<
      " options:  #{@options},\n"             <<
      " children: #{children.join(', ')},\n"  <<
      " parent:   #{parent},\n"               <<
      " value:    #{compile}>"

    end

    # Ищем тег подходящий для данной ноды
    def tag

      return @tag if @tag

      @tag = @config.get(self.name) || ::Ant::NullTag
      @tag

    end

    private

    def prepare_children

      cnt     = ""
      slaves  = []

      children.each { |child|

        if child.name && tag.slave_tags.include?(child.name.to_sym)

          slaves << {
            child.name => child.compile
          }

        else
          cnt << child.compile
        end

      }

      return cnt, slaves

    end # prepare_children

    def children
      @children
    end

    # Разбираем сырую строку. Выбираем:
    # -- название тега
    # -- аргументы
    # -- опции
    def parse(raw)

      params = String(raw).
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

  end # Node

end # Ant
