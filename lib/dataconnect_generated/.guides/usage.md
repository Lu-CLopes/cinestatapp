# Basic Usage

```dart
ExampleConnector.instance.CreateUser(createUserVariables).execute();
ExampleConnector.instance.CreateUnit(createUnitVariables).execute();
ExampleConnector.instance.updateUnit(updateUnitVariables).execute();
ExampleConnector.instance.DeleteUnit(deleteUnitVariables).execute();
ExampleConnector.instance.CreateMovie(createMovieVariables).execute();
ExampleConnector.instance.UpdateMovie(updateMovieVariables).execute();
ExampleConnector.instance.DeleteMovie(deleteMovieVariables).execute();
ExampleConnector.instance.CreateAudience(createAudienceVariables).execute();
ExampleConnector.instance.createProduct(createProductVariables).execute();
ExampleConnector.instance.CreateSession(createSessionVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ExampleConnector.instance.CreateSale({ ... })
.saleNetValue(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

