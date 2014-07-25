use strict;
use warnings;
use DBI;

package MovieStars;

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

package DAOMovieStars;

sub New { bless {}, shift };

my $dsn = 'DBI:ODBC:Driver={SQL Server}'; 
my $host = 'TSVETI-PC\SQLEXPRESS'; 
my $database = 'MovieCollector'; 
my $user = 'MovieCollectorService'; 
my $password = 'P@ssw0rd'; 

sub GetMovieStar{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $name = shift;
  my $sql = "SELECT ID FROM MovieStars WHERE Name = CAST(? AS nvarchar(max)) "; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($name); 
 
  my ($id); 
 
  $sth->bind_columns( undef, \$id); 
  
  my $result;
  while($sth->fetch()){
    $result = $id;
  }
  
  if (!$result){
    $result = AddMovieStar($name);
  }
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return $result;
}

sub AddMovieStar{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $name = shift;
  my $sql = "INSERT INTO MovieStars (Name) VALUES (?)"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($name); 
  
  my $id = GetMovieStar("", $name);
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return $id;
}