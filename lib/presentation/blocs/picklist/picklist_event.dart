import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';


part 'picklist_event.freezed.dart';

@freezed
class PicklistEvent with _$PicklistEvent {
  const factory PicklistEvent.setup(String? status) = Setup;
  const factory PicklistEvent.selectPickList(String picklistId) = SelectPickList;
  const factory PicklistEvent.loadPickList(List<Picklist> picklist) = LoadPickList;
  const factory PicklistEvent.loadPickListDetails(PicklistDetails picklistDetails) = LoadPickListDetails;
  const factory PicklistEvent.searchPicklist(List<Picklist> picklist) = SearchPicklist; 

  const factory PicklistEvent.deletePicklist({
    required String picklistId
  }) = DeletePicklist; 
  const factory PicklistEvent.deletePicklistSucceeded() = DeletePicklistSucceeded;

  const factory PicklistEvent.setPicklistSendForPicking({
    required String picklistId
  }) = SetPicklistSendForPicking; 
  const factory PicklistEvent.setPicklistSendForPickingSucceeded() = SetPicklistSendForPickingSucceeded;

  const factory PicklistEvent.setPicklistPackAll({
    required String picklistId
  }) = SetPicklistPackAll; 
  const factory PicklistEvent.setPicklistPackAllSucceeded() = SetPicklistPackAllSucceeded;

  const factory PicklistEvent.showPicklistError(String errorMessage) = ShowPicklistError;

}
