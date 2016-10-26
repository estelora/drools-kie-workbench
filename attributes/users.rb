# encoding: UTF-8
#
# Copyright (C) 2014 Brian Dwyer - Intelligent Digital Services
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# => Wildfly User Configuration

# => Access Control Provider (simple, or rbac)
default['wildfly']['acp'] = 'simple'

# => By default, Wildfly expects this password hash format:
# => # => username=HEX( MD5( username ':' realm ':' password))

# => Default management user
default['wildfly']['users']['mgmt'] = [
    { 'id'=> 'kieserver', 'passhash'=> 'd6a23f8351b907d45b7b0794c0048f64' },
]

# Add application users to the hash 'app'  HERE
#
default['wildfly']['users']['app'] = [
    {'id'=> 'kieserver', 'passhash'=> '92dcac1b6566adc6986d5bf00724a72c'},
    {'id'=> 'admin', 'passhash'=> 'ac8f1bbfcfcf857e0f0307cbba03989d'},
]

# Add application roles HERE
#
default['wildfly']['roles']['app'] = [
    {'id'=> 'kieserver', 'roles'=> 'admin,kie-server,kiemgmt,rest-all'},
    {'id'=> 'admin', 'roles'=> 'admin,kie-server,kiemgmt,rest-all'},
]

# Create symbolic links for user files
#
default['wildfly']['configuration']['domain_path'] = "#{wildfly['base']}/domain/configuration/"
default['wildfly']['configuration']['standalone_path'] = "#{wildfly['base']}/standalone/configuration/"
default['wildfly']['configuration']['filenames'] = [
    'mgmt-users.properties',
    'application-roles.properties',
    'application-users.properties'
]