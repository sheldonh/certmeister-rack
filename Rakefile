require "rspec/core/rake_task"
require "certmeister/rack/version"

desc 'Build gem into the pkg directory'
task :build => :spec do
  FileUtils.rm_rf('pkg')
  Dir['*.gemspec'].each do |gemspec|
    system "gem build #{gemspec}"
  end
  FileUtils.mkdir_p('pkg')
  FileUtils.mv(Dir['*.gem'], 'pkg')
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh 'git', 'tag', '-m', "Released v#{Certmeister::Rack::VERSION}", "v#{Certmeister::Rack::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Certmeister::Rack::VERSION}"
  sh "ls pkg/*.gem | xargs -n 1 gem push"
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
