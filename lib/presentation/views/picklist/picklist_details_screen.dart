import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist.dart';

class PicklistDetailsScreen extends StatefulWidget {
  const PicklistDetailsScreen({super.key});

  @override
  State<PicklistDetailsScreen> createState() => _PicklistDetailsScreenState();
}

class _PicklistDetailsScreenState extends State<PicklistDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PicklistBloc, PicklistState>(
      bloc: context.read<PicklistBloc>(),
      builder: (context, state) {
        debugPrint("PICKLIST ?? ${state.picklist}");
        return Scaffold(
          body: Center(child: Text(
            state.picklistDetails.picklist.id
          ),),
        );
      },
    );
  }
}