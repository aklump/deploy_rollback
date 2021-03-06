#!/usr/bin/env bash
#
# Return the status of the deployment
#
lobster_color blue
lobster_echo "- Environment: $rb_site_title ($rb_site_role)"
lobster_echo "- Logs dir: $lobster_logs"
lobster_echo "- DB dir: $rb_db_dir"
lobster_echo "- Drupal root: $rb_drupal_root"
lobster_echo "- Drupal version: $rb_drupal_version"
lobster_echo "- Git: $rb_git"
lobster_echo "- Git root: $rb_git_root"
lobster_echo "- Drush: $rb_drush"
lobster_echo "- Drush root: $rb_drush_root"
lobster_echo "- Loft Deploy: $rb_loft_deploy"
lobster_echo "- Loft Deploy root: $rb_loft_deploy_root"
lobster_echo

lobster_echo "Checking Git status for '$rb_site_title'..."
(cd $rb_git_root && $rb_git fetch)
(cd $rb_git_root && $rb_git status)

lobster_echo
lobster_echo "Checking Website status for '$rb_site_title'..."
if is_drupal_online; then
  lobster_success "Website is online"
else
  lobster_warning "Website is offline"
fi

lobster_echo
lobster_echo 'Checking rollback status...'
if may_rollback; then
  lobster_success "Rollback is possible"
else
  lobster_warning "Rollback is not possible"
fi
