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
    it { should contain_class('rt::perl').that_requires('Anchor[rt::begin]') }
    it { should contain_class('rt::install').that_requires('Class[rt::perl]') }
	it { should contain_class('rt::vhost').that_requires('Class[rt::install]') }
    it { should contain_class('rt::config').that_requires('Class[rt::vhost]') }
    it { should contain_class('rt::queue').that_requires('Class[rt::config]') }
    it { should contain_class('rt::path').that_requires('Class[rt::queue]') }
	it { should contain_anchor('rt::end').that_requires('Class[rt::path]') }
  end

end
