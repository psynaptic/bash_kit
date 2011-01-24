#!/usr/bin/env bash

# TODO:
# - Add error checking for parameters
# - Add command specific usage/help text
# - Move constant variables to the top
# - Add options (flags) e.g. -f to force command without prompting user

audio=0
verbose=0
while getopts "av" option; do
  case $option in
    a )
      audio="1";
      ;;
    v )
      verbose="1";
      ;;
  esac
done
shift $(($OPTIND - 1))

mode=$1
database=$2
destination=`pwd`
date=`date +%d%m%Y%H%M%S`

mysql_auth="-u $DB_USER"
if [ -n "${DB_PASS}" ]; then
  mysql_auth="$mysql_auth -p$DB_PASS"
fi

# first we check to see if mysql is not running
if ! ps ax | grep -v grep | grep mysqld > /dev/null
  then # some error status was returned
    echo "MySQL server is not running."
    exit
fi

##
# Checks for and reports on exit codes.
#
# $1 = exit code to parse
# $2 = message
function check_error {
  if [ "${1}" -ne "0" ]; then
    if [ $verbose -eq "1" ]; then
      echo "${2} failed"
    fi
    if [ $audio -eq "1" ]; then
      say -vVictoria "${2} failed"
    fi
  else
    if [ $verbose -eq "1" ]; then
      echo "${2} sucessful"
    fi
    if [ $audio -eq "1" ]; then
      say -vVictoria "${2} successful"
    fi
  fi
}

function sql_drop {
  $MYSQL $mysql_auth $MYSQL_OPTIONS -e "DROP DATABASE IF EXISTS $1";
}

function sql_show {
  $MYSQL $mysql_auth $MYSQL_OPTIONS -e "SHOW DATABASES";
}

function sql_execute {
  # We have to pass the database name, otherwise a command like "SELECT nid FROM node;" would fail.
  $MYSQL $mysql_auth $MYSQL_OPTIONS -D $1 -e "$2"
}

function sql_check {
  SCHEMA=`$MYSQL $mysql_auth $MYSQL_OPTIONS -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$1'"`;
  if [ -z "$SCHEMA" ]; then
    return 1;
  else
    return 0;
  fi
}

function sql_create {
  $MYSQLADMIN $mysql_auth $MYSQL_OPTIONS create $database
  check_error $? "Create $database"
}

function sql_clone_table {
  source=$2
  target=$3
  echo "Cloning table $source to $target...";
  $MYSQL $mysql_auth $MYSQL_OPTIONS -D $1 -e "CREATE TABLE $target LIKE $source";
  $MYSQL $mysql_auth $MYSQL_OPTIONS -D $1 -e "INSERT INTO $target SELECT * FROM $source";
}

case $mode in

  check)
    sql_check $database;
  ;;

  drop)
    if [ $# -lt 2 ]; then
      echo "No database name given";
      exit 2;
    fi

    sql_drop $database;
  ;;

  show)
    sql_show;
  ;;

  use)
    $MYSQL $mysql_auth $MYSQL_OPTIONS $database
  ;;

  execute)
    # Argument must be in "" otherwise it is treated separately in sql_execute
    sql_execute $database "$3"
  ;;

  create)
    sql_create $database
  ;;

  recreate)
    sql_drop $database
    sql_create $database
  ;;

  clone-table)
    sql_clone_table $database "$3" "$4"
  ;;

dump)
if [ $# -lt 2 ] || [ $# -gt 3 ] # if other than 2 or 3 arguments were given
  then # display error message and exit

    if [ $# -lt 2 ]
      then
      echo "No database name given"
      exit
    elif [ $# -gt 3 ]
      then
      echo "Too many parameters"
      exit
    fi

else # 2 or 3 arguments were passed...

  if [ -e $destination ] # check destination exists
    then

      # filter mode of operation
      if [ $# -eq 2 ] # 2 arguments passed (dump database)
        then
          sql=$destination/$database-$date.sql
          read -p "Dump $database database to $destination?" # prompt user
          $MYSQLDUMP $MYSQLDUMP_OPTIONS $mysql_auth $MYSQL_OPTIONS $database > $sql # dump database
          check_error $? "Dump $database to $sql"
          exit
      elif [ $# -eq 3 ] # 3 arguments passed (dump table)
        then
          table=$3
          sql=$destination/$table-$date.sql
          read -p "Dump $table table to $destination?" # prompt user
          $MYSQLDUMP $MYSQLDUMP_OPTIONS $mysql_auth $MYSQL_OPTIONS $database $table > $sql # dump table
          check_error $? "Dump $table to $sql"
          exit
      fi

  else # detination doesn't exists
    echo "$destination does not exist"
  fi
  exit
fi
;;


import)

sql_drop $database
sql_create $database

file=$3
# If the file ends with .gz it is probably a gzipped dump.
if [[ ${file: -3} == ".gz" ]]
then
  gunzip $file | $MYSQL $mysql_auth $database
else
  $MYSQL $mysql_auth $MYSQL_OPTIONS $database < "$file"
fi

check_error $? "Import $database"
exit
;;


*)
  if [ $# -eq 0 ]
    then # if no parameters are passed default to login
      $MYSQL $mysql_auth

    else # if no option was recognised show usage information
      echo "usage: sql command [database] [table]"
      echo "examples:"
      echo "  sql                       - login to mysql"
      echo "  sql show                  - show databases"
      echo "  sql use database          - login and use database"
      echo "  sql dump database         - dump database"
      echo "  sql dump database table   - dump a table from database"
      echo "  sql import database       - import database"
      echo "  sql import database table - import table to database"
      echo "  sql create database       - create database"
      echo "  sql recreate database     - drop and create a database"
      echo "  sql drop database         - drop database"
      echo "  sql execute <database> <command> - execute an sql query on the database"
      echo "  sql clone-table <database> <source> <target> - clone source database table to target"
  fi
;;


esac


# JUNK:
# Check if a database by the same name exists and if not, create it.
# $BASH_KIT_DIR/bin/sql.sh show|grep ^$database$ >/dev/null
# if [[ $? -eq 1 ]]; then
#   $BASH_KIT_DIR/bin/sql.sh create $database
# fi
