import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist.dart';

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

  @override
  void initState() {
    super.initState();
    
    _picklistBloc = BlocProvider.of<PicklistBloc>(context);
    _picklistBloc.add(PicklistEvent.selectPickList(widget.picklistId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PicklistBloc, PicklistState>(
      bloc: _picklistBloc,
      builder: (context, state) {
        
        return Scaffold(
          body: Center(child: Text(
            state.picklistDetails.picklist.id
          ),),
        );
      },
    );
  }
}