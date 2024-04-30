class DustValueStringUtil {

  // 미세먼지 상태
  static String getDustValue(int value) {
    switch (value){
      case 0:
        return '정보 없음';
      case <= 15:
        return '최고 좋음';
      case <= 30:
        return '좋음';
      case <= 40:
        return '양호';
      case <= 50:
        return '보통';
      case <= 75:
        return '나쁨';
      case <= 100:
        return '상당히 나쁨';
      case <= 150:
        return '매우 나쁨';
      default:
        return '최악';
    }
  }

  // 미세먼지 상태
  static String getConditionValue(int value) {
    switch (value){
      case 0:
        return "정보 없음";
      case <= 15:
        return "공기 상태 최고! 건강하세요!";
      case <= 30:
        return "신선한 공기 많이 마시세요~";
      case <= 40:
        return "쾌적한 날이에요~";
      case <= 50:
        return "그냥 무난한 날이에요~";
      case <= 75:
        return "공기가 탁하네요. 조심하세요~";
      case <= 100:
        return "탁한 공기, 마스크 챙기세요~";
      case <= 150:
        return "위험합니다! 외출을 삼가세요!";
      default:
        return "절대 나가지 마세요!";
    }
  }

  static int getDustIndexValue(int value) {
    switch (value){
      case 0:
        return 0;
      case <= 15:
        return 1;
      case <= 30:
        return 2;
      case <= 40:
        return 3;
      case <= 50:
        return 4;
      case <= 75:
        return 5;
      case <= 100:
        return 6;
      case <= 150:
        return 7;
      case > 150:
        return 8;
      default:
        return 0;
    }
  }
}