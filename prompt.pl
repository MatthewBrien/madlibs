#!usr/local/bin/perl
use strict;
#use warnings;

print("Hello Madlibs\n");
my $date = time();
#uncomment next line for unique names otherwise, use the line after next
#my $output_file = "madlib$date.txt";
my $output_file = "mad.txt";

unless(open OUTPUT, ">$output_file") {
        print( "\nUnable to create '$output_file'\n");
        return 0;

    }

  #idea, have a header value at the top, that flags if a madlib is complete or not
  #idea two, never save over the original file, always write to a new one.
  #TODO allow user to pass a template file to the program
my $file = 'madtemplate.txt';
unless (open MADLIB, "<$file"){
  close OUTPUT;
  print("Unable to open file, are you sure you are in the correct directory?\n");
  print("The file may have changed names.\n Make sure your madlib file is called madlib.txt\n");
  return 0;
}
my $line;
my $temp;
my @match;
my $i =0;
#for each line of the template, create an array of the regular expression matches
 while(!eof(MADLIB)) {

   $line = <MADLIB>;
    @match = ($line =~ /([_]+[A-Za-z\ \-]+[_]+)/g);

    foreach (@match)
    {
        #prompt user- then replace in line, and print line to new_file
        #for each match, pop, and lock, I mean pop and replace
        print "Please enter a $_:";
        $temp = <STDIN>;
        $temp =~ s/\n//g;
        $line =~ s/$_/$temp/g; #swap array element and entered
        $i++;

    }
    print OUTPUT $line;

    }
print "MAdlib complete! $i words replaced \n";

#TODO don't save until completion

  close MADLIB;
  close OUTPUT;
