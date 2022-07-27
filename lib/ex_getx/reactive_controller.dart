import 'package:get/get.dart';

//GetX에서 상태 관리를 위한 클래스를 생성할 때는 GetxController를 상속받아 구현
class ReactiveCountController extends GetxController {
  //여러 위젯에서 controller를 사용해야 하는 경우, 간단하게 getter로 접근하도록 할 수 있다.
  //ex) CountController.to.increment()
  static ReactiveCountController get to => Get.find();

  //GetX에서 반응형 상태 관리를 위해서는 상태를 Observable 하게 변경하여야 합니다.
  //변경 방법은 상태의 값 뒤에 .obs를 붙이는 것으로 끝이다.
  //주의할 점이 .obs의 경우 단순한 타입이 아닌 RxType이 되는 것이다.
  final count = 0.obs;

  void increment() {
    //반응형 상태 변수는 다음과 같은 두가지 방법으로 값을 변경할 수 있다.
    // count++;
    count.value++;
    // count(count.value + 1);

    //GetBuilder를 이용한 단순 상태 관리를 이용하는 경우 update()함수 필요하다.
    //setState()와 동일
    //Obx 사용시 update() 사용하지 않아도 된다.
    // update();
  }
}
