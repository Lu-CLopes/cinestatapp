part of 'example.dart';

class ReadSingleMovieVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  ReadSingleMovieVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ReadSingleMovieData> dataDeserializer = (dynamic json)  => ReadSingleMovieData.fromJson(jsonDecode(json));
  Serializer<ReadSingleMovieVariables> varsSerializer = (ReadSingleMovieVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ReadSingleMovieData, ReadSingleMovieVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ReadSingleMovieData, ReadSingleMovieVariables> ref() {
    ReadSingleMovieVariables vars= ReadSingleMovieVariables(id: id,);
    return _dataConnect.query("readSingleMovie", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ReadSingleMovieMovie {
  final String id;
  final String movieTitle;
  final String? movieGenre;
  final String? movieAgeClass;
  final int? movieDuration;
  final String? movieDistrib;
  final String? movieFormat;
  final String? movieDirector;
  final bool? movieActive;
  ReadSingleMovieMovie.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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

    final ReadSingleMovieMovie otherTyped = other as ReadSingleMovieMovie;
    return id == otherTyped.id && 
    movieTitle == otherTyped.movieTitle && 
    movieGenre == otherTyped.movieGenre && 
    movieAgeClass == otherTyped.movieAgeClass && 
    movieDuration == otherTyped.movieDuration && 
    movieDistrib == otherTyped.movieDistrib && 
    movieFormat == otherTyped.movieFormat && 
    movieDirector == otherTyped.movieDirector && 
    movieActive == otherTyped.movieActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, movieTitle.hashCode, movieGenre.hashCode, movieAgeClass.hashCode, movieDuration.hashCode, movieDistrib.hashCode, movieFormat.hashCode, movieDirector.hashCode, movieActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
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

  ReadSingleMovieMovie({
    required this.id,
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
class ReadSingleMovieData {
  final ReadSingleMovieMovie? movie;
  ReadSingleMovieData.fromJson(dynamic json):
  
  movie = json['movie'] == null ? null : ReadSingleMovieMovie.fromJson(json['movie']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadSingleMovieData otherTyped = other as ReadSingleMovieData;
    return movie == otherTyped.movie;
    
  }
  @override
  int get hashCode => movie.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (movie != null) {
      json['movie'] = movie!.toJson();
    }
    return json;
  }

  ReadSingleMovieData({
    this.movie,
  });
}

@immutable
class ReadSingleMovieVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ReadSingleMovieVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadSingleMovieVariables otherTyped = other as ReadSingleMovieVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ReadSingleMovieVariables({
    required this.id,
  });
}

