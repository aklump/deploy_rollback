#!/bin/bash
if [ "$rb_initalized" == true ] && ! is_drupal_online; then
  lobster_echo
  lobster_warning "THE WEBSITE IS CURRENTLY OFFLINE"
fi
lobster_color "grey"

