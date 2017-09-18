require 'spec_helper'

describe('rt::config') do
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
      'ensure'            => 'present',
      'user'              => 'root',
      'group'             => 'root',
      'web_user'          => 'apache',
      'web_group'         => 'apache',
      'config_dir'        => '/etc/rt',
      'config_site'       => '/etc/rt/RT_SiteConfig.pm',
      'config_d'          => '/etc/rt/RT_SiteConfig.d',
      'siteconfig'        => {},
      'defaultsiteconfig' => {
        'rtname'          => 'example.com',
        'DatabaseType'    => 'mysql',
        'Plugins'         => 'SEE_EXTENTIONS.PP',
      }
    }
  }

  it { should contain_class('rt::config') }
  it { should contain_file('/etc/rt').with(
    {
      'ensure' => 'directory',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755',
    }
  )
  }
  it { should contain_file('/etc/rt/RT_SiteConfig.pm').with(
    {
      'ensure'  => 'present',
      'owner'   => 'apache',
      'group'   => 'apache',
      'mode'    => '0640',
      'content' => "# This file is managed by puppet
use utf8;
Set($rtname, 'example.com');
Set($DatabaseType, 'mysql');
1;
"
    }
  )
  }
  it { should contain_exec('Site config syntax check') }

  end
end
