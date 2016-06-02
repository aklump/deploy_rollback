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

# Give use a preview and allow them to exit early.
color="green"
lobster_echo "You are about deploy new code changes:"
lobster_echo
if ! lobster_has_param "nooff" && ! lobster_has_param 'fast'; then
  lobster_color_echo $color "- The site will be taken offline"
else
  lobster_color_echo "yellow" "- The site will not be taken offline"
fi
lobster_color_echo $color "- Any new code from your remote will be merged in"
if ! lobster_has_param "nobu" && ! lobster_has_param 'fast'; then
  lobster_color_echo $color "- The database will be backed up"
else
  lobster_color_echo "yellow" "- The database will not be backed up"
fi
if ! lobster_has_param "noupdb" && ! lobster_has_param 'fast'; then
  lobster_color_echo $color "- The database update will run"
else
  lobster_color_echo "yellow" "- The database update will not run"
fi
if ! lobster_has_param "nocc" && ! lobster_has_param 'fast'; then
  lobster_color_echo $color "- The site caches will be cleared"
else
  lobster_color_echo "yellow" "- The site caches will not be cleared"
fi
if ! lobster_has_param "nooff" && ! lobster_has_param 'fast'; then
  lobster_color_echo $color "- The site will be brought back online"
fi

lobster_echo
if ! lobster_confirm "Is this what you want to do?"; then
  lobster_failed
fi

hash=$(cd $rb_git_root && $rb_git rev-parse HEAD)

# Logging this activity
lobster_log deploy "Deployed to the $rb_site_role environment ($hash)." pull

lobster_notice "Storing the current hash for later rollback, if needed..."
lobster_notice $hash
echo $hash > $rb_data_dir/hash_rollback.txt

# Take drupal offline.
if ! lobster_has_param "nooff" && ! lobster_has_param 'fast'; then
  lobster_color_echo yellow "Insuring site is offline..."
  $LOBSTER_APP offline --lobster-nowrap -f
fi

lobster_success "Merging in codebase from origin..."
if ! (cd $rb_git_root && $rb_git $rb_git_fetch_command && $rb_git $rb_git_merge_command); then
  lobster_error "The Git fetch/merge failed."
  if ! lobster_has_param "nooff"; then
    $LOBSTER_APP online --lobster-nowrap
  fi
  lobster_failed
fi

# Database backup
if ! lobster_has_param "nobu" && ! lobster_has_param 'fast'; then
  lobster_success "Backing up the database..."
  $rb_loft_deploy export $hash -f
fi

# Update the database unless we have the param to not do so.
if ! lobster_has_param 'noupdb' && ! lobster_has_param 'fast'; then
  lobster_color_echo yellow "Running Drupal database updates, if any..."
  $rb_drush updb
else
  lobster_color_echo yellow 'Skipping database updates per --noupdb'
fi

# Clear all caches unless we have the parameter to not do so.
if ! lobster_has_param 'nocc' && ! lobster_has_param 'fast'; then
  lobster_color_echo yellow "Clearing Drupal's cache..."
  $rb_drush cc all
else
  lobster_color_echo yellow 'Skipping drupal cache clearing per --nocc'
fi

# Now ask for confirmation to put it back into regular mode
lobster_echo
lobster_theme go_test
lobster_echo

if lobster_confirm "Did it fail? Do you wish to rollback" && lobster_confirm "ROLLBACK, are you sure?"; then
  $LOBSTER_APP rollback -f --lobster-nowrap
elif ! lobster_has_param "nooff" && ! lobster_has_param 'fast'; then
  if lobster_confirm "Ready to bring the site back online?"; then
    $LOBSTER_APP online -f --lobster-nowrap
  else
    lobster_warning "When you're ready you may bring the site back online using 'deploy online'"
  fi
fi
