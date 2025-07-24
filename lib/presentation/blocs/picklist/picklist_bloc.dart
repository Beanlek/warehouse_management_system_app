import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/usecases/picklist/delete_picklist_usecase.dart';
import 'package:warehouse/domain/usecases/picklist/fetch_picklist_details_usecase.dart';
import 'package:warehouse/domain/usecases/picklist/fetch_picklist_usecase.dart';
import 'package:warehouse/domain/usecases/picklist/set_picklist_pack_all_usecase.dart';
import 'package:warehouse/domain/usecases/picklist/set_picklist_send_for_picking_usecase.dart';
import 'package:warehouse/injection.dart';
import 'package:warehouse/presentation/blocs/base/base_bloc.dart';
import 'package:warehouse/presentation/blocs/base/reducer.dart';

import 'picklist.dart';

class PicklistBloc extends BaseBloc<PicklistEvent, PicklistState> {
  List<Picklist> picklist = [];

  @override
  Reducer<PicklistEvent, PicklistState> reducer = PicklistReducer();
  final FetchPickListUseCase _fetchPicklistUseCase;
  final FetchPickListDetailsUseCase _fetchPicklistDetailsUseCase;
  final DeletePicklistUsecase _deletePicklistUsecase;
  final SetPicklistSendForPickingUsecase _setPicklistSendForPickingUsecase;
  final SetPicklistPackAllUsecase _setPicklistPackAllUsecase;

  PicklistBloc() :
    _fetchPicklistUseCase = getIt<FetchPickListUseCase>(),
    _fetchPicklistDetailsUseCase = getIt<FetchPickListDetailsUseCase>(),
    _deletePicklistUsecase = getIt<DeletePicklistUsecase>(),
    _setPicklistSendForPickingUsecase = getIt<SetPicklistSendForPickingUsecase>(),
    _setPicklistPackAllUsecase = getIt<SetPicklistPackAllUsecase>(),
    super(const PicklistState());

  @override
  void init() {
    process(Setup(''));
  }

  @override
  void processFeedback(PicklistEvent event, PicklistState state) async {
    event.maybeWhen(
        setup: (status) => _fetchPicklist(status ?? ''),
        selectPickList: (picklistId) => _fetchPicklistDetails(picklistId),
        deletePicklist: (picklistId) => _deletePicklist(picklistId),
        setPicklistSendForPicking: (picklistId) => _setPicklistSendForPicking(picklistId),
        setPicklistPackAll: (picklistId) => _setPicklistPackAll(picklistId),
        
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

  _fetchPicklistDetails(String picklistId) async {
    await _fetchPicklistDetailsUseCase.execute(picklistId).then((value) {
      value.maybeWhen(
          success: (result) {
            process(PicklistEvent.loadPickListDetails(result));
          },
          orElse: () {});
    });
  }

  _deletePicklist(String picklistId) async {
    final _deletePicklistParams = DeletePicklistParams(picklistId: picklistId);
    
    await _deletePicklistUsecase.execute(_deletePicklistParams).then((response) {
      if (response.result) {
        process(PicklistEvent.deletePicklistSucceeded());
      } else {
        process(PicklistEvent.showPicklistError(
          response.errorMessage ?? 'Password reset failed')
        );
      }
      
    });
  }

  _setPicklistSendForPicking(String picklistId) async {
    final _setPicklistSendForPickingParams = SetPicklistSendForPickingParams(picklistId: picklistId);
    
    await _setPicklistSendForPickingUsecase.execute(_setPicklistSendForPickingParams).then((response) {
      if (response.result) {
        process(PicklistEvent.setPicklistSendForPickingSucceeded());
      } else {
        process(PicklistEvent.showPicklistError(
          response.errorMessage ?? 'Password reset failed')
        );
      }

    });
  }

  _setPicklistPackAll(String picklistId) async {
    final _setPicklistPackAllParams = SetPicklistPackAllParams(picklistId: picklistId);
    
    await _setPicklistPackAllUsecase.execute(_setPicklistPackAllParams).then((response) {
      if (response.result) {
        process(PicklistEvent.setPicklistPackAllSucceeded());
      } else {
        process(PicklistEvent.showPicklistError(
          response.errorMessage ?? 'Password reset failed')
        );
      }

    });
  }
}
