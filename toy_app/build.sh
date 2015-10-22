#!/usr/bin/env bash
# Run in root app directory
APP=toy_app
ARTIFACT_URL="http://knewrealitys.com:8081/artifactory"

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
mv apache-tomcat-* $APP

# Move war into tomcat
mv "$APP".war $APP/webapps/
rm -rf $APP/webapps/ROOT
ln -s "$APP".war $APP/webapps/ROOT.war

# Move required files into tomcat
mv install.sh $APP/bin
mv uninstall.sh $APP/bin
mv app_init $APP/bin
mv infrastructure $APP/
mkdir -p $APP/conf/Catalina/localhost
mv ROOT.xml $APP/conf/Catalina/localhost
chmod 777 $APP/bin/*
sed -i 's/port="8080"/port="8182"/g' $APP/conf/server.xml
sed '$iexport CATALINA_OPTS="-Xmx512m"' $APP/bin/startup.sh
sed '$iexport JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"' $APP/bin/startup.sh

# Package app
tar -zcvf $APP-$VERSION.tar.gz $APP

# Create build.properties
echo VERSION=$VERSION >> $APP/build.properties
echo APP=$APP >> $APP/build.properties
echo ARTIFACT=$APP-$VERSION.tar.gz >> $APP/build.properties
echo ARTIFACT_REPO=$ARTIFACT_REPO >> $APP/build.properties
echo ARTIFACT_URL=$ARTIFACT_URL >> $APP/build.properties

