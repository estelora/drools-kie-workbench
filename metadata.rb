name 'drools-kie-workbench'
maintainer       'Lydia Joslin'
maintainer_email 'lydiaejoslin@gmail.com'
description 'Installs/Configures Wildfly and Drools (KIE WB and KIE Server)'
version '1.0.0'
license 'MIT license'

depends 'wildfly'

supports 'centos', '>= 6.0'

source_url 'https://github.com/estelora/drools-kie-workbench' if respond_to?(:source_url)
issues_url 'https://github.com/estelora/drools-kie-workbench/issues' if respond_to?(:issues_url)
