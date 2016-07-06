<?php
/**
 * @file Prints the major version of drupal.
 *
 * Assumes CWD is the root of the drupal installation.
 */
require_once getenv('LOBSTER_ROOT') . '/bootstrap.php';
$drop = new AKlump\LoftLib\Drupal\DrupalBridge(getenv('RB_DRUPAL_ROOT'));
print $drop->getVersion();
