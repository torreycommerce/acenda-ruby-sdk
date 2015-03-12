begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec) do |t|
        t.pattern = 'tests/specs/*_spec.rb'
        t.rspec_opts = "-c --format documentation"
        t.verbose = true
    end
rescue LoadError
end
