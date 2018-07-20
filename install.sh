#!/bin/bash

WAR_NAME=`ls $1 | cut -d'.' -f1`
TOMCAT_PATH=`cat $1 | grep "tomcat.dir" | cut -d'=' -f2`
PLUGIN_DIR=`cat $1 | grep "plugin.dir" | cut -d'=' -f2`
BACKUP_DIR=$(date +%d%B%Y)
CURRENT_PATH=$(pwd)

echo "War name : $WAR_NAME";

echo "Creating folder with today's date";
mkdir bkp_$BACKUP_DIR

echo "creating backup folders for plugins and war";
mkdir bkp_$BACKUP_DIR/war bkp_$BACKUP_DIR/plugins

echo "Taking backup of plugin";
cp $PLUGIN_DIR/*.jar bkp_$BACKUP_DIR/plugins

echo "Taking war backup";
cd $TOMCAT_PATH
WAR_NAME=$WAR_NAME.war
cp webapps/$WAR_NAME $CURRENT_PATH/bkp_$BACKUP_DIR/war

echo "Server Down";
bin/./shutdown.sh -force

echo "Removing plugins";
rm $PLUGIN_DIR/*.jar

echo "Removing war"
rm webapps/$WAR_NAME

#echo "Removing war folder"
#rm -rf $TOMCAT/webapps/$WAR_NAME

echo "adding .properties file into tomcat/conf";
cp $CURRENT_PATH/$1 conf/

echo "Adding new plugins";
cp $CURRENT_PATH/plugin_build/*.jar $PLUGIN_DIR

echo "Adding new war";
cp  $CURRENT_PATH/openspecimen.war webapps/

mv webapps/openspecimen.war webapps/$WAR_NAME

echo "Server Up..";
bin/./startup.sh
