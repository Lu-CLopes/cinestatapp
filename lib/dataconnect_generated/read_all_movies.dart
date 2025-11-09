part of 'example.dart';

class ReadAllMoviesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ReadAllMoviesVariablesBuilder(this._dataConnect, );
  Deserializer<ReadAllMoviesData> dataDeserializer = (dynamic json)  => ReadAllMoviesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ReadAllMoviesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ReadAllMoviesData, void> ref() {
    
    return _dataConnect.query("ReadAllMovies", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ReadAllMoviesMovies {
  final String movieTitle;
  final String? movieGenre;
  final String? movieAgeClass;
  final int? movieDuration;
  final String? movieDistrib;
  final String? movieFormat;
  final String? movieDirector;
  final bool? movieActive;
  ReadAllMoviesMovies.fromJson(dynamic json):
  
  movieTitle = nativeFromJson<String>(json['movieTitle']),
  movieGenre = json['movieGenre'] == null ? null : nativeFromJson<String>(json['movieGenre']),
  movieAgeClass = json['movieAgeClass'] == null ? null : nativeFromJson<String>(json['movieAgeClass']),
  movieDuration = json['movieDuration'] == null ? null : nativeFromJson<int>(json['movieDuration']),
  movieDistrib = json['movieDistrib'] == null ? null : nativeFromJson<String>(json['movieDistrib']),
  movieFormat = json['movieFormat'] == null ? null : nativeFromJson<String>(json['movieFormat']),
  movieDirector = json['movieDirector'] == null ? null : nativeFromJson<String>(json['movieDirector']),
  movieActive = json['movieActive'] == null ? null : nativeFromJson<bool>(json['movieActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllMoviesMovies otherTyped = other as ReadAllMoviesMovies;
    return movieTitle == otherTyped.movieTitle && 
    movieGenre == otherTyped.movieGenre && 
    movieAgeClass == otherTyped.movieAgeClass && 
    movieDuration == otherTyped.movieDuration && 
    movieDistrib == otherTyped.movieDistrib && 
    movieFormat == otherTyped.movieFormat && 
    movieDirector == otherTyped.movieDirector && 
    movieActive == otherTyped.movieActive;
    
  }
  @override
  int get hashCode => Object.hashAll([movieTitle.hashCode, movieGenre.hashCode, movieAgeClass.hashCode, movieDuration.hashCode, movieDistrib.hashCode, movieFormat.hashCode, movieDirector.hashCode, movieActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movieTitle'] = nativeToJson<String>(movieTitle);
    if (movieGenre != null) {
      json['movieGenre'] = nativeToJson<String?>(movieGenre);
    }
    if (movieAgeClass != null) {
      json['movieAgeClass'] = nativeToJson<String?>(movieAgeClass);
    }
    if (movieDuration != null) {
      json['movieDuration'] = nativeToJson<int?>(movieDuration);
    }
    if (movieDistrib != null) {
      json['movieDistrib'] = nativeToJson<String?>(movieDistrib);
    }
    if (movieFormat != null) {
      json['movieFormat'] = nativeToJson<String?>(movieFormat);
    }
    if (movieDirector != null) {
      json['movieDirector'] = nativeToJson<String?>(movieDirector);
    }
    if (movieActive != null) {
      json['movieActive'] = nativeToJson<bool?>(movieActive);
    }
    return json;
  }

  ReadAllMoviesMovies({
    required this.movieTitle,
    this.movieGenre,
    this.movieAgeClass,
    this.movieDuration,
    this.movieDistrib,
    this.movieFormat,
    this.movieDirector,
    this.movieActive,
  });
}

@immutable
class ReadAllMoviesData {
  final List<ReadAllMoviesMovies> movies;
  ReadAllMoviesData.fromJson(dynamic json):
  
  movies = (json['movies'] as List<dynamic>)
        .map((e) => ReadAllMoviesMovies.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllMoviesData otherTyped = other as ReadAllMoviesData;
    return movies == otherTyped.movies;
    
  }
  @override
  int get hashCode => movies.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movies'] = movies.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAllMoviesData({
    required this.movies,
  });
}

