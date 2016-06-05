#!/usr/bin/env bash
rb_version="0.1.20"

# If we're not initialized then make note.
if [ ! "$LOBSTER_PWD_ROOT" ]; then
  rb_installed=false
  if [ "$lobster_op" != 'init' ]; then
    lobster_error "Missing configuration file: $lobster_app_config; do you want to run 'deploy init'?"
  fi
else
  rb_installed=true
  rb_data_dir=$LOBSTER_PWD_ROOT/.rollback
  rb_db_dir=$($rb_loft_deploy get local_db_dir)
fi
