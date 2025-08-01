import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/network_error.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_delete_response_dto.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';
import 'package:warehouse/domain/entities/picklist/picklist_wrapper.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';

@Injectable(as: PicklistRepository, env: ['mock'])
class MockPicklistRepository extends PicklistRepository {
  @override
  Future<Result<PicklistWrapper, AppError>> fetchPickList(
    String token,
    String picklistId,
    String status,
    int page,
  ) async {
    return Result.success(
      PicklistWrapper(
        count: 1,
        rows: [
          Picklist(
            id: "P40001",
            status: "opened",
            siteId: "ZX",
            createdAt: "2025-08-01T08:00:00Z",
            createdBy: "mock_user",
            sentForPickingBy: null,
            sentForPickingAt: null,
            startedPackingAt: null,
            donePackingAt: null,
            createdDate: "2025-08-01",
            updatedAt: "2025-08-01T09:00:00Z",
          ),
        ],
      ),
    );
  }

  @override
  Future<Result<PicklistDetails, AppError>> fetchPickListDetails(
    String token,
    String picklistId,
  ) async {
    return Result.success(
      PicklistDetails(
        picklist: Picklist(
          id: "P40001",
          status: "opened",
          siteId: "ZX",
          createdAt: "2025-08-01T08:00:00Z",
          createdBy: "mock_user",
          sentForPickingBy: "mock_user",
          sentForPickingAt: "2025-08-01T08:10:00Z",
          startedPackingAt: "2025-08-01T08:30:00Z",
          donePackingAt: null,
          createdDate: "2025-08-01",
          updatedAt: "2025-08-01T09:00:00Z",
        ),
        batch: [
          Batch(
            skuId: "SKU123",
            uomId: "PK",
            quantity: [200],
          ),
        ],
        packing: [
          Packing(
            vanAllotId: "A000099999",
            vanId: "VZX001",
            status: "in progress",
            allotDetails: [
              Batch(
                skuId: "SKU123",
                uomId: "PK",
                quantity: [200],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Future<Result<PicklistDeleteResponseDto, NetworkError>> deletePickList(String token, Map<String, dynamic> body) async {
    
    print('Mock deletePickList called with token: $token and body: $body');

    final value = PicklistDeleteResponseDto(id: 'P40001');
    
    return Future<Result<PicklistDeleteResponseDto, NetworkError>>.value(
        Result.success(value));
  }

  
  @override
  Future setPicklistPackAll(String token, Map<String, dynamic> picklistData) {
    // TODO: implement setPicklistPackAll
    throw UnimplementedError();
  }
  
  @override
  Future setPicklistSendForPicking(String token, Map<String, dynamic> picklistData) {
    // TODO: implement setPicklistSendForPicking
    throw UnimplementedError();
  }

  // Implement other methods if needed for tests
}
