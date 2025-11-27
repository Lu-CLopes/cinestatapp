import 'dart:developer';
import 'package:cinestatapp/dataconnect_generated/example.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Serviço para gerenciar comunicação com Firebase Data Connect
class DataConnectService {
  static final DataConnectService _instance = DataConnectService._internal();
  factory DataConnectService() => _instance;
  DataConnectService._internal();

  final ExampleConnector _connector = ExampleConnector.instance;

  /// Cria um usuário no backend após autenticação Firebase
  /// Retorna o ID do usuário criado ou null em caso de erro
  Future<String?> createUser({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    try {
      final result = await _connector
          .createUser(
            userCreatedAt: DateTime.now(),
            userName: userName,
            userEmail: userEmail,
          )
          .execute();

      log('Usuário criado no backend: ${result.data.user_insert.id}');
      return result.data.user_insert.id;
    } catch (e) {
      log('Erro ao criar usuário no backend: $e');
      return null;
    }
  }

  /// Busca dados de um usuário específico pelo ID
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final result = await _connector.readSingleUser(id: userId).execute();

      if (result.data.user != null) {
        final user = result.data.user!;
        return {
          'id': user.userId,
          'backendId': user.id,
          'name': user.userName,
          'email': user.userEmail,
          'createdAt': user.userCreatedAt,
        };
      }
      return null;
    } catch (e) {
      log('Erro ao buscar dados do usuário por ID ($userId): $e');
      // Se o ID não funcionar, retorna null (não tenta buscar por email aqui)
      return null;
    }
  }

  /// Busca dados de um usuário pelo email (fallback quando ID não funciona)
  Future<Map<String, dynamic>?> getUserDataByEmail(String email) async {
    try {
      final allUsers = await getAllUsers();

      // Busca o usuário com o email correspondente
      for (final user in allUsers) {
        if (user['email'] == email) {
          return user;
        }
      }

      return null;
    } catch (e) {
      log('Erro ao buscar usuário por email: $e');
      return null;
    }
  }

  /// Busca todos os usuários (útil para testes/debug)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final result = await _connector.readAllUsers().execute();

      return result.data.users
          .map(
            (user) => {
              'id': user.userId,
              'backendId': user.id,
              'name': user.userName,
              'email': user.userEmail,
              'createdAt': user.userCreatedAt,
            },
          )
          .toList();
    } catch (e) {
      log('Erro ao buscar todos os usuários: $e');
      return [];
    }
  }

  /// Sincroniza dados do usuário autenticado Firebase com o backend
  /// Cria o usuário no backend se ainda não existir
  Future<bool> syncUserWithBackend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log('Nenhum usuário autenticado');
      return false;
    }

    try {
      // Tenta buscar o usuário no backend pelo email (mais confiável)
      Map<String, dynamic>? userData;
      if (user.email != null) {
        userData = await getUserDataByEmail(user.email!);
      }

      userData ??= await getUserData(user.uid);

      // Se não existe, cria
      if (userData == null) {
        log('Usuário não encontrado no backend, criando...');
        final createdId = await createUser(
          userId: user.uid,
          userName: user.displayName ?? 'Usuário',
          userEmail: user.email ?? '',
        );
        return createdId != null;
      }

      log('Usuário já existe no backend');
      return true;
    } catch (e) {
      log('Erro ao sincronizar usuário: $e');
      return false;
    }
  }

  Future<String?> _getBackendUserId({bool createIfMissing = true}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log('No authenticated user to resolve backend ID');
      return null;
    }

    try {
      Map<String, dynamic>? userData;
      if (user.email != null && user.email!.isNotEmpty) {
        userData = await getUserDataByEmail(user.email!);
      }
      userData ??= await getUserData(user.uid);

      final backendId = userData?['backendId'] as String?;
      if (backendId != null && backendId.isNotEmpty) {
        return backendId;
      }

      if (!createIfMissing) {
        return null;
      }

      final result = await _connector
          .createUser(
            userCreatedAt: DateTime.now(),
            userName: user.displayName ?? 'Usuário',
            userEmail: user.email ?? '',
          )
          .execute();

      log('Created backend user to resolve ID: ${result.data.user_insert.id}');
      return result.data.user_insert.id;
    } catch (e, stackTrace) {
      log('Error resolving backend user ID: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<String?> createUnit({
    required String unitName,
    required String unitLocal,
    required int unitMacCapacity,
    required bool unitActive,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log('No authenticated user to create unit');
        return null;
      }

      // Sincronizar usuário primeiro para garantir que existe no backend
      final synced = await syncUserWithBackend();
      if (!synced) {
        log('Failed to sync user with backend before creating unit');
        return null;
      }

      final backendUserId = await _getBackendUserId();
      if (backendUserId == null) {
        log('Unable to resolve backend user ID to create unit');
        return null;
      }

      final managerId = backendUserId;
      log('Using managerId: $managerId');
      log(
        'Creating unit with params: name=$unitName, local=$unitLocal, capacity=$unitMacCapacity, active=$unitActive, managerId=$managerId',
      );

      final result = await _connector
          .createUnit(
            unitName: unitName,
            unitLocal: unitLocal,
            unitMacCapacity: unitMacCapacity,
            unitManagerId: managerId,
            unitActive: unitActive,
          )
          .execute();

      log('Unit created in backend: ${result.data.unit_insert.id}');
      return result.data.unit_insert.id;
    } catch (e, stackTrace) {
      log('Error creating unit in backend: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUnitsForCurrentManager() async {
    try {
      await syncUserWithBackend();
      final backendUserId = await _getBackendUserId();
      final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
      final firebaseEmail = FirebaseAuth.instance.currentUser?.email
          ?.toLowerCase()
          .trim();

      List units = [];

      if (backendUserId != null) {
        final result = await _connector
            .readManagerUnits(managerId: backendUserId)
            .execute();
        units = result.data.units;
      }

      if (units.isEmpty && firebaseUid != null && firebaseUid.isNotEmpty) {
        try {
          final fallbackResult = await _connector
              .readManagerUnitsByAuth(authId: firebaseUid)
              .execute();
          units = fallbackResult.data.units;
        } catch (e) {
          log('Fallback load of manager units by auth uid failed: $e');
        }
      }

      if (units.isEmpty) {
        try {
          final legacyResult = await _connector.readAllUnits().execute();
          final legacyUnits = firebaseEmail == null
              ? legacyResult.data.units
              : legacyResult.data.units.where((unit) {
                  final managerEmail = unit.unitManager?.userEmail
                      .toLowerCase()
                      .trim();
                  return managerEmail == null || managerEmail == firebaseEmail;
                }).toList();

          if (legacyUnits.isNotEmpty) {
            units = legacyUnits;
          }
        } catch (e) {
          log('Legacy load of units without manager linkage failed: $e');
        }
      }

      return units
          .map(
            (unit) => {
              'id': unit.id,
              'name': unit.unitName,
              'local': unit.unitLocal,
              'capacity': unit.unitMacCapacity,
              'active': unit.unitActive ?? false,
              'managerName': unit.unitManager?.userName,
            },
          )
          .toList();
    } catch (e, stackTrace) {
      log('Error fetching manager units: $e');
      log('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Creates a new movie in the backend
  Future<String?> createMovie({
    required String movieTitle,
    required String movieGenre,
    required String movieAgeClass,
    required int movieDuration,
    required String movieDistrib,
    required String movieFormat,
    required String movieDirector,
    required bool movieActive,
  }) async {
    try {
      final result = await _connector
          .createMovie(
            movieTitle: movieTitle,
            movieGenre: movieGenre,
            movieAgeClass: movieAgeClass,
            movieDuration: movieDuration,
            movieDistrib: movieDistrib,
            movieFormat: movieFormat,
            movieDirector: movieDirector,
            movieActive: movieActive,
          )
          .execute();

      log('Movie created in backend: ${result.data.movie_insert.id}');
      return result.data.movie_insert.id;
    } catch (e) {
      log('Error creating movie in backend: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllMovies() async {
    try {
      final result = await _connector.readAllMovies().execute();
      return result.data.movies
          .map(
            (movie) => {
              'id': movie.id,
              'movieTitle': movie.movieTitle,
              'movieGenre': movie.movieGenre,
              'movieAgeClass': movie.movieAgeClass,
              'movieDuration': movie.movieDuration,
              'movieDistrib': movie.movieDistrib,
              'movieFormat': movie.movieFormat,
              'movieDirector': movie.movieDirector,
              'movieActive': movie.movieActive,
            },
          )
          .toList();
    } catch (e) {
      log('Error fetching movies: $e');
      return [];
    }
  }

  Future<Map<String, Map<String, dynamic>>> getMovieBoxOfficeStats() async {
    try {
      final sessionsResult = await _connector.readAllSessions().execute();
      final Map<String, Map<String, dynamic>> stats = {};

      for (final session in sessionsResult.data.sessions) {
        final movieId = session.sessionMovie.id;
        final ticketsSold = session.sessionTicketsSold ?? 0;
        final netValue = session.sessionNetValue ?? 0.0;

        if (!stats.containsKey(movieId)) {
          stats[movieId] = {
            'movieId': movieId,
            'movieTitle': session.sessionMovie.movieTitle,
            'totalTickets': 0,
            'totalRevenue': 0.0,
            'sessionCount': 0,
          };
        }

        stats[movieId]!['totalTickets'] =
            (stats[movieId]!['totalTickets'] as int) + ticketsSold;
        stats[movieId]!['totalRevenue'] =
            (stats[movieId]!['totalRevenue'] as double) + netValue;
        stats[movieId]!['sessionCount'] =
            (stats[movieId]!['sessionCount'] as int) + 1;
      }

      return stats;
    } catch (e, stackTrace) {
      log('Error fetching movie box office stats: $e');
      log('Stack trace: $stackTrace');
      return {};
    }
  }

  Future<Map<String, dynamic>?> getMovieById(String movieId) async {
    try {
      final result = await _connector.readSingleMovie(id: movieId).execute();

      if (result.data.movie != null) {
        return result.data.movie!.toJson();
      }
      return null;
    } catch (e) {
      log('Error fetching movie by ID ($movieId): $e');
      return null;
    }
  }

  Future<bool> updateMovie({
    required String movieId,
    required String movieTitle,
    required String movieGenre,
    required String movieAgeClass,
    required int movieDuration,
    required String movieDistrib,
    required String movieFormat,
    required String movieDirector,
    required bool movieActive,
  }) async {
    try {
      final result = await _connector
          .updateMovie(
            movieId: movieId,
            movieTitle: movieTitle,
            movieGenre: movieGenre,
            movieAgeClass: movieAgeClass,
            movieDuration: movieDuration,
            movieDistrib: movieDistrib,
            movieFormat: movieFormat,
            movieDirector: movieDirector,
            movieActive: movieActive,
          )
          .execute();

      log('Movie updated in backend: ${result.data.movie_update}');
      return true;
    } catch (e) {
      log('Error updating movie in backend: $e');
      return false;
    }
  }

  Future<bool> deleteMovie(String movieId) async {
    try {
      final result = await _connector.deleteMovie(movieId: movieId).execute();

      log('Movie deleted in backend: ${result.data.movie_delete}');
      return true;
    } catch (e) {
      log('Error deleting movie in backend: $e');
      return false;
    }
  }

  Future<bool> deleteUnit(String unitId) async {
    try {
      final result = await _connector.deleteUnit(unitId: unitId).execute();

      log('Unit deleted in backend: ${result.data.unit_delete}');
      return true;
    } catch (e) {
      log('Error deleting unit in backend: $e');
      return false;
    }
  }

  Future<String?> createAudience({
    required String unitId,
    required int audienceAge,
    required String audienceGender,
    required String audienceFormat,
  }) async {
    try {
      final result = await _connector
          .createAudience(
            audienceUnitId: unitId,
            audienceAge: audienceAge,
            audienceGender: audienceGender,
            audienceFormat: audienceFormat,
          )
          .execute();

      log('Audience created in backend: ${result.data.audience_insert.id}');
      return result.data.audience_insert.id;
    } catch (e, stackTrace) {
      log('Error creating audience in backend: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAudienceByUnit(String unitId) async {
    try {
      final result = await _connector
          .readAudienceByUnit(unitId: unitId)
          .execute();

      return result.data.audiences
          .map(
            (audience) => {
              'id': audience.id,
              'age': audience.audienceAge,
              'genre': audience.audienceGender,
              'format': audience.audienceFormat,
            },
          )
          .toList();
    } catch (e, stackTrace) {
      log('Error fetching audience for unit $unitId: $e');
      log('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<bool> createProduct({
    required String productName,
    required String productType,
    required double productPrice,
    required bool productActive,
  }) async {
    try {
      final result = await _connector
          .createProduct(
            productName: productName,
            productType: productType,
            productPrice: productPrice,
            productActive: productActive,
          )
          .execute();

      log('Product created in backend: ${result.data.product_insert.id}');
      return true;
    } catch (e) {
      log('Error creating product in backend: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final result = await _connector.readAllProducts().execute();

      return result.data.products.map((product) {
        final price = product.productPrice ?? 0;
        final sales = product.sales_on_saleProduct;
        int totalQuantity = 0;
        double totalRevenue = 0;
        for (final sale in sales) {
          final quantity = sale.saleQuant ?? 0;
          final netValue = sale.saleNetValue;
          totalQuantity += quantity;
          if (netValue != null) {
            totalRevenue += netValue;
          } else {
            totalRevenue += price * quantity;
          }
        }

        return {
          'id': product.id,
          'name': product.productName,
          'type': product.productType,
          'price': price,
          'active': product.productActive ?? false,
          'totalQuantity': totalQuantity,
          'totalRevenue': totalRevenue,
        };
      }).toList();
    } catch (e, stackTrace) {
      log('Error fetching products: $e');
      log('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    try {
      final result = await _connector.readAllSessions().execute();
      return result.data.sessions.map((session) {
        return {
          'id': session.id,
          'date': session.sessionDate,
          'hour': session.sessionHour,
          'movieTitle': session.sessionMovie.movieTitle,
          'unitName': session.sessionUnit.unitName,
          'ticketsSold': session.sessionTicketsSold,
          'netValue': session.sessionNetValue,
        };
      }).toList();
    } catch (e, stackTrace) {
      log('Error fetching sessions: $e');
      log('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<String?> createSession({
    required String movieId,
    required String unitId,
    required DateTime sessionDate,
    required DateTime sessionHour,
    int? ticketsSold,
    double? netValue,
  }) async {
    try {
      final builder = _connector.createSession(
        sessionMovieId: movieId,
        sessionUnitId: unitId,
        sessionDate: sessionDate,
        sessionHour: sessionHour,
      );
      if (ticketsSold != null) {
        builder.sessionTicketsSold(ticketsSold);
      }
      if (netValue != null) {
        builder.sessionNetValue(netValue);
      }
      final result = await builder.execute();
      log('Session created in backend: ${result.data.session_insert.id}');
      return result.data.session_insert.id;
    } catch (e, stackTrace) {
      log('Error creating session in backend: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<String?> createSale({
    required String productId,
    required String sessionId,
    required DateTime saleDate,
    required int quantity,
    double? netValue,
  }) async {
    try {
      final builder = _connector.createSale(
        saleProductId: productId,
        saleSessionId: sessionId,
        saleDate: saleDate,
        saleQuant: quantity,
      );
      if (netValue != null) {
        builder.saleNetValue(netValue);
      }
      final result = await builder.execute();
      log('Sale created in backend: ${result.data.sale_insert.id}');
      return result.data.sale_insert.id;
    } catch (e, stackTrace) {
      log('Error creating sale in backend: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }
}
