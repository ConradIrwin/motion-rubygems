module Motion::Project
  class Config
    variable :gems
  end

  class << Motion::Project::App
    def setup_with_motion_rubygems
      setup_without_motion_rubygems do |app|
        yield app

        app.files.unshift File.expand_path("../restore_require.rb", __FILE__)
        app.gems.each do |gem|
          app.files.unshift Motion::Project::GemFinder.files_for(gem)
        end
        app.files.unshift File.expand_path("../remove_require.rb", __FILE__)
      end
    end

    alias setup_without_motion_rubygems setup
    alias setup setup_with_motion_rubygems
  end

  class GemFinder
    def self.paths_for(gem)
      before = $".dup
      require gem
      paths = $" - before

      if (non_ruby = paths - paths.grep(/\.rb$/)) != []
        raise "gem: #{gem} is not pure ruby: #{non_ruby.inspect}"
      end

      paths
    end
  end
end

