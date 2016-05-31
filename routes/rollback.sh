#!/usr/bin/env bash
#
# Route to handle a rollback.
#

if ! may_rollback; then
  lobster_failed "Missing rollback entry; you need to do a 'pull' first.  This will be the case if you did not first do a 'pull' or if your did a 'clean'."
fi

cd $rb_drupal_root

# Read in the hash
hash=$(cat $rb_data_dir/hash_rollback.txt)

if ! lobster_has_flag "f" && ! lobster_confirm "Rollback to $hash?"; then
  lobster_failed
fi

# Logging this activity
lobster_log deploy "Rolling back the $rb_site_role environment to ($hash)." rollback

# Take the site offline.
$LOBSTER_APP offline -f --lobster-nowrap

# Rollback the db
lobster_success "Restoring the database..."
$rb_loft_deploy import $hash -f

# Rollback GIT
(cd $rb_git_root && $rb_git reset --hard $hash)

# Take the site online.
$LOBSTER_APP online -f --lobster-nowrap
