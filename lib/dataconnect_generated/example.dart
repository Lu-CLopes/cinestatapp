library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'create_unit.dart';

part 'update_unit.dart';

part 'delete_unit.dart';

part 'create_movie.dart';

part 'update_movie.dart';

part 'delete_movie.dart';

part 'create_audience.dart';

part 'create_product.dart';

part 'read_all_users.dart';

part 'read_single_user.dart';

part 'read_manager_units.dart';

part 'read_all_movies.dart';

part 'read_single_movie.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser ({required DateTime userCreatedAt, required String userName, required String userEmail, }) {
    return CreateUserVariablesBuilder(dataConnect, userCreatedAt: userCreatedAt,userName: userName,userEmail: userEmail,);
  }
  
  
  CreateUnitVariablesBuilder createUnit ({required String unitName, required String unitLocal, required int unitMacCapacity, required String unitManagerId, required bool unitActive, }) {
    return CreateUnitVariablesBuilder(dataConnect, unitName: unitName,unitLocal: unitLocal,unitMacCapacity: unitMacCapacity,unitManagerId: unitManagerId,unitActive: unitActive,);
  }
  
  
  UpdateUnitVariablesBuilder updateUnit ({required String unitId, required String unitName, required String unitLocal, required int unitMacCapacity, required String unitManagerId, required bool unitActive, }) {
    return UpdateUnitVariablesBuilder(dataConnect, unitId: unitId,unitName: unitName,unitLocal: unitLocal,unitMacCapacity: unitMacCapacity,unitManagerId: unitManagerId,unitActive: unitActive,);
  }
  
  
  DeleteUnitVariablesBuilder deleteUnit ({required String unitId, }) {
    return DeleteUnitVariablesBuilder(dataConnect, unitId: unitId,);
  }
  
  
  CreateMovieVariablesBuilder createMovie ({required String movieTitle, required String movieGenre, required String movieAgeClass, required int movieDuration, required String movieDistrib, required String movieFormat, required String movieDirector, required bool movieActive, }) {
    return CreateMovieVariablesBuilder(dataConnect, movieTitle: movieTitle,movieGenre: movieGenre,movieAgeClass: movieAgeClass,movieDuration: movieDuration,movieDistrib: movieDistrib,movieFormat: movieFormat,movieDirector: movieDirector,movieActive: movieActive,);
  }
  
  
  UpdateMovieVariablesBuilder updateMovie ({required String movieId, required String movieTitle, required String movieGenre, required String movieAgeClass, required int movieDuration, required String movieDistrib, required String movieFormat, required String movieDirector, required bool movieActive, }) {
    return UpdateMovieVariablesBuilder(dataConnect, movieId: movieId,movieTitle: movieTitle,movieGenre: movieGenre,movieAgeClass: movieAgeClass,movieDuration: movieDuration,movieDistrib: movieDistrib,movieFormat: movieFormat,movieDirector: movieDirector,movieActive: movieActive,);
  }
  
  
  DeleteMovieVariablesBuilder deleteMovie ({required String movieId, }) {
    return DeleteMovieVariablesBuilder(dataConnect, movieId: movieId,);
  }
  
  
  CreateAudienceVariablesBuilder createAudience ({required String audienceUnitId, required int audienceAge, required String audienceGender, required String audienceFormat, }) {
    return CreateAudienceVariablesBuilder(dataConnect, audienceUnitId: audienceUnitId,audienceAge: audienceAge,audienceGender: audienceGender,audienceFormat: audienceFormat,);
  }
  
  
  CreateProductVariablesBuilder createProduct ({required String productName, required String productType, required double productPrice, required bool productActive, }) {
    return CreateProductVariablesBuilder(dataConnect, productName: productName,productType: productType,productPrice: productPrice,productActive: productActive,);
  }
  
  
  ReadAllUsersVariablesBuilder readAllUsers () {
    return ReadAllUsersVariablesBuilder(dataConnect, );
  }
  
  
  ReadSingleUserVariablesBuilder readSingleUser ({required String id, }) {
    return ReadSingleUserVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ReadManagerUnitsVariablesBuilder readManagerUnits ({required String managerId, }) {
    return ReadManagerUnitsVariablesBuilder(dataConnect, managerId: managerId,);
  }
  
  
  ReadAllMoviesVariablesBuilder readAllMovies () {
    return ReadAllMoviesVariablesBuilder(dataConnect, );
  }
  
  
  ReadSingleMovieVariablesBuilder readSingleMovie ({required String id, }) {
    return ReadSingleMovieVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'cinestat-384ba-service',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

