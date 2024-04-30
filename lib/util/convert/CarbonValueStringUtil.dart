class CarbonValueStringUtil {

  // 일산화탄소 상태
  static int getDustIndexValue(double value) {
    switch (value){
      case <= 1:  return 1;
      case <= 2:  return 2;
      case <= 5.5: return 3;
      case <= 9:  return 4;
      case <= 12: return 5;
      case <= 15: return 6;
      case <= 32: return 7;
      case > 32: return 8;
      default: return 0;
    }
  }
}