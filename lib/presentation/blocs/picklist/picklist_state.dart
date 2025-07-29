import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';

part 'picklist_state.freezed.dart';

@freezed
class PicklistState with _$PicklistState {
  const PicklistState._();
  
  const factory PicklistState({
    @Default(false) bool isLoading,
    @Default(1) int currentPage,
    @Default('') String searchId,

    @Default(false) bool deletePicklistSucceeded,
    @Default(false) bool deletePicklistProgress,

    @Default(false) bool setPicklistSendForPickingSucceeded,
    @Default(false) bool setPicklistSendForPickingProgress,

    @Default(false) bool setPicklistPackAllSucceeded,
    @Default(false) bool setPicklistPackAllProgress,

    @Default(0) int count,
    @Default('') String status,
    @Default([]) List<Picklist> picklist,
    @Default(PicklistDetails.empty) PicklistDetails picklistDetails,

    @Default(null) String? error,

  }) = _PicklistState;

}