import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_data.freezed.dart';
part 'listing_data.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class ListingData<T> with _$ListingData<T> {
  const factory ListingData({
    num? count,
    T? rows,
  }) = _ListingData<T>;

  factory ListingData.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$ListingDataFromJson<T>(json, fromJsonT);
  }
}