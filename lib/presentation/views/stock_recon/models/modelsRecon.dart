// import 'package:flutter/material.dart';

// ignore_for_file: file_names

class SalesSummary {
  final int sequence;
  final String skuId;
  final String uomId;
  final int quantity;

  SalesSummary({
    required this.sequence,
    required this.skuId,
    required this.uomId,
    required this.quantity,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    return SalesSummary(
      sequence: json['sequence'],
      skuId: json['sku_id'],
      uomId: json['uom_id'],
      quantity: json['quantity'][0], // Take the first element of the quantity array
    );
  }
}

class ReturnSummary {
  final int sequence;
  final String skuId;
  final String uomId;
  final int quantity;

  ReturnSummary({
    required this.sequence,
    required this.skuId,
    required this.uomId,
    required this.quantity,
  });

  factory ReturnSummary.fromJson(Map<String, dynamic> json) {
    return ReturnSummary(
      sequence: json['sequence'],
      skuId: json['sku_id'],
      uomId: json['uom_id'],
      quantity: json['quantity'][0], // Take the first element of the quantity array
    );
  }
}

class SalesReconciliation {
  final int sequence;
  final String skuId;
  final String uomId;
  final int quantity;

  SalesReconciliation({
    required this.sequence,
    required this.skuId,
    required this.uomId,
    required this.quantity,
  });

  factory SalesReconciliation.fromJson(Map<String, dynamic> json) {
    return SalesReconciliation(
      sequence: json['sequence'],
      skuId: json['sku_id'],
      uomId: json['uom_id'],
      quantity: json['quantity'][0], // Take the first element of the quantity array
    );
  }
}

class ReturnReconciliation {
  final int sequence;
  final String skuId;
  final String uomId;
  final int quantity;

  ReturnReconciliation({
    required this.sequence,
    required this.skuId,
    required this.uomId,
    required this.quantity,
  });

  factory ReturnReconciliation.fromJson(Map<String, dynamic> json) {
    return ReturnReconciliation(
      sequence: json['sequence'],
      skuId: json['sku_id'],
      uomId: json['uom_id'],
      quantity: json['quantity'][0], // Take the first element of the quantity array
    );
  }
}

class ReconDetails {
  final String id;
  final String siteId;
  final String vanId;
  final String salesDate;
  final String status;
  final List<SalesSummary> salesSummary;
  final List<ReturnSummary> returnSummary;
  final List<SalesReconciliation> salesReconcilation;
  final List<ReturnReconciliation> returnReconcilation;

  ReconDetails({
    required this.id,
    required this.siteId,
    required this.vanId,
    required this.salesDate,
    required this.status,
    required this.salesSummary,
    required this.returnSummary,
    required this.salesReconcilation,
    required this.returnReconcilation,
  });

  factory ReconDetails.fromJson(Map<String, dynamic> json) {
    final stockRecon = json['stock_recon'];
    return ReconDetails(
      id: stockRecon['id'],
      siteId: stockRecon['site_id'],
      vanId: stockRecon['van_id'],
      salesDate: stockRecon['sales_date'],
      status: stockRecon['status'],
      salesSummary: List<SalesSummary>.from(json['salesSummary']
          .map((summary) => SalesSummary.fromJson(summary))),
      returnSummary: List<ReturnSummary>.from(json['returnSummary']
          .map((summary) => ReturnSummary.fromJson(summary))),
      salesReconcilation: List<SalesReconciliation>.from(
          json['salesReconcilation']
              .map((summary) => SalesReconciliation.fromJson(summary))),
      returnReconcilation: List<ReturnReconciliation>.from(
          json['returnReconcilation']
              .map((summary) => ReturnReconciliation.fromJson(summary))),
    );
  }
}
