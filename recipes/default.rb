# encoding: UTF-8
#
# Cookbook Name:: ultralinq-wildfly
# Recipe:: default
# Initial setup of wildfly server

service node['wildfly']['service']

include_recipe 'wildfly'

# Create /data/drools_data
directory '/data/drools_data' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

# Create /data/drools_data/niogit
directory '/data/drools_data/niogit' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

# Create directory for user information
directory '/data/drools_data/users' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

# Create directory for Maven Repos
directory '/data/drools_data/m2' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

# Create directory for Lucene Metadata
directory '/data/drools_data/index' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

# Create repositories directory for .jar and .pom files
directory '/data/drools_data/kie' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

directory '/opt/wildfly/repositories' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '755'
  action :create
end

begin
  t = resources(:template =>'/opt/wildfly/standalone/configuration/standalone-full.xml')
  t.source 'standalone-full.xml.erb'
  t.cookbook 'ultralinq-wildfly'
  t.action :nothing
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find template to modify'
end

begin
  t = resources(:template => '/opt/wildfly/standalone/configuration/application-users.properties')
  t.source 'application-users.properties.erb'
  t.cookbook 'ultralinq-wildfly'
  t.action :nothing
  rescue Chef::Exceptions::ResourceNotFound
    Chef::Log.warn 'could not find template to modify'
end

begin
  t = resources(:template =>'/opt/wildfly/standalone/configuration/application-roles.properties')
  t.source 'application-roles.properties.erb'
  t.cookbook 'ultralinq-wildfly'
  t.action :nothing
  rescue Chef::Exceptions::ResourceNotFound
    Chef::Log.warn 'could not find template to modify'
end


# => Configure Wildfly standalone-full configuration for debug mode
template '/opt/wildfly/standalone/configuration/standalone-full.xml' do
  source 'standalone-full.xml.erb'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
  variables(
      app_users: node['wildfly']['users']['app']
  )
  action :create_if_missing
  notifies :restart, "service[#{node['wildfly']['service']}]", :delayed
end

# => Configure Wildfly Standalone - Application Users
template '/data/drools_data/users/application-users.properties' do
  source 'application-users.properties.erb'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
  variables(
      app_users: node['wildfly']['users']['app']
  )
  action :create_if_missing
  notifies :restart, "service[#{node['wildfly']['service']}]", :delayed
end

# => Configure Wildfly Standalone - Application Roles
template '/data/drools_data/users/application-roles.properties' do
  source 'application-roles.properties.erb'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
  variables(
      app_roles: node['wildfly']['roles']['app']
  )
  action :create_if_missing
  notifies :restart, "service[#{node['wildfly']['service']}]", :delayed
end

# Set custom wildfly-init-centos6.sh.erb
begin
  t = resources(:template => '/etc/init.d/wildfly')
  t.source 'wildfly-init-centos6.sh.erb'
  t.cookbook 'ultralinq-wildfly'
  rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find template to modify'
end

# Deploy Init Script
template '/etc/init.d/wildfly' do
  source 'wildfly-init-centos6.sh.erb'
  user 'root'
  group 'root'
  mode '0755'
  notifies :restart, "service[#{node['wildfly']['service']}]", :delayed
end

# Set custom /etc/default.wildfly.conf
begin
  t = resources(:template => '/etc/default/wildfly.conf')
  t.source 'wildfly.conf.erb'
  t.cookbook 'ultralinq-wildfly'
  rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find template to modify'
end

template '/etc/default/wildfly.conf' do
  source 'wildfly.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, "service[#{node['wildfly']['service']}]", :delayed
end

# Set custom standalone-full.xml
begin
  t = resources(:template => '/opt/wildfly/standalone/configuration/standalone-full.xml')
  t.source 'standalone-full.xml.erb'
  t.cookbook 'ultralinq-wildfly'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find template to modify'
end

template '/opt/wildfly/standalone/configuration/standalone-full.xml' do
  source 'standalone-full.xml.erb'
  owner node['wildfly']['user']
  group node['wildfly']['user']
  mode '0644'
  action :create
  notifies :restart, "service[#{node['wildfly']['service']}]", :delayed
end

=begin
Create symlinks for:
.niogit: kie-workbench data directory
.m2: maven repository directory
.index: lucene metadata directory
repositories: local storage of kie server state files directory
application-users: file with application user information
applcation-roles: file with application role information
=end

# Link .niogit to /data/drools_data/niogit
link '/opt/wildfly/.niogit' do
  to '/data/drools_data/niogit'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
end

# Link /opt/wildfly/.m2 to /data/kie/m2
link '/opt/wildfly/.m2' do
  to '/data/drools_data/m2'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
end

# Link /opt/wildfly/.index to /data/index
link '/opt/wildfly/.index' do
  to '/data/drools_data/index'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
end

# Link /opt/wildfly/repositories/kie to /data/kie
link '/opt/wildfly/repositories/kie' do
  to '/data/drools_data/kie'
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode '0755'
end

# Link /opt/wildfly/standalone/application-users.rb to /data/drools_data/users/application-users.rb
link '/opt/wildfly/standalone/configuration/application-users.properties' do
  to '/data/drools_data/users/application-users.properties'
end

# Link /opt/wildfly/standalone/application-roles.rb to /data/drools_data/users/application-users.rb
link '/opt/wildfly/standalone/configuration/application-roles.properties'   do
  to '/data/drools_data/users/application-roles.properties'
end

