# ----------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: create_domain.py
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.01.19
# Revision...:
# Purpose....: Script to create a Domain
# Notes......:
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ----------------------------------------------------------------------
import os

# define environment variables
domain_name      = os.environ.get('DOMAIN_NAME', "cpu_domain")
domain_home      = os.environ.get('DOMAIN_HOME', "/u01/domains/%s" % domain_name)
nm_port          = int(os.environ.get('PORT_NM', "5556"))
admin_port       = int(os.environ.get('PORT', "7001"))
listen_port      = int(os.environ.get('PORT', "7001"))
admin_sslport    = int(os.environ.get('PORT_SSL', "7002"))
wls_admin        = os.environ.get('ADMIN_USER', "weblogic")
wls_pwd          = os.environ.get('ORACLE_PWD')
wls_home         = os.environ.get('ORACLE_HOME')
jdk_home         = os.environ.get('JAVA_HOME')
machine_name     = os.environ.get('HOSTNAME') 
production_mode  = os.environ.get('DOMAIN_MODE', "dev")

print('Domain Name      : [%s]' % domain_name)
print('Domain Home      : [%s]' % domain_home)
print('WLS Home         : [%s]' % wls_home)
print('Java Home        : [%s]' % jdk_home)
print('Nodemanager Port : [%s]' % nm_port)
print('Admin Port       : [%s]' % admin_port)
print('Admin SSL Port   : [%s]' % admin_sslport)
print('User             : [%s]' % wls_admin)
print('Password         : [%s]' % wls_pwd)

#=====================================================================
# Read right templates, you can add more elif clauses
#=====================================================================
selectTemplate('Basic WebLogic Server Domain')
loadTemplates()
#=====================================================================
# Set Domain Parameters which are generic
#=====================================================================
set('Name', domain_name)
setOption('DomainName', domain_name)
setOption('ServerStartMode', production_mode)
setOption('JavaHome', jdk_home)
#=====================================================================
# Configure Admin Server 
#=====================================================================
cd('/Server/AdminServer')
set('Name','AdminServer')
set('ListenPort', listen_port)
#=====================================================================
# Configure Security
#=====================================================================
cd('/Security/%s/User/weblogic' % domain_name)
cmo.setName(wls_admin)
cmo.setPassword(wls_pwd)
#=====================================================================
# Configure Machine
#=====================================================================
cd('/')
machine = create(machine_name, 'Machine')
machine.setName(machine_name)
#=====================================================================
# Configure Nodemanager 
#=====================================================================
cd('/NMProperties')
set('ListenAddress', 'localhost')
set('ListenPort', nm_port)
cd('/SecurityConfiguration/base_domain')
set('Name', domain_name)
cd('/SecurityConfiguration/%s' % domain_name)
set('NodeManagerUsername', wls_admin)
set('NodeManagerPasswordEncrypted', wls_pwd)
#=====================================================================
# Save the domain to ###DOMAIN_HOME###
#=====================================================================
writeDomain(domain_home)
closeTemplate()
# --- EOF ---------------------------------------------------------------------