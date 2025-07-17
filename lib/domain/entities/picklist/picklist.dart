import 'package:freezed_annotation/freezed_annotation.dart';

part 'picklist.freezed.dart';

@freezed
class Picklist with _$Picklist {
  const Picklist._();

  const factory Picklist({
    required String id,
    required String status,
    @JsonKey(name: 'site_id') String? siteId, //association
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _Picklist;

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