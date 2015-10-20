#!/usr/bin/python
import os
import shutil
# Create db directory
try:
    os.makedirs("/etc/simple/db",mode=0777)
except OSError:
    pass
# Copy init script to /etc/init.d
os.chdir('..')
pwd_str = os.getcwd()
os.chdir('bin')
with open('simple_init', 'r') as input_file, open('new_file', 'w') as output_file:
    for line in input_file:
        if 'export' in line.strip():
            output_file.write('export SIMPLE_APP_HOME=%s\n' % (pwd_str))
        else:
            output_file.write(line)
shutil.move('new_file','simple_init')
os.chmod('simple_init',0777)
shutil.copy('simple_init', '/etc/init.d/simple')
os.system('update-rc.d simple defaults')
