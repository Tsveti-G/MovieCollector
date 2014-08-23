use strict;
use warnings;
use diagnostics;
use Tk; 
use Tk::Help;
use Tk::Table;
require "./Movies.pl";
require "./Genres.pl";
require "./Directors.pl";
require "./MovieStars.pl";
require "./MoviesCast.pl";

our ($f2, @movie, $listBoxGenres, $daoGenres, $title, $year, $director, $movieStar, $text, @search);
our $root = new MainWindow(-title=> "Movie Collector");
my $f1=$root->Frame(-background => "red");
$f1->pack(-expand => 1,-fill => 'both',-side=>'bottom');
my $buttonAdd = $root->Button(-text =>"Add Movie",-command=>sub{AddMovie()});
$buttonAdd->pack(-fill=>'x');
my $buttonShow = $root->Button(-text =>"Show Movies",-command=>sub{ShowMovies()});
$buttonShow->pack(-fill=>'x');
my $buttonSearch = $root->Button(-text =>"Search",-command=>sub{Search()});
$buttonSearch->pack(-fill=>'x');
my $menu = $root->Menu();
$root->configure(-menu=>$menu);
$root->bind('<Key-F1>', sub {ShowHelp();});

my $fileMenu = $menu->cascade(-label=>"File", -underline=>0, -tearoff => 0);
my $helpMenu = $menu->cascade(-label =>"Help", -underline=>0, -tearoff => 0);

$fileMenu->command(-label => "Add Movie", -command => sub{AddMovie()}, -underline => 0);
$fileMenu->command(-label => "Show Movies", -command => sub{ShowMovies()}, -underline => 0);
$fileMenu->command(-label => "Search", -command => sub{Search()}, -underline => 0);
$fileMenu->separator();
$fileMenu->command(-label => "Exit", -command => sub{Exiting()}, -underline => 3);
$helpMenu->command(-label => "Help", -command => sub{ShowHelp()}, -underline => 0);
MainLoop;

sub AddMovie{
  @movie = ();
  if($f1) {
    $f1->destroy();
    $f1=undef;
  }
  if($f2){
    $f2->destroy();
    $f2=undef;
  }
  $f1 = $root->Frame(-background => "red");
  $f1->pack(-expand => 1,-fill => 'both');
  $f2 = $root->Frame(-background=> "green");
  $f2->pack(-expand => 1,-fill => 'both',-side=>'top');
  $title="Title";
  my $entry1 = $f2->Entry(-textvariable => \$title, -justify=> 'left', -width =>25);
  $entry1->pack(-fill => 'both',-side=>'top');
  push(@movie, \$title);
  $year="Year";
  my $entry2 = $f2->Entry(-textvariable => \$year, -justify=> 'left', -width =>25);
  $entry2->pack(-fill => 'both',-side=>'top');
  push(@movie, \$year);
  $director="Director";
  my $entry3 = $f2->Entry(-textvariable => \$director, -justify=> 'left', -width =>25);
  $entry3->pack(-fill => 'both',-side=>'top');
  push(@movie, \$director);
  
  $listBoxGenres = $f2->Listbox(-selectmode => "single", -height => 18)->pack;
  $daoGenres = DAOGenres->New;
  my @genres = $daoGenres->GetGenres();
  $listBoxGenres->insert('end', @genres);
  
  $movieStar="Movie Star";
  my $entry4 = $f2->Entry(-textvariable => \$movieStar, -justify=> 'left', -width =>25);
  $entry4->pack(-fill => 'both',-side=>'top');
  push(@movie, \$movieStar);
  
  my $save = $f2-> Button(-text=> "Save Movie", -command =>sub {SaveMovie();});
  $save->pack(-side=>'bottom',-padx=>0, -pady=>10);
  my $more = $f2-> Button(-text=> "More Movie Stars", -command =>sub {MoreEntries();});
  $more->pack(-side=>'bottom',-padx=>0, -pady=>10);
}
sub ShowMovies{
  if($f1) {$f1->destroy();
    $f1=undef;
  }
  if($f2){
    $f2->destroy();
    $f2=undef;
  }
  $f1 = $root->Frame(-background => "red");
  $f1->pack(-expand => 1,-fill => 'both');
  
  my $DAOMovies = DAOMovies->New;
  my @movies = $DAOMovies->GetMovies();
  
  my $rows = ($#movies + 1) / 5;
  my $tableMovies = $f1->Table(-rows => $rows + 1, -columns => 5, -takefocus => 1);
  $tableMovies->put(0, 0, "Title");
  $tableMovies->put(0, 1, "Year");
  $tableMovies->put(0, 2, "Genre");
  $tableMovies->put(0, 3, "Director");
  $tableMovies->put(0, 4, "Cast");
  for (my $i=1; $i<=$rows; $i++){
    for (my $j=0; $j<5; $j++){
      $tableMovies->put($i, $j, shift(@movies));
    }
  }
  $tableMovies-> pack(-side=>'bottom',-padx=>0, -pady=>0);
}
sub Search{
  if($f1) {$f1->destroy();
    $f1=undef;
  }
  if($f2){
    $f2->destroy();
    $f2=undef;
  }
  $f1 = $root->Frame(-background => "red");
  $f1->pack(-expand => 1,-fill => 'both');
  $f2 = $root->Frame(-background=> "green");
  $f2->pack(-expand => 1,-fill => 'both',-side=>'top');
  $text="Search";
  my $entry1 = $f2->Entry(-textvariable => \$text, -justify=> 'left', -width =>25);
  $entry1->pack(-fill => 'both',-side=>'top');
  push(@search, \$text);
  
  my $buttonSearch = $f2-> Button(-text=> "Search", -command =>sub {SearchMovies();});
  $buttonSearch->pack(-side=>'bottom',-padx=>0, -pady=>10);
}
sub Exiting{
  exit(0);
}
sub ShowHelp{
  my @helparray = ([{-title => "Movie Collector Help", -header => "Movie Collector Help", -text => "Choose the option you would like to learn about."}],
                   [{-title => "Add Movie", -header => "Add Movie", -text => "Form for adding new movies."},
                    {-title => "Title", -header => "Title", -text => "Enter Movie Title here."},
                    {-title => "Year", -header => "Year", -text => "Enter Year of release here."},
                    {-title => "Director", -header => "Director", -text => "Enter Movie Director's name here."},
                    {-title => "Listbox Genre", -header => "Genre", -text => "Select Movie's Genre from here."},
                    {-title => "Movie Star", -header => "Movie Star", -text => "Enter Movie Star's name here."},
                    {-title => "Button More Movie Stars", -header => "More Movie Stars", -text => "Creates another entry for Movie Star's name."},
                    {-title => "Button Save Movie", -header => "Save Movie", -text => "Saves the entered movie."}],
                   [{-title => "Show Movies", -header => "Show Movies", -text => "Shows all the movies you entered."}],
                   [{-title => "Search", -header => "Search", -text => "Search throught your movies."},
                    {-title => "Text", -header => "Search", -text => "Enter text you would like the result set of movies contain."},
                    {-title => "Button Search", -header => "Search", -text => "Shows all movies maching the entered text."}]);
  my $help = $root->Help(-title    => "My Application - Help", -variable => \@helparray);
}
sub MoreEntries{
  my $variable = "Movie Star";
  my $entry = $f2->Entry(-textvariable =>\$variable);
  $entry ->pack(-fill => 'both');
  push(@movie, \$variable);
}
sub SaveMovie{
  my @selected = $listBoxGenres->curselection;
  if($#selected < 0){
    $f2 -> messageBox(-message=>"Please, Select Genre.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  my $idGenre;
  foreach (@selected) {
    my $index = shift @selected;
    my @name = $listBoxGenres->get($index);
    $idGenre = $daoGenres->GetGenre(shift @name);
  }
  if(!$title){
    $f2 -> messageBox(-message=>"Please, Enter Title.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  if(!$year){
    $f2 -> messageBox(-message=>"Please, Enter Year.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  if (!($year =~ /^(\d+)$/))
  {
    $f2 -> messageBox(-message=>"Please, Enter correct Year.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  if(!$director){
    $f2 -> messageBox(-message=>"Please, Enter Director.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  if(!$movieStar){
    $f2 -> messageBox(-message=>"Please, Enter Movie Star.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  @movie = map {$$_} @movie;
  my $movieTitle = shift @movie;
  my $yearOfRelease = shift @movie;
  my $daoMovies = DAOMovies->New;
  if ($daoMovies->GetMovie($movieTitle, $yearOfRelease)){
    $f2 -> messageBox(-message=>"This movie is already in database. Please, enter another one.", -type=>'ok',-icon=>'warning');
    $f2->destroy();
    $f2=undef;
  }
  my $daoDirectors = DAODirectors->New;
  my $idDirector = $daoDirectors->GetDirector(shift @movie);
  
  my $idMovie = $daoMovies->AddMovie($title, $year, $idDirector, $idGenre);
  
  my $movieStarName;
  my $daoMoviesCast = DAOMoviesCast->New;
  while($movieStarName = shift (@movie)){
    my $daoMovieStars = DAOMovieStars->New;
    my $idMovieStar = $daoMovieStars->GetMovieStar($movieStarName);
    $daoMoviesCast->AddMovieCast($idMovie, $idMovieStar);
  }
  
  $f2 -> messageBox(-message=>"The movie was added.\n",-type=>'ok',-icon=>'warning');
  $f2->destroy();
  $f2=undef;
}
sub SearchMovies{
  if(!$text){
    $f2 -> messageBox(-message=>"Please, Enter Text to search for.\n",-type=>'ok',-icon=>'warning');
    return;
  }
  @search = map {$$_} @search;
  
  my $daoMovies = DAOMovies->New;
  my @movies = $daoMovies->GetMoviesSearch(shift (@search));
  
  $f2->destroy();
  $f2=undef;
  
  my $rows = ($#movies + 1) / 5;
  my $tableMovies = $f1->Table(-rows => $rows + 1, -columns => 5, -takefocus => 1);
  $tableMovies->put(0, 0, "Title");
  $tableMovies->put(0, 1, "Year");
  $tableMovies->put(0, 2, "Genre");
  $tableMovies->put(0, 3, "Director");
  $tableMovies->put(0, 4, "Cast");
  for (my $i=1; $i<=$rows; $i++){
    for (my $j=0; $j<5; $j++){
      $tableMovies->put($i, $j, shift(@movies));
    }
  }
  $tableMovies-> pack(-side=>'bottom',-padx=>0, -pady=>0);
}
