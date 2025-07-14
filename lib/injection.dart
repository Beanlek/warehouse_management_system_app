import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_bloc.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.init();
  getIt.registerLazySingleton<WarehouseBloc>(() => WarehouseBloc());
}
