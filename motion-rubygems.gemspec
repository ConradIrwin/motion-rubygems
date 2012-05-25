Gem::Specification.new do |s|
  s.name = "motion-rubygems"
  s.version = "0.1.pre.2"
  s.platform = Gem::Platform::RUBY
  s.author = "Conrad Irwin"
  s.email = "conrad.irwin@gmail.com"
  s.homepage = "http://github.com/ConradIrwin/motion-rubygems"
  s.summary = "Provides primitive support for requiring some rubygems into RubyMotion"
  s.description = "Not all (or even many) gems will work out of the box on RubyMotion. However some do, so it'd be nice to be able to use them."
  s.files = `git ls-files`.lines.map(&:strip)
  s.require_path = "lib"
end
