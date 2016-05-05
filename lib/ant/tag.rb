module Ant

  class Tag

    TMPL_BASE     = %Q(<%{name} %{options} %{args}>%{content}</%{name}>).freeze
    TMPL_SINGULAR = %Q(<%{name} %{options} %{args} />).freeze

    def initialize(name, singular: false)

      @name     = name
      @singular = singular
      @block    = yield if block_given?

    end # initialize

    def singular?
      @singular == true
    end # singular?

    def compile(args, options, content)

      # Если задан блок обработки
      return block.call(args, options, content) if block.is_a?(::Proc)

      # Если тег самозакрывающийся
      return TMPL_SINGULAR % {

        name:     @name,
        args:     args.join(' '),
        options:  hash_to_s(options)

      } if self.singular?

      # Общий случай
      TMPL_BASE % {

        name:     @name,
        args:     args.join(' '),
        options:  hash_to_s(options),
        content:  content

      }

    end # compile

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     #{@name},\n"    <<
      " singular: #{@singular},\n"    <<
      " block:    #{@block}>\n"

    end # inspect

    private

    def hash_to_s(hash)
      hash.inject([]) { |str, el| str << "#{el[0]}=#{el[1]}" }.join(' ')
    end # hash_to_s

  end # Tag

end # Ant
