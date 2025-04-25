class TransferIn {
  final String id;
  final String date;
  final String siteId;
  final String type;
  final String refId;
  final String remark;
  final String createdBy;
  final String? tempStatus;
  final String status;

  TransferIn({
    required this.id,
    required this.date,
    required this.siteId,
    required this.type,
    required this.refId,
    required this.remark,
    required this.createdBy,
    this.tempStatus,
    required this.status,
  });

  factory TransferIn.fromJson(Map<String, dynamic> json) {
    return TransferIn(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      siteId: json['site_id'] ?? '',
      type: json['type'] ?? '',
      refId: json['ref_id'] ?? '',
      remark: json['remark'] ?? '',
      createdBy: json['created_by'] ?? '',
      tempStatus: json['temp_status'],
      status: json['status'] ?? '',
    );
  }
}
