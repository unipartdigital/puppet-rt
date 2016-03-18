require 'spec_helper'

describe 'rt' do
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
    it { should contain_class('rt') }
    it { should contain_anchor('rt::begin') }
    it { should contain_class('rt::install').that_requires('Anchor[rt::begin]') }
    it { should contain_class('rt::config').that_requires('Class[rt::install]') }
    it { should contain_anchor('rt::end').that_requires('Class[rt::config]') }
  end

end
