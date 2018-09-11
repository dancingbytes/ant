#
# Объект BBcode
#
module Ant

  class TextNode

    def initialize(raw, opts)

      @raw    = (raw || '').dup
      @opts   = opts
      @parent = nil

    end

    def name; nil; end

    def type
      :text
    end

    def <<(node)
      node
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

    def singular?
      true
    end

    def compile
      @value ||= parse(@raw)
    end

    def quotes?
      @opts[:quotes] == true
    end

    def minuses?
      @opts[:minuses] == true
    end

    def new_lines?
      @opts[:new_lines] == true
    end

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

    end

    # Заменяем все одинарные и двойные кавычки на более красивые
    def quotes(str)

      str.gsub!(/[\"\'](.[^\"\']+)[\"\']/, '«\1»')
      self

    end

    # Заменяем все двойные минусы на длинное тире
    def minuses(str)

      str.gsub!(/--/, '—')
      self

    end

    def new_lines(str)

      # Убираем лишнее
      str.gsub!(/[\n\t\0]/, '')

      # Каждую пару \r меняем на тег br
      str.gsub!(/[\r]{2}/, '<br />')

      # Оставщиеся тоже меняем на br
      str.gsub!(/\r/, '<br />')

      self

    end # new_lines

  end # Node

end # Ant
