# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ReadAllUsers
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.readAllUsers().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ReadAllUsersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.readAllUsers();
ReadAllUsersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.readAllUsers().ref();
ref.execute();

ref.subscribe(...);
```


### ReadSingleUser
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.readSingleUser(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ReadSingleUserData, ReadSingleUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.readSingleUser(
  id: id,
);
ReadSingleUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.readSingleUser(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ReadManagerUnits
#### Required Arguments
```dart
String managerId = ...;
ExampleConnector.instance.readManagerUnits(
  managerId: managerId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ReadManagerUnitsData, ReadManagerUnitsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.readManagerUnits(
  managerId: managerId,
);
ReadManagerUnitsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String managerId = ...;

final ref = ExampleConnector.instance.readManagerUnits(
  managerId: managerId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ReadAllMovies
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.readAllMovies().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ReadAllMoviesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.readAllMovies();
ReadAllMoviesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.readAllMovies().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
DateTime userCreatedAt = ...;
String userName = ...;
String userEmail = ...;
ExampleConnector.instance.createUser(
  userCreatedAt: userCreatedAt,
  userName: userName,
  userEmail: userEmail,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUser(
  userCreatedAt: userCreatedAt,
  userName: userName,
  userEmail: userEmail,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
DateTime userCreatedAt = ...;
String userName = ...;
String userEmail = ...;

final ref = ExampleConnector.instance.createUser(
  userCreatedAt: userCreatedAt,
  userName: userName,
  userEmail: userEmail,
).ref();
ref.execute();
```


### CreateUnit
#### Required Arguments
```dart
String unitName = ...;
String unitLocal = ...;
int unitMacCapacity = ...;
String unitManagerId = ...;
bool unitActive = ...;
ExampleConnector.instance.createUnit(
  unitName: unitName,
  unitLocal: unitLocal,
  unitMacCapacity: unitMacCapacity,
  unitManagerId: unitManagerId,
  unitActive: unitActive,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateUnitData, CreateUnitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUnit(
  unitName: unitName,
  unitLocal: unitLocal,
  unitMacCapacity: unitMacCapacity,
  unitManagerId: unitManagerId,
  unitActive: unitActive,
);
CreateUnitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String unitName = ...;
String unitLocal = ...;
int unitMacCapacity = ...;
String unitManagerId = ...;
bool unitActive = ...;

final ref = ExampleConnector.instance.createUnit(
  unitName: unitName,
  unitLocal: unitLocal,
  unitMacCapacity: unitMacCapacity,
  unitManagerId: unitManagerId,
  unitActive: unitActive,
).ref();
ref.execute();
```


### CreateMovie
#### Required Arguments
```dart
String movieTitle = ...;
String movieGenre = ...;
String movieAgeClass = ...;
int movieDuration = ...;
String movieDistrib = ...;
String movieFormat = ...;
String movieDirector = ...;
bool movieActive = ...;
ExampleConnector.instance.createMovie(
  movieTitle: movieTitle,
  movieGenre: movieGenre,
  movieAgeClass: movieAgeClass,
  movieDuration: movieDuration,
  movieDistrib: movieDistrib,
  movieFormat: movieFormat,
  movieDirector: movieDirector,
  movieActive: movieActive,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateMovieData, CreateMovieVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createMovie(
  movieTitle: movieTitle,
  movieGenre: movieGenre,
  movieAgeClass: movieAgeClass,
  movieDuration: movieDuration,
  movieDistrib: movieDistrib,
  movieFormat: movieFormat,
  movieDirector: movieDirector,
  movieActive: movieActive,
);
CreateMovieData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String movieTitle = ...;
String movieGenre = ...;
String movieAgeClass = ...;
int movieDuration = ...;
String movieDistrib = ...;
String movieFormat = ...;
String movieDirector = ...;
bool movieActive = ...;

final ref = ExampleConnector.instance.createMovie(
  movieTitle: movieTitle,
  movieGenre: movieGenre,
  movieAgeClass: movieAgeClass,
  movieDuration: movieDuration,
  movieDistrib: movieDistrib,
  movieFormat: movieFormat,
  movieDirector: movieDirector,
  movieActive: movieActive,
).ref();
ref.execute();
```


### CreateAudience
#### Required Arguments
```dart
String audienceUnitId = ...;
int audienceAge = ...;
String audienceGender = ...;
String audienceFormat = ...;
ExampleConnector.instance.createAudience(
  audienceUnitId: audienceUnitId,
  audienceAge: audienceAge,
  audienceGender: audienceGender,
  audienceFormat: audienceFormat,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateAudienceData, CreateAudienceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createAudience(
  audienceUnitId: audienceUnitId,
  audienceAge: audienceAge,
  audienceGender: audienceGender,
  audienceFormat: audienceFormat,
);
CreateAudienceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String audienceUnitId = ...;
int audienceAge = ...;
String audienceGender = ...;
String audienceFormat = ...;

final ref = ExampleConnector.instance.createAudience(
  audienceUnitId: audienceUnitId,
  audienceAge: audienceAge,
  audienceGender: audienceGender,
  audienceFormat: audienceFormat,
).ref();
ref.execute();
```

