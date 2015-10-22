#!/usr/bin/env bash
# Run in root app directory

# Install needed packages
sudo apt-get -y install nodejs rpm wget

# Bundle and war app
jruby -S bundle update
jruby -S bundle install
jruby -S warble

# Download tomcat app
wget http://apache.mirrors.pair.com/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz
tar -xzf apache-tomcat-*.tar.gz
rm -rf apache-tomcat-*.tar.gz
mv apache-tomcat-* toy_app

# Move war into tomcat
mv toy_app.war toy_app/webapps/toy.war
rm -rf toy_app/webapps/ROOT
ln -s toy.war toy_app/webapps/ROOT.war

# Move required files into tomcat
echo $VERSION > toy_app/version.txt
mv install.sh toy_app/bin
mv uninstall.sh toy_app/bin
mv app_init toy_app/bin
mv infrastructure toy_app/
mkdir -p toy_app/conf/Catalina/localhost
mv ROOT.xml toy_app/conf/Catalina/localhost
chmod 777 toy_app/bin/*
sed -i 's/port="8080"/port="8182"/g' toy_app/conf/server.xml
sed '$iexport CATALINA_OPTS="-Xmx512m"' toy_app/bin/startup.sh
sed '$iexport JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"' toy_app/bin/startup.sh

# Package app
tar -zcvf toy_app-$VERSION.tar.gz toy_app
