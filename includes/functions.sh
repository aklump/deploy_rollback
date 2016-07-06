#!/bin/bash
# 
# @file
# Provide functions to be used by example_app.  This file is
# auto-loaded every time example_app.sh is called, but after
# functions at the core level of Lobster.

#
# Determine if the cwp is a drupal project root.
#
function is_drupal_root () {
  if [ -d sites ] && [ -d modules ] && [ -d themes ]; then
    return 0
  fi
  return 1
}

#
# Determine if drupal is online or not.
#
function is_drupal_online() {
  case $rb_drupal_major_version in
  6)
    status='vget site_offline --exact'
    ;;
  7)
    status='vget maintenance_mode --exact'
    ;;
  8)
    status='state-get system.maintenance_mode --format=string'
    ;;
  esac

  status=$(cd $rb_drush_root && $rb_drush $status)
  regex="true|1"
  if [[ "$status" =~ $regex ]]; then
    return 1;
  fi
  return 0;
}

#
# Set the maintenance mode to 1 or 0 by argument
#
function drupal_set_maintenance() {
 case $rb_drupal_major_version in
  6)
    command="vset site_offline $1"
    ;;
  7)
    command="vset maintenance_mode $1"
    ;;
  8)
    command="state-set system.maintenance_mode $1"
    ;;
  esac

  return $(cd $rb_drush_root && $rb_drush $command)
}

function may_rollback() {
  if test -e "$rb_data_dir/hash_rollback.txt"; then
    return 0
  fi
  return 1;
}
