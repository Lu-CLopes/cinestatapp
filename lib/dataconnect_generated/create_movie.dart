part of 'example.dart';

class CreateMovieVariablesBuilder {
  String movieTitle;
  String movieGenre;
  String movieAgeClass;
  int movieDuration;
  String movieDistrib;
  String movieFormat;
  String movieDirector;
  bool movieActive;

  final FirebaseDataConnect _dataConnect;
  CreateMovieVariablesBuilder(this._dataConnect, {required  this.movieTitle,required  this.movieGenre,required  this.movieAgeClass,required  this.movieDuration,required  this.movieDistrib,required  this.movieFormat,required  this.movieDirector,required  this.movieActive,});
  Deserializer<CreateMovieData> dataDeserializer = (dynamic json)  => CreateMovieData.fromJson(jsonDecode(json));
  Serializer<CreateMovieVariables> varsSerializer = (CreateMovieVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateMovieData, CreateMovieVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateMovieData, CreateMovieVariables> ref() {
    CreateMovieVariables vars= CreateMovieVariables(movieTitle: movieTitle,movieGenre: movieGenre,movieAgeClass: movieAgeClass,movieDuration: movieDuration,movieDistrib: movieDistrib,movieFormat: movieFormat,movieDirector: movieDirector,movieActive: movieActive,);
    return _dataConnect.mutation("CreateMovie", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateMovieMovieInsert {
  final String id;
  CreateMovieMovieInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMovieMovieInsert otherTyped = other as CreateMovieMovieInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateMovieMovieInsert({
    required this.id,
  });
}

@immutable
class CreateMovieData {
  final CreateMovieMovieInsert movie_insert;
  CreateMovieData.fromJson(dynamic json):
  
  movie_insert = CreateMovieMovieInsert.fromJson(json['movie_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMovieData otherTyped = other as CreateMovieData;
    return movie_insert == otherTyped.movie_insert;
    
  }
  @override
  int get hashCode => movie_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movie_insert'] = movie_insert.toJson();
    return json;
  }

  CreateMovieData({
    required this.movie_insert,
  });
}

@immutable
class CreateMovieVariables {
  final String movieTitle;
  final String movieGenre;
  final String movieAgeClass;
  final int movieDuration;
  final String movieDistrib;
  final String movieFormat;
  final String movieDirector;
  final bool movieActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateMovieVariables.fromJson(Map<String, dynamic> json):
  
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

    final CreateMovieVariables otherTyped = other as CreateMovieVariables;
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
    json['movieGenre'] = nativeToJson<String>(movieGenre);
    json['movieAgeClass'] = nativeToJson<String>(movieAgeClass);
    json['movieDuration'] = nativeToJson<int>(movieDuration);
    json['movieDistrib'] = nativeToJson<String>(movieDistrib);
    json['movieFormat'] = nativeToJson<String>(movieFormat);
    json['movieDirector'] = nativeToJson<String>(movieDirector);
    json['movieActive'] = nativeToJson<bool>(movieActive);
    return json;
  }

  CreateMovieVariables({
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

