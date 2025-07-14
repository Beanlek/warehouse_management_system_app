abstract class Reducer<Event, State> {
  State reduce(Event newEvent, State currentState);
}
