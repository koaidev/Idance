import 'package:oxoo/models/content_by_country_model.dart';
import 'package:oxoo/models/movie_model.dart';
import 'package:oxoo/server/repository.dart';
import 'package:scoped_model/scoped_model.dart';

class MovieViewModel extends Model {
  List<MovieModel>? moviesByGenre = [];
  List<MovieModel>? moviesByCountry = [];

  static final MovieViewModel _movieViewModel = new MovieViewModel._internal();

  factory MovieViewModel() {
    return _movieViewModel;
  }

  MovieViewModel._internal();

  void getMoviesByGenreId(String genreID) async {
    moviesByGenre = await getMovieByGenreId(genreID);
  }

  void getMoviesByCountry(String countryId) async {
    await getMovieByCountry(countryId)
        .then((value) => moviesByCountry = value.movieList.cast<MovieModel>());
  }

  Future<List<MovieModel>?> getMovieByGenreId(String genreID) async {
    return await Repository().getMovieByGenereID("1", genreID);
  }

  Future<ContentByCountryModel> getMovieByCountry(String countryId) async {
    return await Repository().contentByCountry(countryID: countryId);
  }
}
