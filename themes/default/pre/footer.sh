#!/bin/bash
lobster_color "grey"
if [ "$rb_op" != "status" ] && [ "$rb_installed" = true ] && ! is_drupal_online; then
  lobster_echo
  lobster_warning "THE WEBSITE IS CURRENTLY OFFLINE"
fi

lobster_echo
lobster_echo "Deploy Rollback version $rb_version ($rb_site_role)"
