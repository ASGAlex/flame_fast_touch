import 'package:flame/components.dart';

extension AtPointComponent on Component {
  Iterable<Component> componentsAtPointFast(
    Vector2 point, [
    List<Vector2>? nestedPoints,
    List<Component>? ancestors,
  ]) sync* {
    nestedPoints?.add(point);
    if (children.isNotEmpty) {
      if (ancestors != null && ancestors.isNotEmpty) {
        final ancestor = ancestors.removeLast();
        Vector2? childPoint = point;
        if (ancestor is CoordinateTransform) {
          childPoint = (ancestor as CoordinateTransform).parentToLocal(point);
        }
        if (childPoint != null) {
          yield* ancestor.componentsAtPointFast(
            childPoint,
            nestedPoints,
            ancestors.toList(),
          );
        }
      } else {
        for (final child in children.reversed()) {
          if (child is IgnoreEvents && child.ignoreEvents) {
            continue;
          }
          Vector2? childPoint = point;
          if (child is CoordinateTransform) {
            childPoint = (child as CoordinateTransform).parentToLocal(point);
          }
          if (childPoint != null) {
            yield* child.componentsAtPoint(childPoint, nestedPoints);
          }
        }
      }
    }

    final shouldIgnoreEvents =
        this is IgnoreEvents && (this as IgnoreEvents).ignoreEvents;
    if (containsLocalPoint(point) && !shouldIgnoreEvents) {
      yield this;
    }
    nestedPoints?.removeLast();
  }
}
