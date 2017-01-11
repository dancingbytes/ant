#
# Объект BBcode
#
module Ant

  class TextNode

    def initialize(raw, opts)

      @raw    = (raw || '').dup
      @opts   = opts
      @parent = nil

    end # initialize

    def name; nil; end # name

    def type
      :text
    end # type

    def <<(node)
      node
    end # node

    def parent=(node)

      @parent = node
      node << self if node
      node

    end # parent=

    def parent
      @parent
    end # parent

    def root?
      parent.nil?
    end # root?

    def singular?
      true
    end # singular?

    def compile
      @value ||= parse(@raw)
    end # compile

    def quotes?
      @opts[:quotes] == true
    end # quotes?

    def minuses?
      @opts[:minuses] == true
    end # minuses?

    def new_lines?
      @opts[:new_lines] == true
    end # new_lines?

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:       null,\n"          <<
      " type:       #{type},\n"       <<
      " quotes:     #{quotes?},\n"    <<
      " minuses:    #{minuses?},\n"   <<
      " new_lines:  #{new_lines?},\n" <<
      " parent:     #{parent},\n"     <<
      " raw:        #{@raw},\n"       <<
      " value:      #{compile}>"

    end # inspect

    private

    def parse(str)

      minuses(str)    if minuses?
      quotes(str)     if quotes?
      new_lines(str)  if new_lines?
      str

    end # parse

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

      # Первые переводы строки -- убираем
      str.gsub!(/\A\r\n/, '')

      # Каждую пару \r\n меняем на тег br
      str.gsub!(/\r\n/, '<br/>')

      # Убираем лишнее
      str.gsub!(/[\n\r\t\0]/, '')

      self

    end # new_lines

  end # Node

end # Ant
