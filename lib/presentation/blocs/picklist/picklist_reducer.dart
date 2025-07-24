
import 'package:warehouse/presentation/blocs/picklist/picklist_event.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist_state.dart';

import '../base/reducer.dart';

class PicklistReducer extends Reducer<PicklistEvent, PicklistState> {
  @override
  PicklistState reduce(PicklistEvent newEvent, PicklistState currentState) {
    return currentState.copyWith(
      isLoading: newEvent.maybeWhen(
        setup: (_) => true,
        
        selectPickList: (_) => true,
        loadPickList: (_) => false,
        loadPickListDetails: (_) => false,

        deletePicklist: (_) => true,
        deletePicklistSucceeded: () => false,

        setPicklistSendForPicking: (_) => true,
        setPicklistSendForPickingSucceeded: () => false,

        setPicklistPackAll: (_) => true,
        setPicklistPackAllSucceeded: () => false,

        showPicklistError: (_) => false,

        orElse: () => currentState.isLoading,
      ),

      picklist: newEvent.maybeWhen(
        loadPickList: (picklist) => picklist,
        orElse: () => currentState.picklist,
      ),

      picklistDetails: newEvent.maybeWhen(
        loadPickListDetails: (picklistDetails) => picklistDetails,
        orElse: () => currentState.picklistDetails,
      ),

      deletePicklistProgress: newEvent.maybeWhen(
        deletePicklist: (_) => true,
        
        orElse: () => false
      ),
      deletePicklistSucceeded: newEvent.maybeWhen(
        deletePicklistSucceeded: () => true,
        
        orElse: () => false
      ),

      setPicklistSendForPickingProgress: newEvent.maybeWhen(
        setPicklistSendForPicking: (_) => true,
        
        orElse: () => false
      ),
      setPicklistSendForPickingSucceeded: newEvent.maybeWhen(
        setPicklistSendForPickingSucceeded: () => true,
        
        orElse: () => false
      ),

      setPicklistPackAllProgress: newEvent.maybeWhen(
        setPicklistPackAll: (_) => true,
        
        orElse: () => false
      ),
      setPicklistPackAllSucceeded: newEvent.maybeWhen(
        setPicklistPackAllSucceeded: () => true,
        
        orElse: () => false
      ),
    );
  }
}