// ignore: deprecated_extends_function
class GlobalDatae {
  static var absent = 0;
  add(){
    absent++;
  }
  sub(){
    if(absent > 0)absent--;
  }
   getAbsent(){
    return absent;
    }
    setZero(){
    absent = 0;
    }
}
