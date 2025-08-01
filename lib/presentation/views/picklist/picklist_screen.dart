import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
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
    //List<Picklist> _picklist = [];
    int numPages = 10;
    final TextEditingController _searchController = TextEditingController();
    final NumberPaginatorController paginatorController = NumberPaginatorController();

    String currentStatus = '';

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PicklistBloc>().add(PicklistEvent.refresh());
    });
    }

    @override
    Widget build(BuildContext context) {
    return BlocListener<PicklistBloc, PicklistState>(
      listener: (context, state) {
        if (state.picklist.isNotEmpty) {
          debugPrint('Picklist loaded: ${state.picklist.length} items');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Picklist Allotment',
            style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w500),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<PicklistBloc, PicklistState>(
          builder: (context, state) {
            final _picklistBloc = context.read<PicklistBloc>();

            return RefreshIndicator(
              onRefresh: () async {
                _picklistBloc.add(PicklistEvent.setup(''));
                setState(() => currentStatus = '');
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        const Breadcrumb(paths: ['Picklist Allotment']),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    labelText: 'Search',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  onSubmitted: (value) {
                                    _picklistBloc.process(PicklistEvent.searchPicklistById(value));
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: currentStatus,
                                  decoration: InputDecoration(
                                    labelText: 'Status',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: '', child: Text('All')),
                                    DropdownMenuItem(value: 'opened', child: Text('Opened')),
                                    DropdownMenuItem(value: 'sent for picking', child: Text('Sent for Picking')),
                                    DropdownMenuItem(value: 'done packing', child: Text('Done Packing')),
                                  ],
                                  onChanged: (value) {
                                    setState(() => currentStatus = value!);
                                    _picklistBloc.process(PicklistEvent.selectStatus(currentStatus));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: NumberPaginator(
                            controller: paginatorController,
                            numberPages: (state.count / 20).ceil().clamp(1, double.infinity).toInt(),
                            onPageChange: (index) {
                              _picklistBloc.process(PicklistEvent.updatePage(index + 1));
                            },
                            config: NumberPaginatorUIConfig(
                              buttonSelectedForegroundColor: white,
                              buttonUnselectedForegroundColor: textColorTertiary,
                              buttonSelectedBackgroundColor: biruImran,
                            ),
                            showNextButton: numPages > 1,
                            showPrevButton: numPages > 1,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: state.picklist.isEmpty
                                ? const Center(child: Text('No picklist data available.'))
                                : ListView.builder(
                                    itemCount: state.picklist.length,
                                    itemBuilder: (context, index) {
                                      final item = state.picklist[index];
                                      return PicklistCard(picklistItem: item);
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
