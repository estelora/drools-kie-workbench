# encoding: UTF-8
#
# Cookbook Name:: ultralinq-wildfly
# Recipe:: download
# Downloads / Unarchives the following:
# - KIE-WB Drools distribution
# - KIE-Server

# Shorten Hashes
wildfly = node['wildfly']
kieserver = node['wars']['kie_server']
kiewb = node['wars']['kie_wb']
downloads = node['downloads']
deployments = node['deployments']
wars = node['wars']

# Install Yum Unzip Package
package 'unzip'

# Download kie-wb-drools-distribution
remote_file "#{downloads['directory']}/#{kiewb['war_name']}" do
  source "#{kiewb['url']}#{kiewb['war_name']}"
  owner wildfly['user']
  group wildfly['group']
  mode 0755
  action :create_if_missing
  not_if { ::File.exist? "#{downloads['directory']}/#{kiewb['war_name']}" }
end

# Download Kie-server
remote_file "#{downloads['directory']}/#{kieserver['zip_name']}" do
  source "#{kieserver['url']}#{kieserver['zip_name']}"
  owner wildfly['user']
  group wildfly['group']
  mode 0755
  action :create_if_missing
  not_if { ::File.exist? "#{wildfly['base']}#{deployments['directory']}/#{kieserver['war_name']}" }
end

# Extract kie-server
bash "extract #{kieserver['name']}" do
  cwd downloads['directory']
  user wildfly['user']
  group wildfly['group']
  code <<-EOH
    unzip -o "#{kieserver['zip_name']}"
  EOH
  not_if { ::File.exist? "#{wildfly['base']}#{deployments['directory']}/#{kieserver['war_name']}" }
end

# Create .dodeploy files
wars.each do |war, property|
  file "#{downloads['directory']}/#{property['war_name']}#{property['marker']}" do
    owner wildfly['user']
    group wildfly['group']
    mode 0755
    action :create_if_missing
    notifies :restart, "service[#{wildfly['service']}]", :delayed
  end
end

# Move war and .do deploy to /deployments
bash "Move war files to #{deployments['directory']}" do
  cwd downloads['directory']
  user wildfly['user']
  group wildfly['group']
  code <<-EOH
    cp -t "/opt/wildfly#{deployments['directory']}" \
    kie-drools-wb-distribution-wars-6.4.0.Final-wildfly8.war \
    kie-server-6.4.0.Final-ee7.war \
    kie-drools-wb-distribution-wars-6.4.0.Final-wildfly8.war.dodeploy \
    kie-server-6.4.0.Final-ee7.war.dodeploy
  EOH
  not_if { ::File.exist? "/opt/wildfly#{deployments['directory']}/#{kieserver['war_name']}" }
  notifies :restart, "service[#{wildfly['service']}]", :delayed
end



