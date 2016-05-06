#
# Объект html тега
#
module Ant

  class Tag

    TMPL_BASE     = %Q(<%{name}%{options}%{args}>%{content}</%{name}>).freeze
    TMPL_SINGULAR = %Q(<%{name}%{options}%{args}/>).freeze

    def initialize(name, singular: false, &block)

      @name     = name
      @singular = singular
      @block    = block || nil

    end # initialize

    def name
      @name
    end # name

    def singular?
      @singular == true
    end # singular?

    def compile(args, options, content)

      # Если задан блок обработки
      return @block.call(args, options, content) if @block.is_a?(::Proc)

      # Если тег самозакрывающийся
      return TMPL_SINGULAR % {

        name:     @name,
        args:     args_to_s(args),
        options:  hash_to_s(options)

      } if self.singular?

      # Общий случай
      TMPL_BASE % {

        name:     @name,
        args:     args_to_s(args),
        options:  hash_to_s(options),
        content:  content

      }

    end # compile

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     #{@name},\n"    <<
      " singular: #{@singular},\n"    <<
      " block:    #{@block.inspect}>\n"

    end # inspect

    private

    def args_to_s(args)
      args.empty? ? "" : " #{args.join(' ')}"
    end # args_to_s

    def hash_to_s(hash)

      return "" if hash.empty?
      s = hash.inject([]) { |str, el| str << "#{el[0]}=#{el[1]}" }.join(' ')
      " #{s}"

    end # hash_to_s

  end # Tag

end # Ant
