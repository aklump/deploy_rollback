#!/usr/bin/env bash
rb_op=${lobster_get_args_return[0]}
rb_data_dir=$LOBSTER_PWD_ROOT/.rollback
rb_drupal_root=$LOBSTER_PWD_ROOT/web
rb_db_dir=$($rb_loft_deploy get local_db_dir)
