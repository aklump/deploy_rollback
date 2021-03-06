#!/bin/bash
# 
# @file
# 
# This file will get called if lobster_debug == 1 at the time the function
# lobster_show_debug() is called.

lobster_color 'yellow'
lobster_echo "DEBUG INFO" "This will only be called if you set lobster_debug=1 in the config file"

lobster_color 'green'
lobster_echo "\$lobster_app_title:" "$lobster_app_title" " "
lobster_echo "\$lobster_app_name:" "$lobster_app_name" " "
lobster_echo "\$LOBSTER_PWD:" "$LOBSTER_PWD" " "
lobster_echo "\$LOBSTER_INSTANCE_ROOT:" "$LOBSTER_INSTANCE_ROOT" " "
lobster_echo "\$LOBSTER_APP:" "$LOBSTER_APP" " "
lobster_echo "\$LOBSTER_APP_ROOT:" "$LOBSTER_APP_ROOT" " "
lobster_echo "\$LOBSTER_ROOT:" "$LOBSTER_ROOT" " "
lobster_echo "\$lobster_app_config:" "$lobster_app_config" " "
lobster_echo "\$lobster_php:" "$lobster_php" " "
lobster_echo "\$lobster_op:" "$lobster_op" " "
lobster_echo "\$lobster_route:" "$lobster_route" " "
lobster_echo "\$lobster_args:" $lobster_args " "
lobster_echo "\$lobster_params:" $lobster_params " "
lobster_echo "\$lobster_flags:" $lobster_flags " "
lobster_echo "\$lobster_debug:" $lobster_debug " "
lobster_echo "\$lobster_logs:" $lobster_logs " "
lobster_echo "\$LOBSTER_JSON:" "$LOBSTER_JSON" " "

lobster_echo "APP VARS"
lobster_echo "\$rb_drush:" "$rb_drush" " "
lobster_echo "\$rb_loft_deploy:" "$rb_loft_deploy" " "
lobster_echo "\$rb_git:" "$rb_git" " "
lobster_echo "\$rb_git_root:" "$rb_git_root" " "
lobster_echo "\$rb_drupal_root:" "$rb_drupal_root" " "
lobster_echo "\$rb_op:" "$rb_op" " "
