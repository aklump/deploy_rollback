<?php
/**
 * @file
 * Update the version string in a shell script: script.sh
 *
 */
$filename = $argv[7] . '/includes/bootstrap.sh';

if ($contents = $before = file_get_contents($filename)) {

  // Do a regex replace of the version declaration in code.
  $contents = preg_replace('/^rb_version=["\d\.]+/m', 'rb_version="' . $argv[2] . '"', $contents);
  $changed = $contents !== $before;
  if ($changed && file_put_contents($filename, $contents)) {
    echo "Version string updated to " . $argv[2] . " in " . basename($filename);
    return;
  }
}

if ($changed) {
  echo "Error updated version string in $filename.";
}
