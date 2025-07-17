
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
        orElse: () => currentState.isLoading,
      ),
      picklist: newEvent.maybeWhen(
        loadPickList: (picklist) => picklist,
        orElse: () => currentState.picklist,
      ),
    );
  }
}