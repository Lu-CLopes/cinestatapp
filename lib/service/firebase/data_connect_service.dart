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

      // Se não encontrou por email, tenta por ID
      if (userData == null) {
        userData = await getUserData(user.uid);
      }

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

      final result = await _connector
          .createUnit(
            unitName: unitName,
            unitLocal: unitLocal,
            unitMacCapacity: unitMacCapacity,
            unitManagerId: user.uid,
            unitActive: unitActive,
          )
          .execute();

      log('Unit created in backend: ${result.data.unit_insert.id}');
      return result.data.unit_insert.id;
    } catch (e) {
      log('Error creating unit in backend: $e');
      return null;
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
}
