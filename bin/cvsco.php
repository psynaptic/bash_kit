#!/usr/bin/env php
<?php

/**
 * Makes it easier to checkout modules from Drupal CVS.
 *
 * Usage:
 *   cvsco <project> <tag>
 * Example:
 *   cvsco drush HEAD
 *   cvsco cck DRUPAL-6--3
 */

$module = $argv[1];
$tag = $argv[2];
$cvs_tag_prefix = "DRUPAL-";

if ($argv < 2) {
  exit("usage: cvsco module_name cvs-tag");
}

if (strpos($tag, $cvs_tag_prefix) !== 0 && $tag != 'HEAD') {
  exit("Please use a correctly formatted CVS tag e.g. DRUPAL-6--1\n");
}

print "Checking out $module $tag\n";

$cmd = "cvs co -d $module -r $tag contributions/modules/$module";
exec($cmd . ' 2>&1', $output, $result);

foreach ($output as $line) {
  print_l($line);
}

function print_l($line, $indent = 0) {
  print (string) $line . "\n";
}
