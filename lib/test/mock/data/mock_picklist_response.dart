import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_response_dto.dart';

final mockPicklistResponse = PicklistResponseDto(
  status: "success",
  picklists: PicklistWrapperDto(
    count: 1,
    rows: [
      PicklistDto(
        id: "P40001",
        status: "opened",
        siteId: "ZX",
        createdAt: "2025-08-01T08:00:00Z",
        created_by: "mock_user",
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
