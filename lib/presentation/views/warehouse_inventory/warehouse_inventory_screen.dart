import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/domain/entities/sites/site.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_bloc.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_event.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_state.dart';
import 'package:warehouse/utils/utils.dart';

class WarehouseStocksScreen extends StatefulWidget {
  const WarehouseStocksScreen({super.key});

  @override
  State<WarehouseStocksScreen> createState() => _WarehouseStocksScreenState();
}

class _WarehouseStocksScreenState extends State<WarehouseStocksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Warehouse Stocks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
          body: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      BlocBuilder<WarehouseBloc, WarehouseState>(
                    builder: (context, state) {
                      return InkWell(
                          onTap: () {
                            _buildBottomSheet(state.siteList);
                          },
                          child: TextField(
                            enabled: false,
                            readOnly: true,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            controller: TextEditingController(
                                text: state.siteId != null
                                    ? '${state.siteList
                                        .firstWhere(
                                            (site) => site.id == state.siteId)
                                        .id} - ${state.siteList
                                        .firstWhere(
                                            (site) => site.id == state.siteId)
                                        .name}'
                                    : ''),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusColor: Colors.black,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blueGrey
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        labelText: 'Select Site',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blueGrey,
                                        )),
                          ));
                    },
                    buildWhen: (previous, current) =>
                        previous.siteId !=
                        current.siteId,
                  ),
                ),
              ],
            ),
          ));
  }

  void _buildBottomSheet(List<Site> sites) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (BuildContext buildContext) {
        return StatefulBuilder(
          builder: (BuildContext buildContext, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 32, bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 0, 32, 16),
                        child: Text(
                          'Please Select Site',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ...sites.map((site) {
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              // Close the modal
                              Navigator.pop(context);
                              BlocProvider.of<WarehouseBloc>(context)
                                  .process(WarehouseEvent.selectSite(
                                      site.id));
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${site.id} - ${site.name}',
                                  style: const TextStyle(fontSize: 16, ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
