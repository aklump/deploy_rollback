#!/bin/bash
#
# @file
# Pre-route is automatically called every time example_app.sh is executed, after bootstrap and before the route is executed.  The route is availailable as $lobster_route
rb_op=${lobster_suggestions[0]}

# The init op should not run the checks below
if [ "$rb_op" == "init" ] || [ "$rb_op" == "help" ]; then
  return
fi

# Verify dependencies
if [ ! "$rb_git" ] ; then
   lobster_failed "Git must be installed on system; see \$rb_git  in $LOBSTER_APP_ROOT/$lobster_app_config"
fi

# Verify drupal root is defined.
if [ ! "$rb_drupal_root" ]; then
  lobster_failed "You must configure \$rb_drupal_root first in $LOBSTER_APP_ROOT/$lobster_app_config"
fi

# Verify drupal root exists.
if [ ! -d "$rb_drupal_root" ] || ! (cd "$rb_drupal_root" && is_drupal_root); then
  lobster_failed "$rb_drupal_root does not exist or does not appear to be a Drupal project."
fi

# Make sure we have the rollback directory
[ ! -d "$rb_data_dir" ] || mkdir -p "$rb_data_dir"


