import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist.dart';
import 'package:warehouse/presentation/widgets/global_breadcrumb.dart';
import 'package:warehouse/presentation/widgets/global_details_card.dart';
import 'package:warehouse/presentation/widgets/picklist/picklist_batch_card.dart';
import 'package:warehouse/presentation/widgets/picklist/picklist_packing_card.dart';
import 'package:warehouse/presentation/widgets/picklist/picklist_status_history_card.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistDetailsScreen extends StatefulWidget {
  final String picklistId;
  
  const PicklistDetailsScreen({
    super.key,
    required this.picklistId
  });

  @override
  State<PicklistDetailsScreen> createState() => _PicklistDetailsScreenState();
}

class _PicklistDetailsScreenState extends State<PicklistDetailsScreen> {
  late final PicklistBloc _picklistBloc;
  late final String picklistId;

  @override
  void initState() {
    super.initState();

    picklistId = widget.picklistId;
    
    _picklistBloc = BlocProvider.of<PicklistBloc>(context);
    _picklistBloc.add(PicklistEvent.selectPickList(picklistId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PicklistBloc, PicklistState>(
      listener: (context, state) {
        if (state.picklistDetails.picklist.id != '') {
          debugPrint('PicklistDetails loaded: ${state.picklistDetails.picklist.id}');
        }
        if(state.isLoading){
          
        }
      },
      child: Scaffold(
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
            
            return Stack(
              children: [
                Column(
                  children: [
                    Breadcrumb(paths: ['Picklist Allotment', picklistId]),

                    DetailsCard(
                      dataMap: Map.fromEntries(
                        state.picklistDetails.picklist.toJson().entries.where((e) {
                          final _keys = ['id', 'site_id', 'created_date'];

                          return _keys.contains(e.key);
                        })
                      )
                    ),

                    SizedBox(height: 12,),

                    PicklistStatusHistoryCard(
                      dataMap: Map.fromEntries(
                        state.picklistDetails.picklist.toJson().entries.where((e) {
                          final _keys = [
                            'sent_for_picking_at',
                            'started_packing_at',
                            'done_packing_at',
                            'created_date'
                          ];

                          return _keys.contains(e.key) && (e.value != null || e.value != '');
                        })
                      )
                    ),

                    SizedBox(height: 12,),

                    PicklistBatchCard(
                      dataList: state.picklistDetails.batch
                    ),
                    
                    SizedBox(height: 12,),

                    PicklistPackingCard(
                      dataList: state.picklistDetails.packing
                    )
                  ],
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
            );
          },
        ),
      )
    );
  }
}