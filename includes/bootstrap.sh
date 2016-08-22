#!/usr/bin/env bash
rb_version="0.1.40"

# If we're not initialized then make note.
if [ ! "$LOBSTER_INSTANCE_ROOT" ]; then
  rb_installed=false
  if [ "$lobster_op" != 'init' ]; then
    lobster_error "Missing configuration file: $lobster_app_config; do you want to run 'deploy init'?"
  fi
else
  rb_installed=true
  rb_data_dir=$LOBSTER_INSTANCE_ROOT/.rollback
  rb_db_dir=$(cd $rb_loft_deploy_root && $rb_loft_deploy get local_db_dir)
fi

# Determine the major version of Drupal
RB_DRUPAL_ROOT=$rb_drupal_root
export RB_DRUPAL_ROOT
rb_drupal_version=$(cd $rb_drupal_root && lobster_include 'drupal_get_version')
rb_drupal_major_version=${rb_drupal_version%%.*}
