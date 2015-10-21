#!/usr/bin/env bash
# Run in root app directory
sudo apt-get -y install nodejs rpm wget
jruby -S bundle update
jruby -S bundle install
jruby -S warble
wget http://apache.mirrors.pair.com/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz
tar -xzf apache-tomcat-*.tar.gz
rm -rf apache-tomcat-*.tar.gz

mv apache-tomcat-* simple_app-$VERSION
mv simple.war simple_app-$VERSION/webapps
rm -rf simple_app-$VERSION/webapps/ROOT
ln -s simple.war simple_app-$VERSION/webapps/ROOT.war

mv install.sh simple_app-$VERSION/bin
mv uninstall.sh simple_app-$VERSION/bin
mv simple_init simple_app-$VERSION/bin
mkdir -p simple_app-$VERSION/conf/Catalina/localhost
mv ROOT.xml simple_app-$VERSION/conf/Catalina/localhost
chmod 777 simple_app-$VERSION/bin/*
tar -zcvf simple_app-$VERSION.tar.gz simple_app-$VERSION
sed -i 's/port="8080"/port="8181"/g' simple_app-$VERSION/conf/server.xml