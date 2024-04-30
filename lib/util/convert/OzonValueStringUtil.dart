class OzoneValueStringUtil {

  // 오존 상태
  static int getDustIndexValue(double value) {
    switch (value){
      case <= 0.02: return 1;
      case <= 0.03: return 2;
      case <= 0.06: return 3;
      case <= 0.09: return 4;
      case <= 0.12: return 5;
      case <= 0.15: return 6;
      case <= 0.38: return 7;
      case > 0.38: return 8;
      default: return 0;
    }
  }
}