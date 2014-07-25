use strict;
use warnings;
use DBI;
require "./MoviesCast.pl";

package Movies;

sub new
{
  my $class = shift;
  my $self = {
      ID => shift,
      Title  => shift,
      Year => shift,
      IDDirector => shift,
      IDGenre => shift
  };
  bless $self, $class;
  return $self;
}

package DAOMovies;

sub New { bless {}, shift };

my $dsn = 'DBI:ODBC:Driver={SQL Server}'; 
my $host = 'TSVETI-PC\SQLEXPRESS'; 
my $database = 'MovieCollector'; 
my $user = 'MovieCollectorService'; 
my $password = 'P@ssw0rd'; 

sub GetMovies{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";

  my $sql = "SELECT Movies.ID, Title, Year, Genres.Name as Genre, Directors.Name as Director 
             FROM Genres RIGHT JOIN Movies ON Genres.ID = IDGenre LEFT JOIN  Directors ON IDDirector = Directors.ID"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute(); 
 
  my ($id, $title, $year, $genre, $director); 
 
  $sth->bind_columns( undef, \$id, \$title, \$year, \$genre, \$director); 
  $sth->{'LongTruncOk'} = 1;
  
  my @result = ();
  while($sth->fetch()){
    my $movieCast = DAOMoviesCast->New;
    my $cast = $movieCast->GetMovieCast($id);
    push(@result, $title);
    push(@result, $year);
    push(@result, $genre);
    push(@result, $director);
    push(@result, $cast);
  }
  
  $sth->finish(); 
  $dbh->disconnect();

  return @result;
}

sub GetMoviesSearch{
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $text = shift;
  $text = '%'.$text.'%';
  my $sql = "SELECT Movies.ID, Title, Year, Genres.Name as Genre, Directors.Name as Director 
             FROM Genres RIGHT JOIN Movies ON Genres.ID = IDGenre LEFT JOIN  Directors ON IDDirector = Directors.ID 
             WHERE Title LIKE ? OR Year LIKE ? OR Genres.Name LIKE ? OR Directors.Name like ? OR Movies.ID in 
            (SELECT Movies.ID 
             FROM Movies INNER JOIN MoviesCast ON Movies.ID = IDMovie INNER JOIN MovieStars ON IDMovieStar = MovieStars.ID 
             WHERE MovieStars.Name LIKE ?)"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($text, $text, $text, $text, $text); 
 
  my ($id, $title, $year, $genre, $director); 
 
  $sth->bind_columns( undef, \$id, \$title, \$year, \$genre, \$director); 
  $sth->{'LongTruncOk'} = 1;
  
  my @result = ();
  while($sth->fetch()){
    my $movieCast = DAOMoviesCast->New;
    my $cast = $movieCast->GetMovieCast($id);
    push(@result, $title);
    push(@result, $year);
    push(@result, $genre);
    push(@result, $director);
    push(@result, $cast);
  }
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return @result;
}

sub GetMovie{
my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $title = shift;
  my $year = shift;
  my $sql = "SELECT ID FROM Movies WHERE Title = CAST(? AS nvarchar(max)) AND Year = ? "; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($title, $year); 
 
  my ($id); 
 
  $sth->bind_columns( undef, \$id);
  
  my $result;
  while($sth->fetch()){
    $result = $id;
  }
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return $result;
}

sub AddMovie{  
  my $dbh = DBI->connect("$dsn;Server=$host;Database=$database", $user, $password, { RaiseError => 1, AutoCommit => 1}) 
  || die "Database connection not made: $DBI::errstr";
  
  my $first = shift;
  my $title = shift;
  my $year = shift;
  my $idDirector = shift;
  my $idGenre = shift;
  my $sql = "INSERT INTO Movies (Title, Year, IDGenre, IDDirector) VALUES (?, ?, ?, ?)"; 
  my $sth = $dbh->prepare( $sql ); 

  $sth->execute($title, $year, $idGenre, $idDirector); 
  
  my $id = GetMovie("", $title, $year);
  
  $sth->finish(); 
  $dbh->disconnect();
  
  return $id;
}