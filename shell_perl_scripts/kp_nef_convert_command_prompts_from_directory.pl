#!/usr/bin/perl -w

# This script will search a directory for .nef image files and
# set up the command line prompts to convert to compressed .tiff file
# will set up prompts for: dcraw, renaming, and tiffcp

# nef_convert_command_prompts_from_directory.pl

# March 29, 2021
# Cory Hirsch

use strict;
use Getopt::Long;

# sample run: --in_dir <directory_with_input_files>  --output <output file with commands> --help <help on usage of script>
my $usage = "\nUsage: $0 --in_dir <directory with input files> --output <output matrix file> --help <help on usage of script>\n\n";

my ($in_dir, $output, $help);

Getopt::Long::GetOptions(
'in_dir=s' => \$in_dir,
'output=s' => \$output,
'h|help' => \$help
);

if (defined($help)) {
      die $usage;
}
if (!defined($in_dir) || !defined($output) ) {
      die "\nAll file names must be provided\n$usage\n\n";
}
if (! (-d $in_dir) || -e $output) {
      die "\nThere is a problem with the parameters that were provided\n\n";
}

my $path = $in_dir;
my @files_to_read;

# Run subroutine to traverse directory path
# to obtain full path of only .tiff files
traverse($path);

# Open output file
open (my $output_fh, '>', $output) or die ("Can't open $output\n\n");

# Run through array of file names and print plantCV command to run
foreach my $files (@files_to_read) {
      print "$files\n";

      # dcraw command to convert nef to tiff put path to dcraw
      print $output_fh "/Users/propst/Documents/GitHub/Kevin/PlantCV/pipeline/dcraw -T -o 2 -w $files\n";
      # mv command to change output name
      my ($base, $ext) = split ('\.', $files);
      my $old = $base . '.' . 'tiff';
      my $new = $base . 'c' . '.' . 'tiff';
      print $output_fh "mv $old $new\n";
      # tiffcp command to compress tiff
      my $final = $base . '.' . 'tiff';
      print $output_fh "tiffcp -c lzw:2 $new $final\n";
}

# subroutine to traverse through and return a filepath for all .tiff files in a directory path
sub traverse {
      my ($thing) = @_;

      if ($thing =~ /\.nef/) {
            #print "$thing\n";
            push @files_to_read, $thing;
      }

      return if not -d $thing;
      opendir my $dh, $thing or die "\nNot sure but can't open $thing as directory\n\n";
      while (my $sub = readdir $dh) {
            next if $sub eq '.' or $sub eq '..';
            traverse("$thing/$sub");
      }
      close $dh;
      return;
}

exit;
