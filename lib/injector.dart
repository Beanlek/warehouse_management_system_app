import 'package:get_it/get_it.dart';
import 'package:warehouse/core/services/storage_service.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Blocs
  sl.registerLazySingleton<WarehouseBloc>(() => WarehouseBloc());
  //sl.registerLazySingleton<StorageService>(() => StorageService());
}
