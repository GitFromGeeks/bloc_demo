import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

const names = [
  "foo",
  "bar",
  "baz",
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final btn = TextButton(
              onPressed: () => cubit.pickRandomName(),
              child: const Text("Pick a random name"));
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return btn;
            case ConnectionState.waiting:
              return btn;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ''),
                  btn,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}
