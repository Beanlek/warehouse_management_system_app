import 'package:freezed_annotation/freezed_annotation.dart';

part 'picklist.freezed.dart';
part 'picklist.g.dart';

@freezed
class Picklist with _$Picklist {
  const Picklist._();

  const factory Picklist({
    required String id,
    required String status,
    @JsonKey(name: 'site_id') String? siteId, //association
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'sent_for_picking_by') String? sentForPickingBy,
    @JsonKey(name: 'sent_for_picking_at') String? sentForPickingAt,
    @JsonKey(name: 'started_packing_at') String? startedPackingAt,
    @JsonKey(name: 'done_packing_at') String? donePackingAt,
    @JsonKey(name: 'created_date') String? createdDate,
    String? updatedAt,
  }) = _Picklist;

  factory Picklist.fromJson(Map<String, dynamic> json) => _$PicklistFromJson(json);

  bool query(String query){
    if(this.id.toLowerCase().contains(query.toLowerCase()) ||
       this.status.toLowerCase().contains(query.toLowerCase()) ||
       (this.siteId?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
       (this.createdAt?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
       (this.createdBy?.toLowerCase().contains(query.toLowerCase()) ?? false)) {
      return true;
    }
    return false;
  }
}