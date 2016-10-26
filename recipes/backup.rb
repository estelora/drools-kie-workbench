# TODO: Remove this - not necessary for the basic cookbook

# encoding: UTF-8
      #
      # Cookbook Name:: ultralinq-wildfly
      #  Recipe:: backup
      #  Backs up the following to S3 and
      # - .niogit repositories
      # - user configurations

# Add s3cmd yum package
package 's3cmd'

# Backup users and .niogit repos
template '/etc/cron.d/backup.sh' do
  source 'backup.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create cron task to run backup, every day at 2:00am
cron 'backup.sh' do
  minute '0'
  hour '02'
  day '*'
  command '/etc/cron.d/backup.sh'
  user 'root'
end

cron 'restart wildfly PM' do
  hour '22'
  user 'root'
  minute '30'
  command '/etc/init.d/wildfly restart'
end

cron 'restart wildfly AM' do
  hour '12'
  user 'root'
  minute '30'
  command '/etc/init.d/wildfly restart'
end


