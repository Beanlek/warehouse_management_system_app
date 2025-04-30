import 'stock_item.dart';

class TransferOutDetailsResponse {
  final TransferOutInfo transferOut;
  final List<StockItem> details;

  TransferOutDetailsResponse({
    required this.transferOut,
    required this.details,
  });

  factory TransferOutDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TransferOutDetailsResponse(
      transferOut: TransferOutInfo.fromJson(json['transfer_out']),
      details: (json['details'] as List)
          .map((item) => StockItem.fromJson(item))
          .toList(),
    );
  }
}

class TransferOutInfo {
  final String id;
  final String date;
  final String fromSiteId;
  final String toSiteId;
  final String status;
  final String remark;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  TransferOutInfo({
    required this.id,
    required this.date,
    required this.fromSiteId,
    required this.toSiteId,
    required this.status,
    required this.remark,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransferOutInfo.fromJson(Map<String, dynamic> json) {
    return TransferOutInfo(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      fromSiteId: json['from_site_id'] ?? '',
      toSiteId: json['to_site_id'] ?? '',
      status: json['status'] ?? '',
      remark: json['remark'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
