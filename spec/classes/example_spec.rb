require 'spec_helper'

describe 'role_deployserver' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "role_deployserver class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('role_deployserver') }       
          it { is_expected.to contain_class('profile_base') }
          it { is_expected.to contain_class('profile_puppetmaster') }

        end
      end
    end
  end
end
