#!/usr/bin/env bash
cd $rb_drupal_root

hash=$($rb_git rev-parse HEAD)

# Logging this activity
lobster_log deploy "Deployed to the $rb_site_role environment ($hash)." pull

lobster_notice "Storing the current hash for later rollback, if needed..."
lobster_notice $hash
echo $hash > $rb_data_dir/hash_rollback.txt

lobster_color_echo yellow "Insuring site is offline..."
$LOBSTER_APP offline --lobster-nowrap

lobster_success "Backing up the database..."
$rb_loft_deploy export $hash -f

lobster_success "Merging in codebase from origin..."
$rb_git pull

# Update the database unless we have the param to not do so.
if ! lobster_has_param 'noupdb'; then
  lobster_color_echo yellow "Running Drupal database updates, if any..."
  $rb_drush updb
else
  lobster_color_echo yellow 'Skipping database updates per --noupdb'
fi

# Clear all caches unless we have the parameter to not do so.
if ! lobster_has_param 'nocc'; then
  lobster_color_echo yellow "Clearing Drupal's cache..."
  $rb_drush cc all
else
  lobster_color_echo yellow 'Skipping drupal cache clearing per --nocc'
fi

# Now ask for confirmation to put it back into regular mode
lobster_color pink
lobster_theme go_test

if lobster_confirm "Did it fail? Do you wish to rollback" && lobster_confirm "Are you certain you want to rollback to an earlier state?"; then
  $LOBSTER_APP rollback -f --lobster-nowrap
elif lobster_confirm "Ready to switch out of maintenance mode?"; then
  $LOBSTER_APP online -f --lobster-nowrap
else
  lobster_warning "When you're ready you may bring the site back online using 'deploy online'"
fi
