import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatefulWidget {
  final ValueChanged<List<String>> pinInputDone;

  PinInput(this.pinInputDone);

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  static const _pinSize = 4;
  static const _whiteSpace = ' ';

  List<String> _pin;
  List<FocusNode> _focusNodes;

  void _pinDone() {}

  void _pinChange(index, String str) {
    if (str != _whiteSpace) {
      _pin[index] = str;
      if (isStrEmpty(str)) {
        _moveItem(index, true);
      } else {
        _moveEmptyItemOrDone(index);
      }
    }
  }

  void _moveItem(index, bool pre) {
    FocusScope.of(context)
        .requestFocus(_focusNodes[(index + (pre ? -1 : 1)) % _pinSize]);
  }

  void _moveEmptyItemOrDone(index) {
    var findFocusPin = _pin.sublist(index) + _pin.sublist(0, index);

    var emptyIndex = findFocusPin.indexWhere((str) => isStrEmpty(str));

    if (emptyIndex != -1) {
      FocusScope.of(context)
          .requestFocus(_focusNodes[(emptyIndex + index) % _pinSize]);
    } else {
      FocusScope.of(context).unfocus();
      widget.pinInputDone(_pin);
    }
  }

  bool isStrEmpty(String str) {
    return str.isEmpty || str == _whiteSpace;
  }

  @override
  void initState() {
    super.initState();
    _pin = List.filled(_pinSize, _whiteSpace);
    _focusNodes = List.generate(_pinSize, (index) {
      return FocusNode()
        ..addListener(() {
          if (_pin[index].isEmpty) {
            setState(() {
              _pin[index] = _whiteSpace;
            });
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buildPinInput(),
    );
  }

  List<Widget> buildPinInput() {
    return List.generate(_pinSize, (index) {
      return SizedBox(
          width: 48,
          child: TextField(
            cursorWidth: 0,
            textAlign: TextAlign.center,
            enableInteractiveSelection: false,
            keyboardType: TextInputType.number,
            inputFormatters: [
              _PinInputFormatter(_whiteSpace),
              WhitelistingTextInputFormatter(RegExp('[\\d$_whiteSpace]*'))
            ],
            decoration: InputDecoration(
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
            textInputAction: TextInputAction.next,
            controller: TextEditingController.fromValue(TextEditingValue(
                text: _pin[index],
                selection: TextSelection.collapsed(
                    offset: _pin[index].length,
                    affinity: TextAffinity.upstream))),
            onSubmitted: (str) {
              _moveItem(index, false);
            },
            autofocus: index == 0,
            focusNode: _focusNodes[index],
            onChanged: (str) {
              _pinChange(index, str);
            },
          ));
    });
  }
}

class _PinInputFormatter extends TextInputFormatter {
  String _whiteSpace;

  _PinInputFormatter(this._whiteSpace);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var result = '';
    if (newValue.text == '') {
      if (oldValue.text != _whiteSpace) {
        result = _whiteSpace;
      } else {
        return newValue;
      }
    } else {
      result = newValue.text.substring(newValue.text.length - 1);
    }
    return TextEditingValue(
        text: result, selection: TextSelection.collapsed(offset: 1));
  }
}
