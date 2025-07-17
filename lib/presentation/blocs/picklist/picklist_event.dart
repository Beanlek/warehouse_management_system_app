import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';


part 'picklist_event.freezed.dart';

@freezed
class PicklistEvent with _$PicklistEvent {
  const factory PicklistEvent.setup(String? status) = Setup;
  const factory PicklistEvent.selectPickList(String id) = SelectPickList;
  const factory PicklistEvent.loadPickList(List<Picklist> picklist) = loadPickList;
  const factory PicklistEvent.loadPickListDetails(PicklistDetails picklistDetails) = loadPickListDetails;
  const factory PicklistEvent.searchPicklist(List<Picklist> picklist) = searchPicklist; 
}
