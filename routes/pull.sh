#!/usr/bin/env bash
#
# Route to pull down and deploy
#
cd $rb_drupal_root

# Fail if there are any local modifications
if [ -n "$(cd $rb_git_root && $rb_git status --untracked-files=no --porcelain)" ]; then
  (cd $rb_git_root && $rb_git status --untracked-files=no --porcelain)
  lobster_log deploy "Deployed to the $rb_site_role environment failed due to local changes." pull_fail
  lobster_failed "Changes to the $rb_site_role environment preclude automated deployment. You should make changes on another server and commit them and clean up this server before trying again."
fi

hash=$(cd $rb_git_root && $rb_git rev-parse HEAD)

# Logging this activity
lobster_log deploy "Deployed to the $rb_site_role environment ($hash)." pull

lobster_notice "Storing the current hash for later rollback, if needed..."
lobster_notice $hash
echo $hash > $rb_data_dir/hash_rollback.txt

# Take drupal offline.
lobster_color_echo yellow "Insuring site is offline..."
force=''
if lobster_has_flag "f"; then
  force='-f'
fi
$LOBSTER_APP offline --lobster-nowrap $force

lobster_success "Merging in codebase from origin..."
if ! (cd $rb_git_root && $rb_git $rb_git_merge_command); then
  lobster_error "The Git merge failed."
  $LOBSTER_APP online --lobster-nowrap
  lobster_failed
fi

lobster_success "Backing up the database..."
$rb_loft_deploy export $hash -f

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

if lobster_confirm "Did it fail? Do you wish to rollback" && lobster_confirm "ROLLBACK, are you sure?"; then
  $LOBSTER_APP rollback -f --lobster-nowrap
elif lobster_confirm "Ready to bring the site back online?"; then
  $LOBSTER_APP online -f --lobster-nowrap
else
  lobster_warning "When you're ready you may bring the site back online using 'deploy online'"
fi
