
Gem::Specification.new do |s|

  s.name = 'dispatio'

  s.version = File.read(
    File.expand_path("../lib/#{s.name}.rb", __FILE__)
  ).match(/ VERSION *= *['"]([^'"]+)/)[1]

  s.platform = Gem::Platform::RUBY
  s.authors = [ 'John Mettraux' ]
  s.email = [ 'jmettraux+flor@gmail.com' ]
  s.homepage = "https://github.com/floraison/#{s.name}"
  s.license = 'MIT'
  s.summary = 'a stupid dispatch table tool'

  s.description = %{
A stupid dispatch table for convenience.
  }.strip

  s.metadata = {
    'changelog_uri' => s.homepage + '/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => s.homepage + '/issues',
    'documentation_uri' => s.homepage,
    'homepage_uri' =>  s.homepage,
    'source_code_uri' => s.homepage,
    #'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/floraison',
    #'wiki_uri' => s.homepage + '/wiki',
    'rubygems_mfa_required' => 'true',
  }

  #s.files = `git ls-files`.split("\n")
  s.files = Dir[
    '{README,CHANGELOG,CREDITS,LICENSE}.{md,txt}',
    #'Makefile',
    'lib/**/*.rb', #'spec/**/*.rb', 'test/**/*.rb',
    "#{s.name}.gemspec",
  ]

  #s.add_runtime_dependency 'tzinfo'
    # this dependency appears in 'et-orbi'

  #s.add_runtime_dependency 'raabro', '~> 1.4'

  #s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'probatio', '~> 1.6'

  s.require_path = 'lib'
end

