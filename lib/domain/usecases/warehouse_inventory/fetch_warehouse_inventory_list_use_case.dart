import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';
import 'package:warehouse/domain/repositories/warehouse_inventory_repository.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class FetchWarehouseInventoryListUseCase {
  final WarehouseInventoryRepository _warehouseInventoryRepository;

  FetchWarehouseInventoryListUseCase(this._warehouseInventoryRepository);

  Future<Result<List<WarehouseInventory>, AppError>> execute(String siteId, String active) async {
    final String? token = await TokenUtil.getToken();
    return await _warehouseInventoryRepository.fetchWarehouseInventory(token ?? '', siteId, active);
  }
}