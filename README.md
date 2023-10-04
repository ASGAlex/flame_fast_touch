## Features

Currently Flame works very slow with touch events in games with big count
of components. There is no any workaround in the framework itself to solve
this problem.

This library is one of possible fast solutions to make your touch-input
fast again.

You can compare vanilla performance with this library by playing with
this example: https://asgalex.github.io/flame_fast_touch/
Probably you will wait a minute while it loads because about 2000000*2
components should be loaded into game, it does not work too fast in browsers.

## Getting started

There are some strict requirements you should to follow to make everything
work:

1. All components should be added into game's `world` component and it's
   descendants. Not in game directly!
2. Non-interactive components should be separated from interactive components
   and settled into different parent components.

After that, you will be able to use game's special variable
`componentsAtPointRoot`, which limits Framework to only one component, where
it should search for tappable/draggable and other components in cause of touch
event. The `componentsAtPointRoot` could be changed at any time if you need to
interact a component set from another branch of components tree. It even could
be set to `null` in cause you need to fall back into default Flame's behavior.

## Usage examples

A minimal working code example is [here](example/lib/main.dart), look at
`TapCallbacksMultipleExample` class. 