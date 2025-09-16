#!/usr/bin/perl -w

# This script will search a directory for .tiff image files 
#and setup command line input prompt plantcv pipeline

# plantcv_cmd_prompt_from_dir.pl

# November 9 2021
# Kevin Propst 

use strict;
use Getopt::Long;



# sample run: plantcv_cmd_prompt_from_dir.pl  --in_dir <directory_with_input_files>  --output <file_cmd_prompt> --help <help on usage of script>
my $usage = "\nUsage: $0 --in_dir <directory with input files> --output <file_cmd_prompt> --help <help on usage of script>\n\n";

my ($in_dir, $output, $help);

Getopt::Long::GetOptions('in_dir=s' => \$in_dir,
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

traverse($path);
open(my $output_fh, '>', $output) or die "Can't open $output";

foreach my $files (@files_to_read) {
    print "$files\n";
    print $output_fh "python3.8 /Users/propst/Desktop/project_folder/cropping_image.py --image $files  --outdir /Users/propst/Documents/h7_resize\n";
}






sub traverse {
    my ($thing) = @_;
    
    if ($thing =~ /\.tiff/) {
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