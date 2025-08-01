
import 'package:flutter/material.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist_event.dart';
import 'package:warehouse/presentation/blocs/picklist/picklist_state.dart';

import '../base/reducer.dart';

class PicklistReducer extends Reducer<PicklistEvent, PicklistState> {
  @override
  PicklistState reduce(PicklistEvent newEvent, PicklistState currentState) {
    return currentState.copyWith(
      isLoading: newEvent.maybeWhen(
        setup: (_) => true,
        refresh: () => true,
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

        selectStatus: (_) => true,

        orElse: () => currentState.isLoading,
      ),

      searchId: newEvent.maybeWhen(
        searchPicklistById: (searchId) => searchId,
        refresh: () => '',
        orElse: () => currentState.searchId,
      ),

      status: newEvent.maybeWhen(
        selectStatus: (status) => status,
        refresh: () => '',
        orElse: () => currentState.status,
        
      ),

      picklist: newEvent.maybeWhen(
        loadPickList: (picklist) => picklist,
        refresh: () => [],
        orElse: () => currentState.picklist,
      ),

      currentPage: newEvent.maybeWhen(
        updatePage: (currentPage) => currentPage,
        searchPicklistById: (_) => 1,
        orElse: () => currentState.currentPage),

      count: newEvent.maybeWhen(
        loadCount : (count) => count,
        refresh: () => 1,
        orElse: () => currentState.count,
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
        deletePicklistSucceeded: () {
          debugPrint('REDUCER DELETE TRUEEEEEE');
          return true;
          },  
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