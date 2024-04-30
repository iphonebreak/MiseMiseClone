class SulfurValueStringUtil {

  // 이황산가스 상태
  static int getDustIndexValue(double value) {
    switch (value){
      case <= 0.01: return 1;
      case <= 0.02: return 2;
      case <= 0.04: return 3;
      case <= 0.05: return 4;
      case <= 0.1:  return 5;
      case <= 0.15: return 6;
      case <= 0.6:  return 7;
      case > 0.6:  return 8;
      default: return 0;
    }
  }
}