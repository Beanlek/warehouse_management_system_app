import 'package:flutter/foundation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/usecases/picklist/fetch_picklist_usecase.dart';
import 'package:warehouse/injection.dart';
import 'package:warehouse/presentation/blocs/base/base_bloc.dart';
import 'package:warehouse/presentation/blocs/base/reducer.dart';

import 'picklist.dart';

class PicklistBloc extends BaseBloc<PicklistEvent, PicklistState> {
  List<Picklist> picklist = [];

  @override
  Reducer<PicklistEvent, PicklistState> reducer = PicklistReducer();
  final FetchPickListUseCase _fetchPicklistUseCase;

  PicklistBloc()
      :  _fetchPicklistUseCase = getIt<FetchPickListUseCase>(),
        super(const PicklistState());

  @override
  void init() {
    process(Setup(''));
  }

  @override
  void processFeedback(PicklistEvent event, PicklistState state) async {
    event.maybeWhen(
        setup: (status) => _fetchPicklist(status ?? ''),
        orElse: () {});
  }

  _fetchPicklist(String status) async {
    await _fetchPicklistUseCase.execute(status).then((value) {
      value.maybeWhen(
          success: (result) {
            process(PicklistEvent.loadPickList(result));
          },
          orElse: () {});
    });
  }
}
