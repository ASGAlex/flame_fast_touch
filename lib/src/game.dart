import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_fast_touch/flame_fast_touch.dart';

mixin FastTouch<W extends World> on FlameGame<W> {
  /// Grouping component which contains all interactive components, that should
  /// react on tap events, drag events and so on.
  ///
  /// The component prevents `componentsAtPoint` looping over whole components
  /// tree. Instead, only  `componentsAtPointRoot` subtree will be scanned.
  /// This helps framework to react on touch events faster by excluding
  /// unnecessary components from process.
  ///
  /// The component can be changed at any time. It should be mounted to make
  /// thinks work, otherwise `componentsAtPoint` behavior will fallback to
  /// scanning whole components tree. This also will happen if component is
  /// null, and this is default behavior.
  Component? componentsAtPointRoot;

  @override
  Iterable<Component> componentsAtPoint(
    Vector2 point, [
    List<Vector2>? nestedPoints,
    List<Component>? ancestors,
  ]) sync* {
    if (componentsAtPointRoot != null && componentsAtPointRoot!.isMounted) {
      final ancestorsOfRoot =
          componentsAtPointRoot!.ancestors(includeSelf: true).toList();
      ancestorsOfRoot.removeLast(); // remove game component
      for (final child in children.reversed()) {
        Vector2? childPoint = point;
        if (child is CoordinateTransform) {
          childPoint = (child as CoordinateTransform).parentToLocal(point);
        }
        if (childPoint != null) {
          if (child is CameraComponent) {
            yield* child.componentsAtPointFast(
                childPoint, nestedPoints, ancestorsOfRoot);
          } else {
            yield* child.componentsAtPointFast(
                childPoint, nestedPoints, ancestorsOfRoot);
          }
        }
      }
    } else {
      yield* componentsAtPointFast(point, nestedPoints, ancestors);
    }
  }
}
