part of 'example.dart';

class UpdateMovieVariablesBuilder {
  String movieId;
  String movieTitle;
  String movieGenre;
  String movieAgeClass;
  int movieDuration;
  String movieDistrib;
  String movieFormat;
  String movieDirector;
  bool movieActive;

  final FirebaseDataConnect _dataConnect;
  UpdateMovieVariablesBuilder(this._dataConnect, {required  this.movieId,required  this.movieTitle,required  this.movieGenre,required  this.movieAgeClass,required  this.movieDuration,required  this.movieDistrib,required  this.movieFormat,required  this.movieDirector,required  this.movieActive,});
  Deserializer<UpdateMovieData> dataDeserializer = (dynamic json)  => UpdateMovieData.fromJson(jsonDecode(json));
  Serializer<UpdateMovieVariables> varsSerializer = (UpdateMovieVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMovieData, UpdateMovieVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateMovieData, UpdateMovieVariables> ref() {
    UpdateMovieVariables vars= UpdateMovieVariables(movieId: movieId,movieTitle: movieTitle,movieGenre: movieGenre,movieAgeClass: movieAgeClass,movieDuration: movieDuration,movieDistrib: movieDistrib,movieFormat: movieFormat,movieDirector: movieDirector,movieActive: movieActive,);
    return _dataConnect.mutation("UpdateMovie", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateMovieMovieUpdate {
  final String id;
  UpdateMovieMovieUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMovieMovieUpdate otherTyped = other as UpdateMovieMovieUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateMovieMovieUpdate({
    required this.id,
  });
}

@immutable
class UpdateMovieData {
  final UpdateMovieMovieUpdate? movie_update;
  UpdateMovieData.fromJson(dynamic json):
  
  movie_update = json['movie_update'] == null ? null : UpdateMovieMovieUpdate.fromJson(json['movie_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMovieData otherTyped = other as UpdateMovieData;
    return movie_update == otherTyped.movie_update;
    
  }
  @override
  int get hashCode => movie_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (movie_update != null) {
      json['movie_update'] = movie_update!.toJson();
    }
    return json;
  }

  UpdateMovieData({
    this.movie_update,
  });
}

@immutable
class UpdateMovieVariables {
  final String movieId;
  final String movieTitle;
  final String movieGenre;
  final String movieAgeClass;
  final int movieDuration;
  final String movieDistrib;
  final String movieFormat;
  final String movieDirector;
  final bool movieActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateMovieVariables.fromJson(Map<String, dynamic> json):
  
  movieId = nativeFromJson<String>(json['movieId']),
  movieTitle = nativeFromJson<String>(json['movieTitle']),
  movieGenre = nativeFromJson<String>(json['movieGenre']),
  movieAgeClass = nativeFromJson<String>(json['movieAgeClass']),
  movieDuration = nativeFromJson<int>(json['movieDuration']),
  movieDistrib = nativeFromJson<String>(json['movieDistrib']),
  movieFormat = nativeFromJson<String>(json['movieFormat']),
  movieDirector = nativeFromJson<String>(json['movieDirector']),
  movieActive = nativeFromJson<bool>(json['movieActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMovieVariables otherTyped = other as UpdateMovieVariables;
    return movieId == otherTyped.movieId && 
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
  int get hashCode => Object.hashAll([movieId.hashCode, movieTitle.hashCode, movieGenre.hashCode, movieAgeClass.hashCode, movieDuration.hashCode, movieDistrib.hashCode, movieFormat.hashCode, movieDirector.hashCode, movieActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movieId'] = nativeToJson<String>(movieId);
    json['movieTitle'] = nativeToJson<String>(movieTitle);
    json['movieGenre'] = nativeToJson<String>(movieGenre);
    json['movieAgeClass'] = nativeToJson<String>(movieAgeClass);
    json['movieDuration'] = nativeToJson<int>(movieDuration);
    json['movieDistrib'] = nativeToJson<String>(movieDistrib);
    json['movieFormat'] = nativeToJson<String>(movieFormat);
    json['movieDirector'] = nativeToJson<String>(movieDirector);
    json['movieActive'] = nativeToJson<bool>(movieActive);
    return json;
  }

  UpdateMovieVariables({
    required this.movieId,
    required this.movieTitle,
    required this.movieGenre,
    required this.movieAgeClass,
    required this.movieDuration,
    required this.movieDistrib,
    required this.movieFormat,
    required this.movieDirector,
    required this.movieActive,
  });
}

