use strict;
use warnings;
use DBI;

package Genres;

sub new
{
  my $class = shift;
  my $self = {
      ID => shift,
      Name  => shift
  };
  bless $self, $class;
  return $self;
}

package DAOGenres;

sub New { bless {}, shift };

my $dsn = 'DBI:ODBC:Driver={SQL Server}'; 
my $host = 'TSVETI-PC\SQLEXPRESS'; 
my $database = 'MovieCollector'; 
my $user = 'MovieCollectorService'; 
my $password = 'P@ssw0rd'; 

sub GetGenre{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $name = shift;
  my $sql = "SELECT ID FROM Genres WHERE Name = CAST(? AS nvarchar(max))"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($name); 
 
  my ($id); 
 
  $sth->bind_columns( undef, \$id); 
  
  $sth->fetch();
  my $result = $id;
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return $result;
}

sub GetGenres{
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";

  my $sql = "SELECT Name FROM Genres ORDER BY Name"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute(); 
 
  my ($name); 
 
  $sth->bind_columns( undef, \$name); 
  
  my @result = ();
  while($sth->fetch()){
    push(@result, $name);
  }
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return @result;
}