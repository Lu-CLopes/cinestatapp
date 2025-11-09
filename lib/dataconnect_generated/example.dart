library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'create_unit.dart';

part 'create_movie.dart';

part 'create_audience.dart';

part 'read_all_users.dart';

part 'read_single_user.dart';

part 'read_manager_units.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser ({required DateTime userCreatedAt, required String userName, required String userEmail, }) {
    return CreateUserVariablesBuilder(dataConnect, userCreatedAt: userCreatedAt,userName: userName,userEmail: userEmail,);
  }
  
  
  CreateUnitVariablesBuilder createUnit ({required String unitName, required String unitLocal, required int unitMacCapacity, required String unitManagerId, required bool unitActive, }) {
    return CreateUnitVariablesBuilder(dataConnect, unitName: unitName,unitLocal: unitLocal,unitMacCapacity: unitMacCapacity,unitManagerId: unitManagerId,unitActive: unitActive,);
  }
  
  
  CreateMovieVariablesBuilder createMovie ({required String movieTitle, required String movieGenre, required String movieAgeClass, required int movieDuration, required String movieDistrib, required String movieFormat, required String movieDirector, required bool movieActive, }) {
    return CreateMovieVariablesBuilder(dataConnect, movieTitle: movieTitle,movieGenre: movieGenre,movieAgeClass: movieAgeClass,movieDuration: movieDuration,movieDistrib: movieDistrib,movieFormat: movieFormat,movieDirector: movieDirector,movieActive: movieActive,);
  }
  
  
  CreateAudienceVariablesBuilder createAudience ({required String audienceUnitId, required int audienceAge, required String audienceGender, required String audienceFormat, }) {
    return CreateAudienceVariablesBuilder(dataConnect, audienceUnitId: audienceUnitId,audienceAge: audienceAge,audienceGender: audienceGender,audienceFormat: audienceFormat,);
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

