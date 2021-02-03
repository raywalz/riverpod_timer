import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'timer.dart';

final timerProvider = StateNotifierProvider<TimerNotifier>(
  (ref) => TimerNotifier(),
);

// filter just changes to button state
final _buttonState = Provider<ButtonState>(
  (ref) => ref.watch(timerProvider.state).buttonState,
);

// create provider for just button state changes
final buttonProvider = Provider<ButtonState>(
  (ref) => ref.watch(_buttonState),
);

// filter just changes to timeLeft state
final _timeLeftProvider = Provider<String>(
  (ref) => ref.watch(timerProvider.state).timeLeft,
);

// create provider for just timeLeft state changes
final timeLeftProvider = Provider<String>(
  (ref) => ref.watch(_timeLeftProvider),
);

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building MyHomePage');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerTextWidget(),
            SizedBox(height: 20),
            ButtonsContainer(),
          ],
        ),
      ),
    );
  }
}

class TimerTextWidget extends HookWidget {
  const TimerTextWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final timeLeft = useProvider(timeLeftProvider);
    return Text(
      timeLeft,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}

class ButtonsContainer extends HookWidget {
  const ButtonsContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building ButtonsContainer');
    final state = useProvider(buttonProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state == ButtonState.initial) ...[
          StartButton(),
        ],
        if (state == ButtonState.started) ...[
          PauseButton(),
          SizedBox(width: 20),
          ResetButton(),
        ],
        if (state == ButtonState.paused) ...[
          StartButton(),
          SizedBox(width: 20),
          ResetButton(),
        ],
        if (state == ButtonState.finished) ...[
          ResetButton(),
        ],
      ],
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read(timerProvider).start();
      },
      child: Icon(Icons.play_arrow),
    );
  }
}

class PauseButton extends StatelessWidget {
  const PauseButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read(timerProvider).pause();
      },
      child: Icon(Icons.pause),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read(timerProvider).reset();
      },
      child: Icon(Icons.replay),
    );
  }
}
