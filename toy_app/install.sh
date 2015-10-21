#!/usr/bin/python
import os
import shutil

# Exit if not running as sudo
if os.geteuid() != 0:
    exit("You need to have root privileges to run this script.\nPlease try again, this time using 'sudo'. Exiting.")

# Create db directory
if not os.path.exists('/etc/simple/db'):
    os.makedirs("/etc/simple/db",mode=0777)

# Copy init script to /etc/init.d
os.chdir('..')
pwd_str = os.getcwd()
os.chdir('bin')
with open('app_init', 'r') as input_file, open('new_file', 'w') as output_file:
    for line in input_file:
        if 'export' in line.strip():
            output_file.write('export TOY_APP_HOME=%s\n' % (pwd_str))
        else:
            output_file.write(line)
shutil.move('new_file','simple_init')
os.chmod('simple_init',0777)
shutil.copy('app_init', '/etc/init.d/simple')
os.system('update-rc.d simple defaults')
os.system('service toy start')