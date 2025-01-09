import '../../domain/entities/user.dart' as entity;
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/user_model.dart' as model;

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  UserRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<entity.User>> getUsers() async {
    try {
      final List<model.UserModel> userModels =
          await remoteDataSource.getUsers();
      await localDataSource.cacheUsers(userModels);
      return userModels
          .map((model) => entity.User(
                id: model.id,
                name: model.name,
                email: model.email,
                phone: model.phone,
                website: model.website,
                address: entity.Address(
                  street: model.address.street,
                  suite: model.address.suite,
                  city: model.address.city,
                  zipcode: model.address.zipcode,
                ),
              ))
          .toList();
    } catch (e) {
      final cachedUsers = await localDataSource.getCachedUsers();
      return cachedUsers
          .map((model) => entity.User(
                id: model.id,
                name: model.name,
                email: model.email,
                phone: model.phone,
                website: model.website,
                address: entity.Address(
                  street: model.address.street,
                  suite: model.address.suite,
                  city: model.address.city,
                  zipcode: model.address.zipcode,
                ),
              ))
          .toList();
    }
  }
}
