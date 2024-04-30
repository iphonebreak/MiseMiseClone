class NitrogenValueStringUtil {

  // 이산화질소 상태
  static int getDustIndexValue(double value) {
    switch (value){
      case <= 0.02: return 1;
      case <= 0.03: return 2;
      case <= 0.05: return 3;
      case <= 0.06: return 4;
      case <= 0.13: return 5;
      case <= 0.2:  return 6;
      case <= 1.1:  return 7;
      case > 1.1:  return 8;
      default: return 0;
    }
  }
}