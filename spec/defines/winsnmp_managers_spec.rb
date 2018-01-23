require 'spec_helper'

describe 'winsnmp::managers', :type => 'define' do
  let(:title) { 'winsnmp::managers' }

  managers_reg_path = 'HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers'

  context 'With a title "fqdn.foo"' do
    let(:title) { 'fqdn.foo' }

    it {
      should contain_registry_value("#{managers_reg_path}\\1").with({
        :ensure => 'present',
        :type   => 'string',
        :data   => 'fqdn.foo',
      })
    }
  end

  context 'When the managers is overridden' do
    let(:title) { 'fqdn.foo' }
    let(:params) {{
      :managers => 'fqdn.bar',
    }}

    it { should contain_registry_value("#{managers_reg_path}\\1").width({
        :ensure => 'present',
        :type   => 'string',
        :data   => 'fqdn.bar',
      }) 
    }
  end
end
