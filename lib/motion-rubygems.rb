module Motion::Project
  
  class Config
    # Allow the user to do 'app.gems = %w(andand)'
    variable :gems
  end

  class << App
    # Override the original setup so that we can put gems before the user's own
    # files.
    def setup_with_motion_rubygems
      setup_without_motion_rubygems do |app|
        yield app

        unless app.gems == []
          app.files = MotionRubyGems.files(app.gems) + app.files
        end
      end
    end

    alias setup_without_motion_rubygems setup
    alias setup setup_with_motion_rubygems
  end

  class MotionRubyGems
    # Get a list of files that are required for the given gems.
    #
    # This includes a few meta-files to ensure that gems have a better
    # chance of working.
    def self.files(gems)
      gem_files = []
      gem_files << MotionRubyGems.version_file
      gem_files << File.expand_path("../remove_require.rb", __FILE__)

      gems.each do |gem|
        gem_files += MotionRubyGems.files_for(gem)
      end

      gem_files << File.expand_path("../restore_require.rb", __FILE__)
    end

    # Get the files required by a given gem.
    #
    # At the moment this runs the gem with an overridden 'require'; it would be
    # nice to add support for a `<gemname>.motion.rb` that can be used instead.
    def self.files_for(gem)
      require version_file
      before = $".dup
      require gem
      files = $" - before

      if (non_ruby = files - files.grep(/\.rb$/)) != []
        raise "gem: #{gem} is not pure ruby: #{non_ruby.inspect}"
      end

      files
    end

    # This is a file that sets the RUBYMOTION_VERSION constant so that gems
    # can alter their behaviour for Ruby Motion if necessary.
    def self.version_file
      File.expand_path("~/.motion-rubygems.version.rb").tap do |file|
        File.open(file, 'w') do |f|
          f.puts "RUBYMOTION_VERSION = #{Motion::Version.inspect}"
        end
      end
    end
  end
end

