class Address {
  String sgg_cd = '';  // 180,
  String emdong_cd = ''; // 510",
  String addr_en = ''; // Gasan-dong Geumcheon-gu Seoul",
  String full_addr = ''; // 서울특별시 금천구 가산동",
  String sido_nm = ''; // 서울특별시",
  String sgg_nm = ''; // 금천구",
  String emdong_nm = ''; // 가산동",
  String sido_cd = ''; // 11"

  Address();

  Address.fromJson(Map<String, dynamic> json) {
    sgg_cd = json['sgg_cd'];
    emdong_cd = json['emdong_cd'];
    addr_en = json['addr_en'];
    full_addr = json['full_addr'];
    sido_nm = json['sido_nm'];
    sgg_nm = json['sgg_nm'];
    emdong_nm = json['emdong_nm'];
    sido_cd = json['sido_cd'];
  }

  String cutFullAddr() {
    return full_addr.replaceAll(sido_nm, '');
  }
}