require 'rails/generators/base'

module GAnalytics
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a GAnalytics initializer.'

      def copy_initializer
        template 'ganalytics.rb', 'config/initializers/ganalytics.rb'
      end
    end
  end
end