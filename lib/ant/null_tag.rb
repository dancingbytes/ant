module Ant

  module NullTag

    extend self

    def name; nil; end

    def singular?; false; end

    def slave_tags; []; end

    def aliases; []; end

    def compile(args, options, content); content; end

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     null,\n"    <<
      " singular: false,\n"    <<
      " block:    null>\n"

    end # inspect

  end # NullTag

end # Ant
