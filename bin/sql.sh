#!/bin/bash

# TODO:
# - Add error checking for parameters
# - Add command specific usage/help text
# - Move constant variables to the top
# - Add options (flags) e.g. -f to force command without prompting user

mode=$1
database=$2
db_user=$DB_USER
db_pass=$DB_PASS
options=$MYSQL_DUMP_OPTIONS

if [ "$db_pass" == "" ]
  then
    auth="-u $db_user"
  else
    auth="-u $db_user -p$db_pass"
fi

destination=`pwd`

# first we check to see if mysql is not running
if ! ps ax | grep -v grep | grep mysqld > /dev/null
  then # some error status was returned
    echo "MySQL server is not running."
    exit
fi

function check_error {
  # $1 = exit code to parse
  # $2 = message
  if [ "${1}" -ne "0" ]
    then
      echo "${2} failed"
      exit
    else
      echo "${2} was sucessful"
      exit
  fi
}

case $mode in

create)
if [ $# -lt 2 ]
  then
  echo "No database name given"
  else
  mysqladmin $auth create $database
  check_error $? "Create $database"
fi
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
          sql=$destination/$database.sql
          read -p "Dump $database database to $destination?" # prompt user
          mysqldump $dump_options $auth $database > $sql # dump database
          check_error $? "Dump $database to $sql"

      elif [ $# -eq 3 ] # 3 arguments passed (dump table)
        then
          table=$3
          sql=$destination/$table.sql
          read -p "Dump $table table to $destination?" # prompt user
          mysqldump $dump_options $auth $database $table > $sql # dump table
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

# Check if a database by the same name exists and if not, create it.
$BASH_KIT_DIR/bin/sql.sh show|grep ^$database$ >/dev/null
if [[ $? -eq 1 ]]; then
  $BASH_KIT_DIR/bin/sql.sh create $database
fi

file=$3
mysql $auth $database < $file # import table

check_error $? "Import $database"

;;


drop)
  if [ $# -lt 2 ]
    then
      echo "No database name given"
      exit
    else
      # check if the database exists
      mysql $auth -e "show databases" | grep $database >/dev/null
      if [ $? -eq 0 ]; then
        mysqladmin $auth drop $database
      else
        echo "Database $database does not exist"
      fi
  fi
;;


show)
  mysql $auth -e "show databases"
;;


use)
  mysql --auto-rehash $auth $database
;;


*)
  if [ $# -eq 0 ]
    then # if no parameters are passed default to login
      mysql $auth

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
      echo "  sql drop database         - drop database"
  fi
;;


esac
