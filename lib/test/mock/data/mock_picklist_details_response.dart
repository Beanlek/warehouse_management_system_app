import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/data/models/batch/batch_dto.dart';
import 'package:warehouse/data/models/packing/packing_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_details_response_dto.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';

final mockPicklistDetailsResponseDto = PicklistDetailsResponseDto(
  picklist: PicklistDto(
    id: "P40001",
    status: "opened",
    siteId: "ZX",
    createdAt: "2025-08-01T08:00:00Z",
    created_by: "mock_user",
    sentForPickingBy: "mock_user",
    sentForPickingAt: "2025-08-01T08:10:00Z",
    startedPackingAt: "2025-08-01T08:30:00Z",
    donePackingAt: null,
    createdDate: "2025-08-01",
    updatedAt: "2025-08-01T09:00:00Z",
  ),
  batch: [
    BatchDto(
      skuId: "SKU123",
      uomId: "PK",
      quantity: [200],
    ),
  ],
  packing: [
    PackingDto(
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
);
