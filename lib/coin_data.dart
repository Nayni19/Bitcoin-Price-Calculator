import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'api_key.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

String coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';


class CoinData {
  Future getCoinData(String currency1, String currency2) async {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var res = await ioClient
        .get(Uri.parse('$coinAPIURL/$currency1/$currency2?apikey=$apiKey'));
    return (res);
  }
}
