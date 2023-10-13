Without special tweaks the Flame works very slow with touch events in games with big count
of components. 

This is an alternative approach to Flame's slow processing of touch events problem.
Since Flame 1.10.0 the `IgnoreEvents` mixin become available, it allows you to skip events
processing for subtree of components of such mixin. 
The disadvantage of such approach is that you should to place such mixins to every possible tree 
root that could not process events. It might be hard to remember all branches of component tree so 
you could still have an performance losses. 
This library does not require any mixins (but supports Flame's ones) and allows you to specify 
directly the root of subtree which descendants will process any touch events. 

## Features

This library is one of possible fast solutions to make your touch-input
fast again.

You can compare vanilla performance with this library by playing with
this example: https://asgalex.github.io/flame_fast_touch/
Probably you will wait a minute while it loads because about 2000000*3
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