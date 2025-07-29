import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist_bloc.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist_event.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist_state.dart';
import 'package:warehouse/presentation/widgets/global_breadcrumb.dart';
import 'package:warehouse/presentation/widgets/picklist/picklist_card.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistScreen extends StatefulWidget {
  const PicklistScreen({super.key});

  @override
  State<PicklistScreen> createState() => _PicklistScreenState();
}

class _PicklistScreenState extends State<PicklistScreen> {
  late final PicklistBloc _picklistBloc;
  late List<Picklist> _picklist;
  int numPages = 10;
  final TextEditingController _searchController = TextEditingController();
  final NumberPaginatorController paginatorController = NumberPaginatorController();

  String currentStatus = '';

  @override
  void initState() {
    super.initState();
    _picklistBloc = BlocProvider.of<PicklistBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PicklistBloc, PicklistState>(
      listener: (context, state) {
        if (state.picklist.isNotEmpty) {
          filterPicklist(_searchController.text, state.picklist);
          debugPrint('Picklist loaded: ${state.picklist.length} items');
        }
        if(state.isLoading){
          _picklist = [];
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Picklist Allotment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: biruImran,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: BlocBuilder<PicklistBloc, PicklistState>(
              bloc: _picklistBloc,
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    _picklistBloc.add(PicklistEvent.setup(''));
                    setState(() {
                      currentStatus = '';
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            Breadcrumb(paths: ['Picklist Allotment']),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          labelText: 'Search',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          filterPicklist(value, state.picklist);
                                        },
                                    ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        value: currentStatus,
                                        decoration: InputDecoration(
                                          labelText: 'Status',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      items: [
                                        DropdownMenuItem(
                                          value: '',
                                          child: Text('All'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'opened',
                                          child: Text('Opened'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'sent for picking',
                                          child: Text('Sent for Picking'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'done packing',
                                          child: Text('Done Packing'),
                                        ),
                                      ], 
                                      onChanged: (value) {
                                        setState(() {
                                          currentStatus = value!;
                                        });
                                        _picklistBloc.process(PicklistEvent.selectStatus(currentStatus));
                                      },
                                      ),
                                    ),
                                  )
                              ]),
                            ),
                            BlocBuilder<PicklistBloc, PicklistState>(
                            bloc: context.read<PicklistBloc>(),
                            builder: (context, state) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width / 7) * 4,
                                child: NumberPaginator(
                                    controller: paginatorController,
                                    numberPages: (state.count / 20).ceil().clamp(1, double.infinity).toInt(),
                                    onPageChange: (index) async {
                                      setState(() {
                                        
                                      });
                                      _picklistBloc.process(PicklistEvent.updatePage(index+1));
                                    },
                                    config: NumberPaginatorUIConfig(
                                      buttonSelectedForegroundColor: white,
                                      buttonUnselectedForegroundColor: textColorTertiary,
                                      buttonSelectedBackgroundColor: biruImran,
                                    ),
                                    showNextButton: numPages == 1 ? false : true,
                                    showPrevButton: numPages == 1 ? false : true,
                                  ),
                              );
                            }
                          ),
                            BlocBuilder<PicklistBloc, PicklistState>(
                              builder: (context, state) {
                                if (state.picklist.isEmpty) {
                                  return const Center(
                                    child: Text('No picklist data available.'),
                                  );
                                }
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      itemCount: _picklist.length,
                                      itemBuilder: (context, index) {
                                        final picklistItem = _picklist[index];
                                        return PicklistCard(picklistItem: picklistItem);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (state.isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.3), // <-- tint here
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // optional: white spinner
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            )),
    );
  }

  filterPicklist(String query, List<Picklist> picklist) {
    List<Picklist> filteredList = picklist.where((picklist) => picklist.query(query)).toList();
    _picklist = filteredList;
    setState(() {
    });
    debugPrint('Filtered picklist: ${_picklist.length} items');
  }
}
