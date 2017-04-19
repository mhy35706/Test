#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use Text::CSV;

my $file = 'tabledata.csv';

open CSV, $file or die "Couldn't open file $file, $!\n";
my @csv_content = <CSV>;
close CSV;

my $dbname = "sql3169774";
my $dbhost = 'sql3.freemysqlhosting.net';
my $dbport = "3306";
my $dbuser = "sql3169774";
my $dbpass = "GdsGb54Lky";
my $table = "TableTest";

my $dsn = "DBI:mysql:database=$dbname;host=$dbhost;port=$dbport;";
my $dbh = DBI->connect($dsn, $dbuser, $dbpass) or or die "Couldn't connect to database: " . DBI->errstr;

my $sth;
my $statement;

my $field_line = shift(@csv_content);
chomp($field_line);

my @values;
my $status;
my $line;

my $csv = Text::CSV->new();
foreach(@csv_content){
   if ($csv->parse($_)){
     @values = $csv->fields();
      if ($status = $csv->combine(@values)){
         $line = $csv->string();

         $statement = "INSERT INTO $table ($field_line) VALUES ($line);";
         print $statement."\n";
         $sth = $dbh->prepare($statement) or die "Couldn't prepare statement: " . $dbh->errstr\n;
         $sth->execute() or die "Couldn't execute statement: " . $sth->errstr\n;

      }
      else {
          my $bad_arg1 = $csv->error_input ();
	  print "Failed to combine values\n";

      }
    }
	
   else {
        my $bad_arg2 = $csv->error_input ();
	print "Failed to Parse line\n";
    }

    if (not $cvs->eof){
	$csv->error_diag();
    }
}
