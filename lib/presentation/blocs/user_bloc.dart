import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final Connectivity connectivity;
  List<User> allUsers = [];

  UserBloc(this.getUsers, this.connectivity) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
    on<SortUsers>(_onSortUsers);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(const UserError('No internet connection'));
        return;
      }
      allUsers = await getUsers();
      if (allUsers.isEmpty) {
        emit(UserEmpty());
      } else {
        emit(UserLoaded(allUsers));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    if (event.query.isEmpty) {
      emit(UserLoaded(allUsers));
    } else {
      final filteredUsers = allUsers
          .where((user) =>
              user.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(UserLoaded(filteredUsers));
    }
  }

  void _onSortUsers(SortUsers event, Emitter<UserState> emit) {
    final sortedUsers = List<User>.from(allUsers);
    sortedUsers.sort((a, b) => a.name.compareTo(b.name));
    emit(UserLoaded(sortedUsers));
  }
}
