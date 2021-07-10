import 'package:get_it/get_it.dart';
import 'package:movie_info_app_flutter/data/database/db_helper.dart';
import 'package:movie_info_app_flutter/data/network/api_client.dart';
import 'package:movie_info_app_flutter/data/pref/shared_pref_helper.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';

final locator = GetIt.instance;

void setup() {
  ApiClient apiClient = ApiClient();
  DBHelper dbHelper = DBHelper.instance;
  SharedPrefHelper pref = SharedPrefHelper();
  locator.registerSingleton<ApiClient>(apiClient);
  locator.registerSingleton<SharedPrefHelper>(pref);
  locator.registerSingleton<DBHelper>(dbHelper);
  locator.registerSingleton<MovieRepository>(MovieRepository(apiClient, pref));
  locator.registerSingleton<SavedMoviesRepository>(
      SavedMoviesRepository(dbHelper));
}
