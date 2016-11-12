#!usr/local/bin/perl
use strict;
use warnings;
print("Hello Madlibs\n\n");
my $date = time();

#list current templates available
opendir DIR, '.' or die "cannot open current directory: $!";
my @localFiles= readdir DIR;
closedir DIR;
my @templates;

#find all Madlib Templates in current directory
foreach(@localFiles){
  if($_ =~ /^.+Madlib_Template.txt$/){ #match any file that ends with Madlib.txt
    push @templates, $_;
    }
}
if(@templates){
  print "The following Madlibs are available?\n";
  my $i = 1;
  foreach(@templates){
    print "$i: $_ \n";
    $i++;
  }
}
else{
  print "Im sorry to say, but it doesn't look like you have any Madlib files";
  exit;
}
print "Which Madlib would you like to do? Enter the number or file name\n";
my $selection = -1;
my $file;
while(1){
  $selection = <STDIN>;
  if(int $selection <= scalar @templates  &&  int $selection > 0){
    $file = $templates[int $selection - 1];
    last;
  }
}
#build name of output file
my $filename = substr $file , 0, index($file, "_Madlib_Template.txt");
print  "$filename\n";

my $output_file = "$filename$date.txt";

  #idea, have a header value at the top, that flags if a madlib is complete or not
  #idea two, never save over the original file, always write to a new one.
  #TODO allow user to pass a template file to the program

unless (open MADLIB, "<$file"){
  close OUTPUT;
  print("Unable to open file, are you sure you are in the correct directory?\n");
  print("The file may have changed names.\n Make sure your madlib file is called _Madlib_Template.txt\n");
  return 0;
}
my $line;
my $temp;
my @match;
my $i = 0;
my @CompleteMadlib;
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
      push @CompleteMadlib, $line;
    }
    close MADLIB; #close the template file

print "Madlib complete! $i words replaced \n";

  foreach(@CompleteMadlib){
    print $_;
  }

print "\n Would you like to save? Y/N \n";

if(<STDIN> =~ /[Yy]/ ){
    unless(open OUTPUT, ">$output_file") {
          print( "\nCould not save '$output_file'\n");
          return 0;
      }
    foreach(@CompleteMadlib){
      print OUTPUT $_;
    }
    close OUTPUT;
}
