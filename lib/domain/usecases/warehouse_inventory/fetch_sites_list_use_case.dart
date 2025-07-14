import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/domain/entities/sites/site.dart';
import 'package:warehouse/domain/repositories/warehouse_inventory_repository.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class FetchSitesListUseCase {
  final WarehouseInventoryRepository _warehouseInventoryRepository;

  FetchSitesListUseCase(this._warehouseInventoryRepository);
  
  Future<Result<List<Site>, AppError>> execute() async {
    final String? token = await TokenUtil.getToken();
    debugPrint('Fetching site list with token: $token');
    return await _warehouseInventoryRepository.fetchSiteList(token ?? '');
  }
}