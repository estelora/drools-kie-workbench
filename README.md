# Drools Kie-Workbench Cookbook

* This is not yet a production-level cookbook, but meant to serve as a reference.
* If you want to try setting up this server by hand, you can find my playbook [here](https://lejoslin.me/2016/10/26/drools-kie-workbench-playbook-for-centos-6-6/).

# Requirements
* [Wildfly Cookbook](https://github.com/bdwyertech/chef-wildfly)
   * This cookbook is, in many ways, a wrapper cookbook to bdywertech's wildfly cookbook.
* Chef Client > 11.0

#### Platform
* CentOS, Red Hat

#### Tested on:
* Centos 6.6

## Usage: 
* Please add users in attributes/users.rb

#### Deploy Wars with the Download Recipe
* Set their versions with attributes at the role level.

#### Set Most Attributes at the Role Level (an example role is provided)

## Future Steps: 
* Set attributes at the cookbook level.

#### Author
Lydia Joslin
