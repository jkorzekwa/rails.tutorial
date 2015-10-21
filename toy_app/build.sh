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
mv apache-tomcat-* toy_app-$VERSION

# Move war into tomcat
mv toy_app.war toy_app-$VERSION/webapps/toy.war
rm -rf toy_app-$VERSION/webapps/ROOT
ln -s toy.war toy_app-$VERSION/webapps/ROOT.war

# Move required files into tomcat
mv install.sh toy_app-$VERSION/bin
mv uninstall.sh toy_app-$VERSION/bin
mv app_init toy_app-$VERSION/bin
mkdir -p toy_app-$VERSION/conf/Catalina/localhost
mv ROOT.xml toy_app-$VERSION/conf/Catalina/localhost
chmod 777 toy_app-$VERSION/bin/*
sed -i 's/port="8080"/port="8182"/g' toy_app-$VERSION/conf/server.xml
sed '$iexport CATALINA_OPTS="-Xmx512m"' toy_app-$VERSION/bin/startup.sh
sed '$iexport JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"' toy_app-$VERSION/bin/startup.sh

# Package app
tar -zcvf toy_app-$VERSION.tar.gz toy_app-$VERSION
