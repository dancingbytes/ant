require "ant/version"

require "ant/tag"
require "ant/null_tag"
require "ant/node"
require "ant/parser"

module Ant

  extend self

  # Ant.to_html('[p]my [img http://ya.ru/pics?name=image.png height=100]string! [i color="#f00"]red text[/i][/p]')
  # Ant.to_html('[p]my [img http://ya.ru/pics?name=image.png height=100]string! [i color="#f00"]red text[/i]')
  #
  def to_html(str,
    quotes:     true,
    minuses:    true,
    new_lines:  true
  )

    new_str = ::Ant::Parser.new(str).to_html

    quotes(new_str)     if quotes
    minuses(new_str)    if minuses
    new_lines(new_str)  if new_lines

    new_str

  end # to_html

  def tag(name, singular: false, aliases: [], &block)

    def_tag = ::Ant::Tag.new(name, singular: singular, &block)

    (aliases << name).each { |al|
      add(al, def_tag)
    }

    self

  end # tag

  def get(name)
    tags_map[name.to_sym]
  end # get

  def remove(name)
    tags_map[name.to_sym] = nil
  end # remove

  def clean(name)
    @tags_map = {}
  end # clean
  alias :reset :clean

  def config(&block)
    instance_eval(&block)
  end # config

  private

  def tags_map
    @tags_map ||= {}
  end # tags_map

  def add(name, tag)
    tags_map[name.to_sym] = tag
  end # add

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

end # Ant

require "ant/default"
