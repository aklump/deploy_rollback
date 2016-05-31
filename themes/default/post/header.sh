#!/bin/bash
lobster_echo
lobster_color blue
lobster_echo "Deploy Rollback version $rb_version"
lobster_echo "- Environment: $rb_site_role"
lobster_echo "- Drupal root: $rb_drupal_root"
lobster_echo "- Logs dir: $lobster_logs"
lobster_echo "- DB dir: $rb_db_dir"
lobster_echo
lobster_color $lobster_color_default
