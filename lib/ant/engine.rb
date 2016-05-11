require 'rails/railtie'

module Ant

  class Engine < ::Rails::Engine

    initializer :assets do |app|

#      app.config.assets.precompile += %w{ ant.css }
#      app.config.assets.precompile += %w{ ant.js }
      app.config.assets.paths << root.join('app', 'assets')

    end

  end # Engine

end # Ant
