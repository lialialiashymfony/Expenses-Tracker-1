class Endpoints {
  static const String baseURL =
      "https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1";

  static const String baseURLLive = 'https://simobile.singapoly.com';

  static const String news = "$baseURL/news";
  static const String datas = "$baseURLLive/api/datas";

  //uts
  static const String baseURLuts = 'https://simobile.singapoly.com';
  static const String datasuts = "$baseURLuts/api/customer-service";
  static const String dataNIM = "$datasuts/2215091033";

  //balance
  static const String balance = "$baseURLLive/api/balance/2215091033";
  static const String spending = "$baseURLLive/api/spending/2215091033";
}
