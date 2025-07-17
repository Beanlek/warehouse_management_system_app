import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';

part 'picklist_state.freezed.dart';

@freezed
class PicklistState with _$PicklistState {
  const PicklistState._();
  
  const factory PicklistState({
    @Default(false) bool isLoading,
    @Default([]) List<Picklist> picklist,
    @Default(PicklistDetails.empty) PicklistDetails picklistDetails,
  }) = _PicklistState;

}