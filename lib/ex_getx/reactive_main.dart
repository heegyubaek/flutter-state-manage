import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_provider/ex_getx/reactive_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //GetX를 사용하기 위해 MaterialApp 대신 GetMaterialApp을 사용할 필요가 있다.
    //사실 Route기능을 사용하지 않고 단순 상태 관리 목적이라면 바꿀 이유는 없다.
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//GetX로 상태관리를 하는 경우 Stateful 위젯을 사용할 필요가 없다.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    debugPrint('main build');
    //GetX로 상태관리를 하기 위해서는 GetX로 만든 컨트롤러를 Get.put을 이용해
    //등록(Register)할 필요가 있다.
    final controller = Get.put(ReactiveCountController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            //반응형 상태값을 감시하고 사용하고자 하는 곳에 Obx() 블록으로 만들어 사용
            Obx(() {
              debugPrint("main Obx");
              return Text(
                //상태값을 이용시에는 .value 형태로 사용
                '${controller.count.value}',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
            ChildWidget1()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ChildWidget1 extends StatelessWidget {
  const ChildWidget1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChildWidget1 build');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            //controller에서 static 패턴을 제공하므로 자주, 여러 위젯에서 접근해야 한다면 다음과 같이 사용가능
            onPressed: ReactiveCountController.to.increment,
            child: const Text('Child Widget1')),
        //반응형 상태값을 감시하고 사용하고자 하는 곳에 Obx() 블록으로 만들어 사용
        Obx(() {
          debugPrint("ChildWidget1 Obx");
          return Text(
            '${ReactiveCountController.to.count}',
            style: Theme.of(context).textTheme.headline4,
          );
        }),
        ChildWidget2(),
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
        //Get.find<T>()를 이용해 controller instance를 얻어올수 있다.
        onPressed: Get.find<ReactiveCountController>().increment,
        child: Text('Child widget2'));
  }
}
