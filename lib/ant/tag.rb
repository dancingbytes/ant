#
# Объект html тега
#
module Ant

  class Tag

    TMPL_BASE     = %Q(<%{name}%{options}%{args}>%{content}</%{name}>).freeze
    TMPL_SINGULAR = %Q(<%{name}%{options}%{args}/>).freeze

    def initialize(
      name,
      config,
      singular: false,
      slaves: nil,
      aliases: [],
      &block
    )

      @name       = name
      @singular   = singular
      @block      = block   || nil
      @aliases    = aliases
      @slaves     = slaves
      @config     = config

    end # initialize

    def name
      @name.to_sym
    end

    def singular?
      @singular == true
    end

    def slave_tags

      return @slave_tags if @slave_tags

      if @slaves.is_a?(::Array)

        @slave_tags = @slaves.inject([]) { |arr, el|

          arr << el
          arr << @config.get(el).aliases

        }

        @slave_tags.flatten!
        @slave_tags.uniq!
        @slave_tags.map!(&:to_sym)

      else
        @slave_tags = []
      end

      @slave_tags

    end # slave_tags

    def aliases
      @aliases
    end

    def compile(args, options, content, tags)

      # Если задан блок обработки
      if (res = @block).is_a?(::Proc)

        begin
          res = res.call(args, options, content, tags)
        end while res.is_a?(::Proc)

        return res

      end # if

      # Если тег самозакрывающийся
      return TMPL_SINGULAR % {

        name:     name,
        args:     args_to_s(args),
        options:  hash_to_s(options)

      } if self.singular?

      # Общий случай
      TMPL_BASE % {

        name:     name,
        args:     args_to_s(args),
        options:  hash_to_s(options),
        content:  content

      }

    end # compile

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     #{name},\n"        <<
      " singular: #{singular?},\n"    <<
      " slaves:   #{slave_tags},\n"  <<
      " block:    #{@block.inspect}>\n"

    end

    private

    def args_to_s(args)
      args.empty? ? "" : " #{args.join(' ')}"
    end

    def hash_to_s(hash)

      return "" if hash.empty?
      s = hash.inject([]) { |str, el| str << "#{el[0]}=#{el[1]}" }.join(' ')
      " #{s}"

    end

  end # Tag

end # Ant
