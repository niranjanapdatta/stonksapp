import 'package:flutter/material.dart';
import 'package:stonksapp/Models/SymbolModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Widgets/TextFieldForForm.dart';

import './HomePage.dart';

class AddSymbolPage extends StatefulWidget {
  final bool isAdmin;
  final SymbolModel symbolData;

  AddSymbolPage(this.isAdmin, {this.symbolData});

  @override
  _AddSymbolPageState createState() => _AddSymbolPageState();
}

class _AddSymbolPageState extends State<AddSymbolPage> {
  static const String default_symbol = "NIFTY";
  static const String default_series = "EQ";
  static const String default_about = "-";
  FocusNode _symbolFocus;
  String response, responseAdded;

  String _validationErrorText = "Error";
  String _validationErrorTextMarketStandard = "No such index/ symbol";
  bool _isSwitched = false;
  bool _validateSymbol = true;
  bool _validateMarketStandard = true;
  bool _editMode = false;
  bool isApiLoading = false;
  TextEditingController _symbolController,
      _nameController,
      _marketStandardController,
      _expenseRatioController,
      _dividendController,
      _seriesController,
      _aboutController;

  void initState() {
    super.initState();

    _symbolFocus = FocusNode();

    _symbolController = TextEditingController();
    _nameController = TextEditingController();
    _marketStandardController = TextEditingController();
    _expenseRatioController = TextEditingController();
    _dividendController = TextEditingController();
    _seriesController = TextEditingController();
    _aboutController = TextEditingController();

    if (widget.symbolData != null) {
      _editMode = true;
      _symbolController.text = widget.symbolData.symbolName;
      _nameController.text = widget.symbolData.name;
      _marketStandardController.text = widget.symbolData.marketStandard;
      _expenseRatioController.text = widget.symbolData.expenseRatio.toString();
      _dividendController.text = widget.symbolData.dividend.toString();
      _seriesController.text = widget.symbolData.series;
      _aboutController.text = widget.symbolData.about;
      _isSwitched = widget.symbolData.isIndex;
    }
  }

  // void _toggleSwitch(bool value) {
  //   if (_isSwitched == false) {
  //     setState(() {
  //       _isSwitched = true;
  //     });
  //   } else {
  //     setState(() {
  //       _isSwitched = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TO DO: Add input field for Underlying Asset for ETFs
      appBar: AppBar(
        title: Text(_editMode
            ? "Edit ${widget.symbolData.symbolName} Details"
            : "Add Symbol Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              _editMode ? "Edit Symbol" : "Add Symbol",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            _editMode
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 20),
                    child: TextField(
                      controller: _symbolController,
                      autofocus: true,
                      focusNode: _symbolFocus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "SYMBOL",
                        errorText:
                            _validateSymbol ? null : _validationErrorText,
                      ),
                    ),
                  ),
            TextFieldForForm("Name of Company/ Fund", 1, _nameController),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 10),
            //       child: Text(
            //         "Is it a Market Standard?",
            //         style: TextStyle(fontSize: 17),
            //       ),
            //     ),
            //     Switch(
            //       onChanged: _toggleSwitch,
            //       value: _isSwitched,
            //     ),
            //   ],
            // ),
            // _isSwitched
            //     ? Container()
            //     : TextFieldForForm(
            // "Market Standard", 1, _marketStandardController),
            _editMode
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 20),
                    child: TextField(
                      controller: _marketStandardController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Market Standard",
                        errorText: _validateMarketStandard
                            ? null
                            : _validationErrorTextMarketStandard,
                      ),
                    ),
                  ),
            TextFieldForForm("Expense Ratio(0-1)", 1, _expenseRatioController),
            TextFieldForForm("Dividend(0-1/ Share)", 1, _dividendController),
            // TextFieldForForm("Series", 1, _seriesController),
            TextFieldForForm("About the Company/ Fund", 5, _aboutController),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 20),
              child: Text(
                "Note: SYMBOL and Market Standard cannot be updated once set.",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isApiLoading
                    ? Text(
                        "Please wait for a moment....",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : ElevatedButton(
                        child: Text(_editMode ? "Save Symbol" : "Add Symbol"),
                        onPressed: () => _editMode
                            ? _editSymbolAction()
                            : _addSymbolAction(),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addSymbolAction() { // TO DO: Do not allow use of Tab in form fields(\t)
    _validateSymbol = true;
    _validateMarketStandard = true;

    if (_symbolController.text.isEmpty) {
      setState(() {
        _validateSymbol = false;
        _validationErrorText = "SYMBOL is required";
      });
      _symbolFocus.requestFocus();
    } else if (_symbolController.text.contains(' ')) {
      setState(() {
        _validateSymbol = false;
        _validationErrorText =
            "SYMBOL should not contain spaces";
      });
      _symbolFocus.requestFocus();
    } else {
      setState(() {
        _validateSymbol = true;
        isApiLoading = true;
      });
      Api.addSymbol(SymbolModel(
        symbolName: _symbolController.text.toUpperCase(),
        name: _nameController.text.isEmpty
            ? _symbolController.text.toUpperCase()
            : _nameController.text,
        isIndex: _isSwitched,
        marketStandard: _isSwitched
            ? _symbolController.text.toUpperCase()
            : _marketStandardController.text.isEmpty
                ? default_symbol
                : _marketStandardController.text,
        expenseRatio: _expenseRatioController.text.isEmpty
            ? 0
            : double.parse(_expenseRatioController.text),
        dividend: _dividendController.text.isEmpty
            ? 0
            : double.parse(_dividendController.text),
        series: _seriesController.text.isEmpty
            ? default_series
            : _seriesController.text,
        about: _aboutController.text.isEmpty
            ? default_about
            : _aboutController.text,
      )).then((res) => setState(() {
            responseAdded = res;
            isApiLoading = false;
            if (responseAdded != null) {
              if (responseAdded == "success") {
                Navigator.pop(
                  context,
                );
                Navigator.pop(
                  context,
                );
                Navigator.pop(
                  context,
                );
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage(widget.isAdmin)));

                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             AddSymbolPage(widget.isAdmin)));
              } else if (responseAdded == "standard") {
                _validateMarketStandard = false;
              } else if (responseAdded == "exists") {
                _validateSymbol = false;
                _validationErrorText = "SYMBOL already exists";
              } else if (responseAdded == "failed") {
                _validateSymbol = false;
                _validationErrorText = "SYMBOL not found";
              }
            }
          }));
    }
  }

  void _editSymbolAction() {
    _validateSymbol = true;
    _validateMarketStandard = true;

    if (_symbolController.text.isEmpty) {
      setState(() {
        _validateSymbol = false;
        _validationErrorText = "SYMBOL is required";
      });
      _symbolFocus.requestFocus();
    } else if (_symbolController.text.contains(' ')) {
      setState(() {
        _validateSymbol = false;
        _validationErrorText =
            "SYMBOL should not contain spaces";
      });
      _symbolFocus.requestFocus();
    } else {
      setState(() {
        _validateSymbol = true;
      });
      Api.editSymbol(SymbolModel(
        symbolName: _symbolController.text.toUpperCase(),
        name: _nameController.text.isEmpty
            ? _symbolController.text.toUpperCase()
            : _nameController.text,
        isIndex: _isSwitched,
        marketStandard: _isSwitched
            ? _symbolController.text.toUpperCase()
            : _marketStandardController.text.isEmpty
                ? default_symbol
                : _marketStandardController.text,
        expenseRatio: _expenseRatioController.text.isEmpty
            ? 0
            : double.parse(_expenseRatioController.text),
        dividend: _dividendController.text.isEmpty
            ? 0
            : double.parse(_dividendController.text),
        series: _seriesController.text.isEmpty
            ? default_series
            : _seriesController.text,
        about: _aboutController.text.isEmpty
            ? default_about
            : _aboutController.text,
      )).then((res) => setState(() {
            response = res;
            if (response != null) {
              if (response == "success") {
                Navigator.pop(
                  context,
                );
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage(widget.isAdmin)));
              } else if (response == "standard") {
                _validateMarketStandard = false;
              }
            }
          }));
    }
  }
}
