#!/usr/bin/env bash
#
# Take drupal online and echo a response
#
lobster_notice "Checking Drupal status..."
changed=false
if ! is_drupal_online; then
  changed=false
  if drupal_set_maintenance 0; then
    changed=true
  fi
fi

if ! is_drupal_online; then
  lobster_failed "Unable to bring site online."
elif [ "$changed" = true ]; then
  lobster_log deploy "Site brought online." online
fi

lobster_success "Site is online."

