#!/bin/bash
if [ "$rb_site_role" ]; then
  lobster_echo
  lobster_color blue
  lobster_echo "You are on the '$rb_site_role' server"
  lobster_echo
  lobster_color $lobster_color_default
fi
