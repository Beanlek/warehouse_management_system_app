import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist.dart';
import 'package:warehouse/presentation/widgets/global_breadcrumb.dart';
import 'package:warehouse/presentation/widgets/global_button.dart';
import 'package:warehouse/presentation/widgets/global_details_card.dart';
import 'package:warehouse/presentation/widgets/global_dialog.dart';
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
  final ScrollController mainScrollController = ScrollController();
  
  //late final PicklistBloc _picklistBloc;
  late String picklistId;

  @override
  void initState() {
    super.initState();

    picklistId = widget.picklistId;
    
    //_picklistBloc = BlocProvider.of<PicklistBloc>(context);
    //_picklistBloc.add(PicklistEvent.selectPickList(picklistId));
  }

  @override
  Widget build(BuildContext context){
    return BlocListener<PicklistBloc, PicklistState>(
      listener: (context, state) async {
        if (state.deletePicklistSucceeded) {
          FloatingSnackBar(message: 'Successfully deleted.', context: context);
          
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state.picklistDetails.picklist.id != '') {
          debugPrint('PicklistDetails loaded: ${state.picklistDetails.picklist.id}');
        }
        if(state.isLoading){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
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
          builder: (context, state) {
            final _picklistBloc = BlocProvider.of<PicklistBloc>(context);
            return Stack(
              children: [
                Column(
                  children: [
                    Breadcrumb(paths: ['Picklist Allotment', picklistId]),
                    Expanded(
                      child: RawScrollbar(
                        radius: Radius.circular(12),
                        thickness: 8,
                        thumbColor: biruImran2,
                        thumbVisibility: true,
                        controller: mainScrollController,
                        child: SingleChildScrollView(
                          controller: mainScrollController,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .98,
                            child: Column(
                              children: [
                            
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
                                ),
                                                    
                                SizedBox(height: 180,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: state.picklistDetails.picklist.status == 'opened' ? [
                          Button(onPressed: () async {
                            showDialog(context: context, builder: (context) {
                              return DialogActionConfirmation(
                                title: 'Send $picklistId for Picking',
                                notice: 'This will update $picklistId status from ${state.picklistDetails.picklist.status} to SendForPicking.'
                              );
                            }).then((v) async {
                              if (v) {
                                await _picklistBloc.process(PicklistEvent.setPicklistSendForPicking(picklistId: picklistId));
                      
                                if (state.setPicklistSendForPickingSucceeded) {
                                  FloatingSnackBar(message: 'Successfully send for picking.', context: context);
                                } else {
                                  final error = state.error!;
                                  debugPrint("Error: $error");
                                  FloatingSnackBar(message: 'Error: $error', context: context);
                      
                                }
                      
                              }
                            });
                          }, title: 'Send for Picking',),
                      
                          SizedBox(height: 12,),
                      
                          Button(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogActionConfirmation(
                                    title: 'Delete $picklistId',
                                    notice: 'This will remove $picklistId and this action is irreversible.',
                                    buttonConfirmText: 'Delete',
                                    warning: true,
                                  );
                                },
                              ).then((confirmed) {
                                if (confirmed == true) {
                                  context.read<PicklistBloc>().add(
                                    PicklistEvent.deletePicklist(picklistId: picklistId),
                                  );
                                }
                              });
                            },
                            title: 'Delete Picklist',
                            warning: true,
                          )

                      
                        ] : state.picklistDetails.picklist.status == 'sent for picking' ? [
                      
                          Button(onPressed: () {
                            showDialog(context: context, builder: (context) {
                              return DialogActionConfirmation(
                                title: 'Pack $picklistId',
                                notice: 'This will update $picklistId status from ${state.picklistDetails.picklist.status} to DonePacking.'
                              );
                            }).then((v) async {
                              if (v) {
                                await _picklistBloc.process(PicklistEvent.setPicklistPackAll(picklistId: picklistId));
                                
                                if (state.setPicklistPackAllSucceeded) {
                                  FloatingSnackBar(message: 'Successfully packed.', context: context);
                                  
                                } else {
                                  final error = state.error!;
                                  debugPrint("Error: $error");
                                  FloatingSnackBar(message: 'Error: $error', context: context);
                      
                                }
                      
                              }
                            });
                          }, title: 'Pack'),
                      
                        ] : [],
                      ),
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