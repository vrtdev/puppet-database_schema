require 'spec_helper'

describe 'database_schema::flyway_migration' do
  let(:title){"example db"}
  let(:params){{
    :schema_source => '/some/path',
    :db_username   => 'user',
    :db_password   => 'supersecret',
    :jdbc_url      => 'jdbc:h2:test'
  }}
  include_examples :compile
  describe 'placeholders' do
    context 'when not specified' do
      it 'should not have placeholders in exec command' do
        command = catalogue.resource('exec', 'Migration for example db').send(:parameters)[:command]
        expect(command).to include('flyway -user=\'user\' -password=\'supersecret\' -url=\'jdbc:h2:test\'  -locations=')
      end
    end
    context 'when specified' do
      let(:params){{
        :schema_source => '/some/path',
        :db_username   => 'user',
        :db_password   => 'supersecret',
        :jdbc_url      => 'jdbc:h2:test',
        :placeholders  => {'key1' => 'val1', 'key2' => 'val2'}
      }}
      it 'should have placeholders in exec command' do
        command = catalogue.resource('exec', 'Migration for example db').send(:parameters)[:command]
        expect(command).to include('flyway -user=\'user\' -password=\'supersecret\' -url=\'jdbc:h2:test\' -placeholders.key1=\'val1\' -placeholders.key2=\'val2\' -locations=')
      end
    end
  end
end
