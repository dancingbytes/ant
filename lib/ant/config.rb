#
# Конфигурация
#
module Ant

  class Config

    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    #
    # Объявление тега
    #
    def tag(name, singular: false, aliases: [], slaves: nil, &block)

      def_tag = ::Ant::Tag.new(
        name,
        self,
        singular: singular,
        slaves:   slaves,
        aliases:  aliases,
        &block
      )

      (aliases << name).each { |al|
        tags_map[al.to_sym] = def_tag
      }

      self

    end

    #
    # Взятие тега по имени (используется в коде редактора)
    #
    def get(name)

      return if name.nil?
      tags_map[name.to_sym]

    end

    #
    # Удаление тега из объявления
    #
    def remove(name)

      tags_map[name.to_sym] = nil unless name.nil?
      self

    end

    #
    # Удаление всех тегов
    #
    def clean

      @tags_map = {}
      self

    end

    #
    # Алиасы
    #
    alias :del    :remove
    alias :add    :tag
    alias :reset  :clean

    #
    # Список тегов
    #
    def tags_map
      @tags_map ||= {}
    end

  end # Config

end # Ant
