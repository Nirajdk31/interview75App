class Movie {
  final int imdbId;
  final String title;
  final String year;
  final String photo;

  Movie({required this.imdbId, required this.title, required this.year, required this.photo});

  factory Movie.fromJson(Map<String, dynamic> json)=> Movie(
    imdbId: json["imdbID"],
    title: json["Title"],
    year: json["Year"],
    photo: json["Poster"],
  );
}
