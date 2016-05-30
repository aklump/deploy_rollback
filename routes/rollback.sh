#!/usr/bin/env bash
cd $rb_drupal_root

# Read in the hash
if ! test -e "$rb_data_dir/hash_rollback.txt"; then
  lobster_failed "Rollback has is missing from $rb_data_dir/hash_rollback.txt"
else
  hash=$(cat $rb_data_dir/hash_rollback.txt)
fi

if ! lobster_confirm "Rollback to $hash?"; then
  lobster_failed
fi

# Logging this activity
lobster_log deploy "Rolling back the $rb_site_role environment to ($hash)." rollback

$LOBSTER_APP offline -f --lobster-nowrap

# Rollback the db
lobster_success "Restoring the database..."
$rb_loft_deploy import $hash -f

# Rollback GIT
$rb_git checkout $hash
