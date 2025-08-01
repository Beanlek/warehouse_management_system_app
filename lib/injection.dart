import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/services/storage_service.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_bloc.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies(String env) async {
  getIt.init(environment: env);
  getIt.registerLazySingleton<WarehouseBloc>(() => WarehouseBloc());
  //getIt.registerLazySingleton<StorageService>(() => StorageService());
}
