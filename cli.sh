#!/bin/bash
#
# --- Configuration
MOODLE_PLATFORM_FULLNAME="Moodle Learning Platform"
MOODLE_PLATFORM_SHORTNAME="Moodle Learning"
MOODLE_PLATFORM_SUMMARY="Learning platform"
MOODLE_PLATFORM_ADMIN_PASS="change123"
MOODLE_PLATFORM_ADMIN_EMAIL="admin@example.com"
DATABASE_BACKUP_DIR="db_backups"
#set this if using a remote docker host
#MOODLE_DOCKER_WEB_HOST=192.168.0.60


help(){
   # Display Help
   echo "$MOODLE_PLATFORM_SHORTNAME Moodle CLI"
   echo "---"
   echo "Syntax: $0 [--setup|--start|--stop|--delete|--reset|--help]"
   echo "options:"
   echo "--setup    Setup and launch the development environment"
   echo "--start    Start the development environment"
   echo "--stop     Stop the development environment"
   echo "--delete   Stop and delete the docker containers"
   echo "--reset    Cleanup, remove docker and Moodle dirs"
   echo "--dump     Create a dump of the database"
   echo "--help     Print this help."
   echo
}

setup(){
  echo "[+] Setting up Development Environment"

  if [ -d "$MOODLE_DOCKER_WWWROOT" ]; then
    echo "[+] Moodle detected"
  else
    echo "[+] Extract Moodle latest"
    tar zxf moodle-latest-400.tgz
  fi

  if [ -d "$MOODLE_DOCKER_PATH" ]; then
     echo "[+] Updating docker image"
     cd $MOODLE_DOCKER_PATH
     git pull
  else
    echo "[+] Cloning Docker Image"
    git clone https://github.com/moodlehq/moodle-docker
  fi

  echo "[+] Moodle configuration"
  cp $MOODLE_DOCKER_PATH/config.docker-template.php $MOODLE_DOCKER_WWWROOT/config.php
  echo "[+] Start Deveploment environment"
  cd $MOODLE_DOCKER_PATH && bin/moodle-docker-compose up -d && bin/moodle-docker-wait-for-db

  echo "[+] Installing Moodle (it takes a while... grab a coffee)"
  $MOODLE_DOCKER_PATH/bin/moodle-docker-compose exec webserver php admin/cli/install_database.php \
      --agree-license \
      --fullname="$MOODLE_PLATFORM_FULLNAME" \
      --shortname="$MOODLE_PLATFORM_SHORTNAME" \
      --summary="$MOODLE_PLATFORM_SUMMARY" \
      --adminpass="$MOODLE_PLATFORM_ADMIN_PASS" \
      --adminemail="$MOODLE_PLATFORM_ADMIN_EMAIL"

  echo "[+] All done - You can open your browser to http://localhost:8000/"
}

start(){
  echo "[+] Starting Development Environment"
  $MOODLE_DOCKER_PATH/bin/moodle-docker-compose start
}

stop(){
  echo "[+] Stopping Development Environment"
  $MOODLE_DOCKER_PATH/bin/moodle-docker-compose stop
}

delete(){
  echo "[+] Deleting Development Environment"
  $MOODLE_DOCKER_PATH/bin/moodle-docker-compose down
}

reset(){
  echo "[+] Reset Development Environment: remove docker images & moodle files"
  delete
  rm -rf $MOODLE_DOCKER_PATH && rm -rf $MOODLE_DOCKER_WWWROOT
}

dump(){
  echo "[+] Dump database"
  if [[ ! -e $DATABASE_BACKUP_DIR ]]; then
      mkdir $DATABASE_BACKUP_DIR
  fi
  docker exec -t moodle-docker-db-1 pg_dumpall -c -U moodle > $DATABASE_BACKUP_DIR/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
  echo "[+] Dump database created in $DATABASE_BACKUP_DIR"
}


if [[ $# -eq 0 ]] ; then
    help
else
  	case "$1" in

  	--setup) setup ;;
  	--start) start ;;
  	--stop) stop ;;
  	--delete) delete ;;
  	--reset) reset ;;
    --dump) dump ;;
  	--help) help ;;

  	*) echo -e "[-] Command $1 not recognized\n" && help ;;

  	esac
fi

