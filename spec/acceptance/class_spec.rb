require 'spec_helper_acceptance'

describe 'role_deployserver class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'role_deployserver': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep(10) # Puppetdb takes a while to start up
      apply_manifest(pp, :catch_changes  => true)
    end

       
   # a role can include one ore more profiles, testing if work idempotently with no errors is sufficient

  end
end
