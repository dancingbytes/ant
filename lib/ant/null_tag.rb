module Ant

  module NullTag

    extend

    def singular?; false; end

    def compile(*args); content; end

    def inspect

      "#<#{self.class}:0x#{'%x' % (self.object_id << 1)}\n" <<
      " name:     null,\n"    <<
      " singular: false,\n"    <<
      " block:    null>\n"

    end # inspect

  end # NullTag

end # Ant
