class TransferOut {
  String id;
  String date;
  String status;
  String fromSiteId;
  String toSiteId;
  String createdBy;
  String createdAt;
  String remark;
  bool selected = false;

  TransferOut({
    required this.id,
    required this.date,
    required this.status,
    required this.fromSiteId,
    required this.toSiteId,
    required this.createdBy,
    required this.createdAt,
    required this.remark,
    this.selected = false,
  });

  factory TransferOut.fromJson(Map<String, dynamic> json) {
    return TransferOut(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      fromSiteId: json['from_site_id'] ?? '',
      toSiteId: json['to_site_id'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      remark: json['remark'] ?? '',
    );
  }

  void clear() {
    id = '';
    date = '';
    status = '';
    fromSiteId = '';
    toSiteId = '';
    createdBy = '';
    createdAt = '';
    remark = '';
    selected = false;
  }

  factory TransferOut.from(TransferOut other) {
    return TransferOut(
      id: other.id,
      date: other.date,
      status: other.status,
      fromSiteId: other.fromSiteId,
      toSiteId: other.toSiteId,
      createdBy: other.createdBy,
      createdAt: other.createdAt,
      remark: other.remark,
      selected: other.selected,
    );
  }
}
