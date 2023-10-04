import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_fast_touch/flame_fast_touch.dart';
import 'package:flutter/material.dart';

const componentsCount = 2000000;

class TapCallbacksMultipleExample extends FlameGame with FastTouch {
  static const String description = '''
    This example do the same thing as tap_callbacks_example, but with big count
    of non-interactive components at background. In such cause you will 
    experience a freeze while tapping anywhere on screen because of scanning
    all component tree.
    The example shows a way to avoid this freeze: 
    1. Place all components into game's world or camera's viewport or 
       viewfinder. This is important requirement!
    2. Place all interactive components into special grouping component.
    3. Assign this component to `componentsAtPointRoot` variable of FlameGame.
    4. Place all other components anywhere you want
    This steps makes `componentsAtPoint` function to search only 
    `componentsAtPointRoot` children and skip looping over other tree branches.
  ''';

  @override
  Future<void> onLoad() async {
    final interactiveComponents = Component();
    interactiveComponents.add(TappableSquare()..anchor = Anchor.center);

    final bottomSquare = TappableSquare()..y = 350;
    interactiveComponents.add(bottomSquare);
    world.add(interactiveComponents);

    final updateTreeDisabled = ComponentNoTreeUpdate();
    for (var i = 1; i < componentsCount; i++) {
      updateTreeDisabled.add(Component());
    }
    world.add(updateTreeDisabled);

    camera.moveTo(bottomSquare.position + Vector2(0, -50));

    componentsAtPointRoot = interactiveComponents;
  }
}

class TapCallbacksVanillaExample extends FlameGame {
  static const String description = '''
    This is vanilla version of touch handling. You should experience a freeze
    while touching screen at any point. 
  ''';

  @override
  Future<void> onLoad() async {
    add(TappableSquare()..anchor = Anchor.center);
    add(TappableSquare()..y = 350);

    final updateTreeDisabled = ComponentNoTreeUpdate();
    for (var i = 1; i < componentsCount; i++) {
      updateTreeDisabled.add(Component());
    }
    add(updateTreeDisabled);
  }
}

class TappableSquare extends PositionComponent
    with TapCallbacks, HasGameReference<TapCallbacksMultipleExample> {
  static final Paint _white = Paint()..color = const Color(0xFFFFFFFF);
  static final Paint _grey = Paint()..color = const Color(0xFFA5A5A5);

  bool _beenPressed = false;

  TappableSquare({
    Vector2? position,
  }) : super(
          position: position ?? Vector2.all(100),
          size: Vector2.all(100),
        );

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _beenPressed ? _white : _grey);
  }

  @override
  void onTapUp(_) {
    _beenPressed = false;
  }

  @override
  void onTapDown(_) {
    _beenPressed = true;
    angle += 1.0;
  }

  @override
  void onTapCancel(_) {
    _beenPressed = false;
  }
}

class ComponentNoTreeUpdate extends Component {
  @override
  void updateTree(double dt) {}

  @override
  void renderTree(Canvas canvas) {}
}

class TwoPane extends StatelessWidget {
  const TwoPane({super.key, required this.gameLeft, required this.gameRight});

  final FlameGame gameLeft;
  final FlameGame gameRight;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Column(
          children: [
            const Center(
                child: Text(
                    'Performance comparison of touch events'
                    ' processing algorithms when game contains a lot of '
                    'components.\n'
                    'Current count of components: $componentsCount',
                    style: TextStyle(
                      fontSize: 16,
                    ))),
            Row(children: [
              Column(children: [
                const Text('Vanilla Flame',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 600,
                  width: 400,
                  child: GameWidget(game: gameLeft),
                ),
              ]),
              const VerticalDivider(width: 10),
              Column(
                children: [
                  const Text('Fast Touch plugin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 600,
                    width: 400,
                    child: GameWidget(game: gameRight),
                  ),
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }
}

void main(List<String> args) async {
  runApp(TwoPane(
    gameLeft: TapCallbacksVanillaExample(),
    gameRight: TapCallbacksMultipleExample(),
  ));
}
