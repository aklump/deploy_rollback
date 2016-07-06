#!/usr/bin/env bash
#
# Take drupal offline and echo a response
#
lobster_notice "Checking Drupal status..."
changed=false
if is_drupal_online && (lobster_has_flag f || lobster_confirm "Are you sure you want to take the site offline?"); then
  changed=false
  if drupal_set_maintenance 1; then
    changed=true
  fi
fi

if is_drupal_online; then
  lobster_failed "Unable to take site offline."
elif [ "$changed" = true ]; then
  lobster_log deploy "Site taken offline." offline
fi

lobster_success "Site is offline."

