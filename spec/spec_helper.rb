RSpec.configure do |c|
  c.example_status_persistence_file_path="./.rspec-failures"
  c.filter_run_when_matching :focus
  c.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
