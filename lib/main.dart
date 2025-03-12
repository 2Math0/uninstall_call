import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uninstall_call/classes.dart';

import 'firebase_options.dart';
import 'package:app_install_events/app_install_events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<IUEvent> _events = [];

  late AppIUEvents _appIUEvents;

  @override
  void initState() {
    _appIUEvents = AppIUEvents();

    _appIUEvents.appEvents.listen((event) {
      if (event.type == IUEventType.installed) {
        print('App installed: ${event.packageName}');
      } else {
        print('App uninstalled: ${event.packageName}');
        updateUninstallInfo('abdElGhani');
      }

      setState(() {
        _events.add(event);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _appIUEvents.dispose();
    super.dispose();
  }


  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await uploadNumberToRealtimeDB(_counter);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ListView.builder(
              itemCount: _events.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event.packageName),
                  subtitle: Text(event.type.toString()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _incrementCounter(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
