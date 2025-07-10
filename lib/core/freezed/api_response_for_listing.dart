import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/data/models/responses/listing/listing_data.dart';

part 'api_response_for_listing.freezed.dart';
part 'api_response_for_listing.g.dart';

@Freezed(genericArgumentFactories: true)
class ApiResponseForListing<T> with _$ApiResponseForListing<T> {
  const factory ApiResponseForListing({
    required String? status,
    required String? error,
    required ListingData<List<T>>? data,
  }) = _ApiResponseForListing<T>;

  factory ApiResponseForListing.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) => _$ApiResponseForListingFromJson<T>(json, fromJsonT);
}
