name 'drools'
description 'role to install drools'

run_list=[
    'recipe[wildfly::default]',
    'recipe[ultralinq-wildfly::default]',
    'recipe[ultralinq-wildfly::download]',
]

env_run_lists(
    '_default' => [],
    'development' => run_list,
    'dev' => run_list,
    'staging' => run_list,
    'production' => run_list,
    'prod' => run_list
)

default_attributes(
    'java' => {
        'install_flavor' => 'oracle',
        'jdk_version' => '7',
        'jdk' => {
            '7' => {
                'x86_64' => {
                    'url' => 'http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz',
                    'checksum' => 'da1ad819ce7b7ec528264f831d88afaa5db34b7955e45422a7e380b1ead6b04d'
                }
            }
        },
        'java_home' => '/usr/lib/jvm/java',
        'oracle' => {
            'accept_oracle_download_terms' => true,
        },
    },

    'wildfly' => {
        'version' => '8.2.1',
        'url' => 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz',
        'checksum' => '845bc298ef9d72cf91b8781286a64554dea353df9d555391720635f32b73717c',
        'java_opts' => {
            'xmx' => '12G',
            'xms' => '6G',
            'xx_maxpermsize' => '768m',
            'preferipv4' => 'true',
            'headless' => 'false'
        }
    },


    'deployments' => {
        'directory' => '/standalone/deployments',
    },

    'downloads' => {
        'directory' => '/tmp'
    },
    'backup' => {
        'base' => '/data/drools_data',
        'niogit' => '/niogit',
    },

    'wars' => {
        'kie_wb' => {
            'name' => 'KIE Drools WB',
            'war_name' => 'kie-drools-wb-distribution-wars-6.4.0.Final-wildfly8.war',
            'url' => 'http://download.jboss.org/drools/release/6.4.0.Final/',
            'marker' => '.dodeploy',
            'complete' => '.deployed',
            'failed' => '.failed',
            'isdeploying' => '.isdeploying'

        },

        'kie_server' => {
            'name' => 'KIE Server',
            'war_name' => 'kie-server-6.4.0.Final-ee7.war',
            'url' => 'http://download.jboss.org/drools/release/6.4.0.Final/',
            'marker' => '.dodeploy',
            'complete' => '.deployed',
            'failed' => '.failed',
            'isdeploying' => '.isdeploying',
            'zip_name' => 'kie-server-distribution-6.4.0.Final.zip'
        },

    }
)

override_attributes(

)
