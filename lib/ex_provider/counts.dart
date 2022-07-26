import 'package:flutter/material.dart';

//Provider를 사용하기 위해 ChangeNotifier를 사용해 클래스 생성
//ChangeNotifier를 활용해 만든 클래스는 해당 객체 값으 변화를 감지 할 수 있음
//이렇게 변화를 지속적으로 감시해 변화가 발생했을 때 알 수 있는 것을 "구독"이라 표현함
class Counts with ChangeNotifier {
  //앱내 공유할 상태 변수 선언
  int _count = 0;
  int get count => _count;

  void add() {
    _count++;
    //변수가 수정되었음을 notifyListeners()를 통보하는 방식
    //Stateful Widget의 setState 함수를 사용하는것과 같은 원리
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
