import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counts.dart';

void main() {
  //현재는 Counts 위젯 하나만 provider로 제공하지만,
  //여러개의 provider를 한번에 제공하기 위해서는 MultiProvider를 사용한다.
  //모든 위젯에서 상태를 공유 할 수 있도록 최상위 공통 부모 위젯인 main에 provider를 설정
  runApp(MultiProvider(
    providers: [
      //ChangeNotifierProvider:  ChangeNotifier를 상속한 클래스로 만들어진 객체를 "제공"해주는 Provider
      ChangeNotifierProvider(create: (_) => Counts()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    debugPrint('main build');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Counter(),
            ChildWidget1(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Provider를 통해 Counts 위젯의 상태값을 읽도록 한다.
          //사실 nodifyListener()가 포함된 method를 호출한다면,
          //상태값을 변경한다는 의미도 포함된다.
          context.read<Counts>().add();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Counter');
    return Text(
      //Counts 위젯의 count 상태값이 변경되는 것을 감시하고 있다.
      //해당 상태값이 변경 된 경우, 해당 Counter 위젯이 rebuild 된다.
      context.watch<Counts>().count.toString(),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class ChildWidget1 extends StatelessWidget {
  const ChildWidget1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChildWidget1 build');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  context.read<Counts>().add();
                },
                child: const Text('Child Widget1')),
            const ChildWidget2(),
            const ChildWidget3(),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const ChildWidget4()
      ],
    );
  }
}

class ChildWidget2 extends StatelessWidget {
  const ChildWidget2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChildWidget2 build');
    return ElevatedButton(
        onPressed: () {
          context.read<Counts>().remove();
        },
        child: const Text('Child widget2'));
  }
}

class ChildWidget3 extends StatelessWidget {
  const ChildWidget3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChildWidget3 build');
    // 재밌는걸 발견했다. 이처럼 Provider.of<T>(context)를 사용하는 경우,
    // 원형을 살펴보면 provider.dart의 static T of<T>(BuildContext context, {bool listen = true}) 이기 때문에,
    // 해당 위젯이 listen 상태가 되어 provider 상태 변화시 rebuild가 된다.
    // 따라서 read 목적으로만 사용하는 위젯인 경우 listen:false가 필수이다.

    // final counter = Provider.of<Counts>(context);
    final counter = Provider.of<Counts>(context, listen: false);

    return ElevatedButton(
        onPressed: () {
          counter.reset();
          // 혹은 아래와 같이 한줄로 표시도 가능하다.
          // Provider.of<Counts>(context, listen: false).reset();
          // context.read<T>() 원형을 보면 그 자체로 listen: false로 구현이 되어 있다.
          // T read<T>() {
          //   return Provider.of<T>(this, listen: false);
          // }
          // context.read<Counts>().reset();
        },
        child: const Text('Reset Count'));
  }
}

class ChildWidget4 extends StatelessWidget {
  const ChildWidget4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChildWidget4 build');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //보통 Provider의 값을 변경하기 위한 함수는 read를 통해 접근하며,
        //상태값을 사용할 때에는 watch를 사용한다. 변경된 상태값을 표시하기 위해
        //listen 중인 위젯에 re-build가 발생하게 된다.
        //Provider 상태 중 특정 부분만을 감시하기 위한 방법으로 select를 사용할 수 있다.
        Text(context.select((Counts counts) => counts.count.toString())),
        ElevatedButton(
            onPressed: () {
              context.read<Counts>().add();
            },
            child: const Text('Child widget4')),
      ],
    );
  }
}
