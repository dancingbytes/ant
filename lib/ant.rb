require "ant/version"
require "ant/null_tag"
require "ant/tag"
require "ant/text_node"
require "ant/node"
require "ant/parser"
require "ant/config"

module Ant

  extend self

  DEFAULT_OPTS = {
    quotes:     true,
    minuses:    true,
    new_lines:  true
  }.freeze

  #
  # Преобразование bbcode-ов в html
  #
  # Ant.to_html(%{[p]my 'string!\'' [i color="#f00"]red text[/i]})
  # Ant.to_html(%{[p]my 'string!\'' var i = [1,2,3]; [i color="#f00"]red text[/i]})
  #
  def to_html(str, options = nil, conf = nil)

    ::Ant::Parser.new(
      str.to_s,
      options || DEFAULT_OPTS,
      conf    || default_conf
    ).to_html

  end

  #
  # Задание параетров блоком
  #
  # Ant.config do
  #
  #  tag :strong
  #  tag :li
  #
  # end
  #
  #
  def config(&block)
    default_conf.instance_eval(&block)
  end

  #
  # Список тегов
  #
  def tags_map
    default_conf.tags_map
  end

  #
  # Удаление всех тегов
  #
  def clean

    default_conf.clean
    self

  end

  alias :reset  :clean

  private

  def default_conf
    @conf ||= ::Ant::Config.new
  end

end # Ant

require "ant/default"

# Если у нас rails -- интегрируемся
require 'ant/engine' if defined?(::Rails)
