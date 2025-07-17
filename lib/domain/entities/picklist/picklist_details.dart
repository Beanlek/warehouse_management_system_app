import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';

part 'picklist_details.freezed.dart';

@freezed
class PicklistDetails with _$PicklistDetails {
  const PicklistDetails._();

  const factory PicklistDetails({
    required Picklist picklist,
    required List<Batch> batch,
    required List<Packing> packing,
  }) = _PicklistDetails;

  static const PicklistDetails empty = PicklistDetails(
    picklist: Picklist(
      id: '',
      status: '',
      siteId: null,
      createdAt: null,
      createdBy: null,
      sentForPickingBy: null,
      sentForPickingAt: null,
      startedPackingAt: null,
      donePackingAt: null,
      createdDate: null,
      updatedAt: null,
    ),
    batch: [],
    packing: [],
  );

}