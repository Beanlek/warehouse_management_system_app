import 'package:bloc/bloc.dart';
import 'package:warehouse/presentation/blocs/base/reducer.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(State initialState) : super(initialState) {
    on<Event>((event, emit) {
      var newState = reducer.reduce(event, state);
      if (newState != state) {
        emit(newState);
      }
      processFeedback(event, state);
    });
    init();
  }

  abstract Reducer<Event, State> reducer;

  void init();

  void processFeedback(Event event, State state);

  process(Event event) {
    add(event);
  }
}
