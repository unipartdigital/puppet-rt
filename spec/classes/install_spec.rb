require 'spec_helper'

describe('rt::install') do
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }
  context 'with defaults for all parameters' do
    let (:params) {{}}

    it do
      expect {
        should compile
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context 'with default parameters from init' do
  let (:params) {
    {
      'ensure'         => 'present',
      'package'        => 'rt',
      'package_ensure' => 'installed',
    }
  }
  it { should contain_package('rt').with_ensure('installed') }
 
  end
end
