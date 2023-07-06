import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'dart:convert' as convert;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String bitcoinVal = '0';
  String ethVal = '0';
  String ltcVal = '0';

  // Android Dropdown
  DropdownButton androidPicker() {
    List<DropdownMenuItem<String>> dropList = [];

    for (String item in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(item), value: item);
      dropList.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropList,
      onChanged: (val) {
        setState(() {
          selectedCurrency = val!;
          getData('BTC', selectedCurrency);
          getData('ETH', selectedCurrency);
          getData('LTC', selectedCurrency);
        });
      },
    );
  }

  // Cupertino Picker
  CupertinoPicker getIosPicker() {
    List<Text> pickerList = [];
    for (String item in currenciesList) {
      pickerList.add(Text(item));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: pickerList);
  }

  void getData(String currency1, String currency2) async {
    CoinData coinData = CoinData();
    var res = await coinData.getCoinData(currency1, currency2);
    if (res.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(res.body);
      setState(() {
        if (currency1 == 'BTC'){
          bitcoinVal = jsonResponse['rate'].toStringAsFixed(0);
        }else if (currency1 == 'ETH'){
          ethVal =  jsonResponse['rate'].toStringAsFixed(0);
        }else{
          ltcVal = jsonResponse['rate'].toStringAsFixed(0);
        }
      });
      print(jsonResponse);
    } else {
      print(res.statusCode);
    }
  }

  @override
  void initState() {
    getData('BTC', selectedCurrency);
    getData('ETH', selectedCurrency);
    getData('LTC', selectedCurrency);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CoinCard(findingCurrency: 'BTC', val: bitcoinVal, selectedCurrency: selectedCurrency),
              CoinCard(findingCurrency: 'ETH', val: ethVal, selectedCurrency: selectedCurrency),
              CoinCard(findingCurrency: 'LTC', val: ltcVal, selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getIosPicker() : androidPicker()),
        ],
      ),
    );
  }
}



class CoinCard extends StatelessWidget {
  const CoinCard({
    Key? key,
    required this.findingCurrency,
    required this.val,
    required this.selectedCurrency,
  }) : super(key: key);

  final String findingCurrency;
  final String val;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $findingCurrency = $val $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
