# Deploy Rollback

## Dependencies
1. Git
1. Drush <http://www.drush.org/en/master>
1. Loft Deploy <https://github.com/aklump/loft_deploy>

## Installing
1. Download this package to `/opt/deploy_rollback` or as recommended by your sysadmin.
1. Create a symlink in `/usr/local/bin/deploy` that points to `/opt/deploy_rollback/deploy_rollback.sh`.
1. Navigate to the folder where you wish to use this script, one level above your drupal root and type `deploy init`.
1. Modify `.rollbackconfig` as necessary.
1. Type `deploy help` for more info.
1. Check the status by using `deploy status`.
