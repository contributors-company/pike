
# Pike

![Pub Version](https://img.shields.io/pub/v/pike)
![License](https://img.shields.io/github/license/contributors-company/pike)
![Issues](https://img.shields.io/github/issues/contributors-company/pike)
![Coverage](https://img.shields.io/codecov/c/github/contributors-company/pike)
![Stars](https://img.shields.io/github/stars/contributors-company/pike)

`Pike` is a state management library for Flutter based on the **Event-Driven** pattern. It uses event streams to manage state and provides convenient components for interacting with the state, such as `PikeBuilder`, `PikeConsumer`, and `PikeProvider`.

## Features

- **State management using events**: The state is updated in response to events.
- **Components for listening to and displaying state**: `PikeBuilder`, `PikeConsumer`, and `PikeProvider` are used to manage and display state changes.
- **Customizable event handling**: Allows for custom event handlers and selective state rebuilds.

## Installation

Add `pike` to your `pubspec.yaml` file:

```yaml
dependencies:
  pike: ^latest_version
```

## Usage

### Creating a Pike instance

Create a `Pike` instance by passing an initial state:

```dart
final class MockPike extends Pike<Event, State> {
  MockPike() : super(InitialState()) {
    on<Event>((event, emit) => switch(event) {
      FetchEvent() => _callback(event, emit),
      FetchWithExceptionEvent() => _callbackA(event, emit),
    });

  }

  Future<void> _callback(FetchEvent event, Emit<State> emit) async {
    emit(LoadedState());
  }

  void _callbackA(FetchWithExceptionEvent event, Emit<State> emit) {
    emit(ExceptionState());
  }
}

// Events

sealed class Event {}

class FetchEvent extends Event {}

class FetchWithExceptionEvent extends Event {}

// States

sealed class State {}

class InitialState extends State {}

class LoadedState extends State {}

class ExceptionState extends State {}
```

### Adding events

Add events to the `Pike` instance to trigger state changes:

```dart
pike.add(MyEvent());
```

### Listening to state changes

Use `PikeBuilder` or `PikeConsumer` to rebuild your widgets when the state changes:

```dart
PikeBuilder<MyPike, MyState>(
  builder: (context, state) {
    return Text('Current State: $state');
  },
);
```

### Providing the Pike instance

Wrap your widget tree with `PikeProvider` to provide the `Pike` instance to the widgets:

```dart
PikeProvider<MyPike>(
  pike: pike,
  child: MyWidget(),
);
```

### Custom event handling with `PikeObserver`

You can implement `PikeObserver` to track the lifecycle and events of your `Pike` instances:

```dart
class MyPikeObserver extends PikeObserver {
  @override
  void onCreate<P extends Pike<Object?, Object?>>(P pike) {
    print("Pike created");
  }

  @override
  void onEvent<P extends Pike<Object?, Object?>, Event>(
    P pike,
    Event event,
  ) {
    print("Event occurred: $event");
  }
}
```

## Components

### `PikeBuilder`

A widget that listens to state changes and rebuilds when the state updates.

```dart
PikeBuilder<MyPike, MyState>(
  builder: (context, state) {
    return Text('Current State: $state');
  },
);
```

### `PikeConsumer`

A widget that listens to state changes and provides a custom listener to trigger side effects.

```dart
PikeConsumer<MyPike, MyState>(
  builder: (context, state) {
    return Text('Current State: $state');
  },
  listener: (context, state) {
    // Handle side effects here
  },
);
```

### `PikeProvider`

A widget that provides a `Pike` instance to its descendants.

```dart
PikeProvider<MyPike>(
  pike: pike,
  child: MyWidget(),
);
```

## Codecov

