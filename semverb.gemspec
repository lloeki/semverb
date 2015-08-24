Gem::Specification.new do |s|
  s.name        = 'semverb'
  s.version     = '1.0.0'
  s.licenses    = ['3BSD']
  s.summary     = 'Semantic versioning rake tasks for publishing ruby gems'
  s.description = <<-EOS
   Ruby and rubygems oriented rake tasks for semantic versioning and gem
   publishing, compatible with bundler, rubygems and geminabox.
  EOS
  s.authors     = ['Loic Nageleisen']
  s.email       = 'loic.nageleisen@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/lloeki/semverb'

  s.add_dependency 'rake'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'minitest'
end
