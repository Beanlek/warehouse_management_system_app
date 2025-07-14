import 'package:get_it/get_it.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Blocs
  sl.registerLazySingleton<WarehouseBloc>(() => WarehouseBloc());
}
