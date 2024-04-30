class MicroDustValueStringUtil {

  static int getDustIndexValue(int value) {
    switch (value){
      case <= 8: return 1;
      case <= 15: return 2;
      case <= 20: return 3;
      case <= 25: return 4;
      case <= 37: return 5;
      case <= 50: return 6;
      case <= 75: return 7;
      case >= 76: return 8;
      default: return 0;
    }
  }
}