#!/usr/bin/env bash
#
# Take drupal online and echo a response
#

lobster_notice "Checking Drupal status..."
changed=false
if ! is_drupal_online; then
  changed=true
  (cd $rb_drupal_root && $rb_drush vset site_offline 0)
fi

if ! is_drupal_online; then
  lobster_failed "Unable to bring site online."
elif [ "$changed" = true ]; then
  lobster_log deploy "Site brought online." online
fi

lobster_success "Site is online."

