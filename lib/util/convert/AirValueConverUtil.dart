import 'package:misemise/util/convert/CarbonValueStringUtil.dart';
import 'package:misemise/util/convert/DustValueStringUtil.dart';
import 'package:misemise/util/convert/SulfurValueStringUtil.dart';

import 'MicroDustValueStringUtil.dart';
import 'NitrogenValueStringUtil.dart';
import 'OzonValueStringUtil.dart';

class AirValueConvertUtil {

  static int getAirDustIndexValue(int type, String value) {
    if (value.trim().isEmpty || value.trim() == '-'){
      return 0; // 데이터가 없을 경우, 측정소에 문제가 있는 경우
    }

    switch (type) {
      case 0:
        return DustValueStringUtil.getDustIndexValue(int.parse(value));
      case 1:
        return MicroDustValueStringUtil.getDustIndexValue(int.parse(value));
      case 2:
        return OzoneValueStringUtil.getDustIndexValue(double.parse(value));
      case 3:
        return NitrogenValueStringUtil.getDustIndexValue(double.parse(value));
      case 4:
        return CarbonValueStringUtil.getDustIndexValue(double.parse(value));
      default:
        return SulfurValueStringUtil.getDustIndexValue(double.parse(value));
    }
  }
}