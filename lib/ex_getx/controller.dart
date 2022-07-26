import 'package:get/get.dart';

//GetX에서 상태 관리를 위한 클래스를 생성할 때는 GetxController를 상속받아 구현
class CountController extends GetxController {
  //여러 위젯에서 controller를 사용해야 하는 경우, 간단하게 getter로 접근하도록 할 수 있다.
  //ex) CountController.to.increment()
  static CountController get to => Get.find();

  int count = 0;

  void increment() {
    count++;
    //GetBuilder를 이용한 단순 상태 관리를 이용하는 경우 update()함수 필요하다.
    //setState()와 동일
    //Obx 사용시 update() 사용하지 않아도 된다.
    update();
  }
}
