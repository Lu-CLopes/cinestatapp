library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';







class Cinestat384baConnector {
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'cinestat-384ba',
    'cinestat-384ba-service',
  );

  Cinestat384baConnector({required this.dataConnect});
  static Cinestat384baConnector get instance {
    return Cinestat384baConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

