import 'pair.dart';

extension ListExtension<L ,R> on List<L> {
  List<Pair<L, R>> innerJoin(List<R> right, bool Function(L, R) on) =>
      [for (var l in this) for (var r in right)  if (on(l, r)) Pair(l, r)];

  List<Pair<L, R?>> leftOuterJoin(List<R> right, bool Function(L, R) on) =>
      [for (var l in this) ..._defaultIfEmpty(l, [for (var r in right) if (on(l, r)) Pair(l, r)])];

  List<Pair<L, R?>> _defaultIfEmpty(L left, List<Pair<L, R>> list) =>
      list.isEmpty ? <Pair<L, R?>>[Pair(left, null)] : list;
}