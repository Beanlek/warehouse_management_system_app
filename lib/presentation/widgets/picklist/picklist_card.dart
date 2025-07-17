import 'package:flutter/material.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistCard extends StatelessWidget {
  final bool? hasEvenIndex;
  final Picklist picklistItem;

  const PicklistCard({
    Key? key,
    this.hasEvenIndex,
    required this.picklistItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hasEvenIndex == true ? white : greyColor2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Site ID : ${picklistItem.siteId}',
                      style: primaryTextStyle(size: 16, color: black),
                    ),
                    Text(
                      'Picklist ID : ${picklistItem.id}',
                      style: primaryTextStyle(size: 16, color: black),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created By : ${picklistItem.createdBy}',
                      style: primaryTextStyle(size: 16, color: black),
                    ),
                    Text(
                      'Created At : ${picklistItem.createdAt}',
                      style: primaryTextStyle(size: 16, color: black),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    picklistItem.status,
                    style: secondaryTextStyle(size: 14, color: biruImran),
                  ),
                ),
              ),
          ],
          ),
        )
      ),
    );
  }
}
