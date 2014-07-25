use strict;
use warnings;
use DBI;

package MoviesCast;

sub new
{
  my $class = shift;
  my $self = {
      ID => shift,
      IDMovie  => shift,
      IDMovieStar => shift,
  };
  bless $self, $class;
  return $self;
}

package DAOMoviesCast;

sub New { bless {}, shift };

my $dsn = 'DBI:ODBC:Driver={SQL Server}'; 
my $host = 'TSVETI-PC\SQLEXPRESS'; 
my $database = 'MovieCollector'; 
my $user = 'MovieCollectorService'; 
my $password = 'P@ssw0rd'; 

sub GetMovieCast{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $idMovie = shift;
  my $sql = "SELECT MovieStars.Name FROM MoviesCast LEFT JOIN MovieStars ON IDMovieStar = MovieStars.ID WHERE IDMovie = ?"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($idMovie); 
 
  my ($movieStar); 
 
  $sth->bind_columns( undef, \$movieStar); 
  
  my $movieCast = "";
  while($sth->fetch()){
    $movieCast = "${movieCast}${movieStar}".", ";
  }
  chop($movieCast);
  chop($movieCast);
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return $movieCast;
}

sub AddMovieCast{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $idMovie = shift;
  my $idMovieStar = shift;
  my $sql = "INSERT INTO MoviesCast (IDMovie, IDMovieStar) VALUES (?, ?)"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($idMovie, $idMovieStar); 
 
  $sth->finish(); 
  $dbh->disconnect();
}