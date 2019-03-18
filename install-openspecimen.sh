#!/bin/bash

OS_HOME="/usr/local/openspecimen"

createDirStructure() {
  
  if [ ! -d "$OS_HOME" ]; then
    mkdir -p "$OS_HOME"
    rc=$?;
    if [[ $rc != 0 ]]; then
      echo 
      exit $rc;
    fi
  fi

  if [ ! -d "$OS_HOME/plugins" ]; then
    echo "Creating OpenSpecimen plugins ($OS_HOME/plugins) directory."
    mkdir -p "$OS_HOME/plugins"
    rc=$?;
    if [[ $rc != 0 ]]; then
      echo "Error: Could not create the plugins directory $OS_HOME/plugins. Please ensure you've appropriate rights to create the directory.";
      exit $rc;
    fi
  fi

  if [ -d "$OS_HOME/plugin" ]; then
    touch  "$OS_HOME/plugin/test.txt"
    rc=$?;
    rm $OS_PLUGIN_DIR/test.txt

    if [[ $rc != 0 ]]; then
      echo "Error: Do not have write permissions on the directory $OS_HOME/plugins.";
      exit $rc;
    fi
  fi

  if [ ! -d "$OS_HOME/data" ]; then
    echo "Creating OpenSpecimen data ($OS_HOME/data) directory."
    mkdir -p "$OS_HOME/data"
    rc=$?;
    if [[ $rc != 0 ]]; then
      echo "Error: Could not create the data directory $OS_HOME/data. Please ensure you've appropriate rights to create the directory.";
      exit $rc;
    fi
  fi
}

installTomcat() {
  echo "Installing Tomcat9..."
  if [ -e "Tomcat9.zip" ]; then
    unzip Tomcat9.zip
    cp -r tomcat-as "$OS_HOME/tomcat"
  else
    echo "Tomcat.zip file is not present in the current directory."
    exit 127;
  fi
}

populateOsPropertiesfile() {
  echo "Copying configured OpenSpecimen.properties file to $OS_HOME/tomcat/conf directory."
  cp openspecimen.properties "$OS_HOME/tomcat/conf/"
  
  sed -i "s/tomcat.dir=/tomcat.dir=\/usr\/local\/openspecimen\/tomcat/g" "$OS_HOME/tomcat/conf/openspecimen.properties"
  sed -i "s/app.data_dir=/app.data_dir=\/usr\/local\/openspecimen\/data/g" "$OS_HOME/tomcat/conf/openspecimen.properties"
  sed -i "s/plugin.dir=/plugin.dir=\/usr\/local\/openspecimen\/plugins/g" "$OS_HOME/tomcat/conf/openspecimen.properties"
}

copyWarAndPlugins() {
  echo "Copying the plugins into $OS_HOME/plugins directory..."
  cp plugin_build/*.jar "$OS_HOME/plugins/"

  echo "Copying OpenSpecimen app..."
  cp openspecimen.war "$OS_HOME/tomcat/webapps"
}

main() {
  createDirStructure;
  installTomcat;
  populateOsPropertiesfile;
  copyWarAndPlugins;
}
main;
