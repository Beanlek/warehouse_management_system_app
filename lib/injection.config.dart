// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:warehouse/core/network/retrofit/api_client.dart' as _i1041;
import 'package:warehouse/core/network/retrofit/dio/dio_client.dart' as _i231;
import 'package:warehouse/core/services/storage_service.dart' as _i833;
import 'package:warehouse/data/repositories/warehouse_inventory_repository_impl.dart'
    as _i351;
import 'package:warehouse/domain/repositories/warehouse_inventory_repository.dart'
    as _i186;
import 'package:warehouse/domain/usecases/warehouse_inventory/fetch_sites_list_use_case.dart'
    as _i428;
import 'package:warehouse/domain/usecases/warehouse_inventory/fetch_warehouse_inventory_list_use_case.dart'
    as _i633;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i231.DioClient>(() => _i231.DioClient());
    gh.factory<_i833.StorageService>(() => _i833.StorageService());
    gh.lazySingleton<_i1041.ApiClient>(
        () => _i1041.ApiClient(gh<_i231.DioClient>()));
    gh.factory<_i186.WarehouseInventoryRepository>(
        () => _i351.WarehouseInventoryRepositoryImpl(gh<_i1041.ApiClient>()));
    gh.factory<_i428.FetchSitesListUseCase>(() =>
        _i428.FetchSitesListUseCase(gh<_i186.WarehouseInventoryRepository>()));
    gh.factory<_i633.FetchWarehouseInventoryListUseCase>(() =>
        _i633.FetchWarehouseInventoryListUseCase(
            gh<_i186.WarehouseInventoryRepository>()));
    return this;
  }
}
