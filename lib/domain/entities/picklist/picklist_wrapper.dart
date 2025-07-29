import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';

part 'picklist_wrapper.freezed.dart';
part 'picklist_wrapper.g.dart';

@freezed
class PicklistWrapper with _$PicklistWrapper {
  const PicklistWrapper._();

  const factory PicklistWrapper({
    int? count,
    required List<Picklist> rows,
  }) = _PicklistWrapper;

  factory PicklistWrapper.fromJson(Map<String, dynamic> json) => _$PicklistWrapperFromJson(json);
}