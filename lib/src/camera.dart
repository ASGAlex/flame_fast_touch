// ignore_for_file: invalid_use_of_internal_member

import 'package:flame/components.dart';
import 'package:flame_fast_touch/src/component.dart';

extension AtPointCamera on CameraComponent {
  Iterable<Component> componentsAtPointFast(
    Vector2 point, [
    List<Vector2>? nestedPoints,
    List<Component>? ancestors,
  ]) sync* {
    final viewportPointOutput = Vector2.zero();
    final viewportPoint =
        viewport.globalToLocal(point, output: viewportPointOutput);

    if (ancestors != null && ancestors.isNotEmpty) {
      final currentAncestor = ancestors.removeLast();
      if (currentAncestor == viewport) {
        yield* viewport.componentsAtPointFast(
          viewportPoint,
          nestedPoints,
          ancestors.toList(),
        );
      } else if ((currentAncestor == world || currentAncestor == viewfinder) &&
          (world?.isMounted ?? false) &&
          CameraComponent.currentCameras.length <
              CameraComponent.maxCamerasDepth &&
          viewport.containsLocalPoint(viewportPoint)) {
        CameraComponent.currentCameras.add(this);
        final worldPoint = viewfinder.transform.globalToLocal(viewportPoint);
        if (currentAncestor == viewfinder) {
          yield* viewfinder.componentsAtPointFast(
            worldPoint,
            nestedPoints,
            ancestors.toList(),
          );
        } else {
          yield* world!.componentsAtPointFast(
            worldPoint,
            nestedPoints,
            ancestors.toList(),
          );
        }
        CameraComponent.currentCameras.removeLast();
      }
    } else {
      yield* viewport.componentsAtPointFast(viewportPoint, nestedPoints);
      if ((world?.isMounted ?? false) &&
          CameraComponent.currentCameras.length <
              CameraComponent.maxCamerasDepth) {
        if (viewport.containsLocalPoint(viewportPoint)) {
          CameraComponent.currentCameras.add(this);
          final worldPoint = viewfinder.transform.globalToLocal(viewportPoint);
          yield* viewfinder.componentsAtPoint(worldPoint, nestedPoints);
          yield* world!.componentsAtPoint(worldPoint, nestedPoints);
          CameraComponent.currentCameras.removeLast();
        }
      }
    }
  }
}
