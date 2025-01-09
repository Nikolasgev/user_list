import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/local_data_source.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/usecases/get_users.dart';
import 'presentation/blocs/user_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final connectivity = Connectivity();
  runApp(
    MyApp(sharedPreferences: sharedPreferences, connectivity: connectivity),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Connectivity connectivity;

  const MyApp({
    super.key,
    required this.sharedPreferences,
    required this.connectivity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        GetUsers(UserRepositoryImpl(RemoteDataSource(), LocalDataSource())),
        connectivity,
      ),
      child: MaterialApp(
        title: 'User List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
