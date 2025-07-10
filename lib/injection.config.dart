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
    gh.lazySingleton<_i1041.ApiClient>(
        () => _i1041.ApiClient(gh<_i231.DioClient>()));
    return this;
  }
}
