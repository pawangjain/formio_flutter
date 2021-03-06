import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:universal_io/io.dart';

/// Contains all the data from the created widgets
Map<String, dynamic> map = new Map();

/// Filter by every basic mathematic operator.
/// ex: +,-,*,/
RegExp regex = new RegExp("(?!^-)[+*\/-](\s?-)?");

/// List of [Colors] with their hexadecimal representation.
const Map<String, int> colorMap = {
  'aqua': 0x00FFFF,
  'black': 0x000000,
  'blue': 0x0000FF,
  'brown': 0x9A6324,
  'cream': 0xFFFDD0,
  'cyan': 0x46f0f0,
  'green': 0x00FF00,
  'gray': 0x808080,
  'grey': 0x808080,
  'mint': 0xAAFFC3,
  'lavender': 0xE6BEFF,
  'new': 0xFFFF00,
  'olive': 0x808000,
  'orange': 0xFFA500,
  'pink': 0xFFE1E6,
  'purple': 0x800080,
  'red': 0xFF0000,
  'silver': 0xC0C0C0,
  'white': 0xFFFFFF,
  'yellow': 0xFFFF00
};

/// Returns the currency symbol by a [code]
/// ```dart
/// currency("USD") => "$"
/// currency("EUR") => "€"
/// ```
String currencyCode(String code) =>
    NumberFormat.simpleCurrency(name: code).currencySymbol;

/// Returns a list of [String].
///
/// ```dart
/// parseListStringCalculated("value=data.valueA*data.valueB") => ["valueA, valueB"]
/// ```
List<String> parseListStringCalculated(String value) {
  if (value.isEmpty) return [];
  List<String> _retainer = [];
  value.split(regex).forEach((element) {
    _retainer.add(element.substring(element.indexOf('.') + 1));
  });
  return _retainer;
}

/// Returns a [String] with the result from a mathematic operator.
///
/// ```dart
/// parseCalculate("8+5*2+(8/2)") => "22"
/// ```
///
/// Throws a [ArgumentError] if the expression isn't valid.
String parseCalculate(String operation) {
  try {
    Expression exp = Parser().parse(operation);
    return exp.evaluate(EvaluationType.REAL, null).toString();
  } catch (ex) {
    return "";
  }
}

/// Similar to [parseListStringCalculated], but handles a List of [String] with their
/// respective mathematic symbol.
/// ex: ["+","-","*","/"].
List<String> parseListStringOperator(String value) {
  if (value.isEmpty) return [];
  List<String> _retainer = [];
  Iterable<Match> matches = regex.allMatches(value);
  matches.forEach((element) {
    _retainer.add(element.group(0));
  });
  return _retainer;
}

/// Returns a [Color] containing a specific css theme.
/// ```dart
/// parseHexColor("primary") => Color.fromRGBO(0, 123, 255, 1.0)
/// parseHexColor("secondary") => Color.fromRGBO(108, 117, 125, 1.0)
/// parseHexColor("info") => Color.fromRGBO(23, 162, 184, 1.0)
/// parseHexColor("success") => Color.fromRGBO(40, 167, 69, 1.0)
/// parseHexColor("danger") => Color.fromRGBO(220, 53, 69, 1.0)
/// parseHexColor("warning") => Color.fromRGBO(255, 193, 7, 1.0)
/// ```
Color parseHexColor(String theme) {
  Color color;
  switch (theme.toLowerCase()) {
    case "primary":
      color = Color.fromRGBO(0, 123, 255, 1.0);
      break;
    case "secondary":
      color = Color.fromRGBO(108, 117, 125, 1.0);
      break;
    case "info":
      color = Color.fromRGBO(23, 162, 184, 1.0);
      break;
    case "success":
      color = Color.fromRGBO(40, 167, 69, 1.0);
      break;
    case "danger":
      color = Color.fromRGBO(220, 53, 69, 1.0);
      break;
    case "warning":
      color = Color.fromRGBO(255, 193, 7, 1.0);
      break;
    default:
      color = Color.fromRGBO(0, 123, 255, 1.0);
      break;
  }
  return color;
}

/// Returns a [TextInputType] from a String.
/// ```dart
/// parseInputType("email") => TextInputType.emailAddress
/// parseInputType("number") => TextInputType.number
/// parseInputType("currency") => TextInputType.number
/// parseInputType("phone") => TextInputType.phone
/// parseInputType("url") => TextInputType.url
/// parseInputType("time") => TextInputType.datetime
/// parseInputType("datetime") => TextInputType.datetime
/// parseInputType("date") => TextInputType.datetime
/// parseInputType("calendar") => TextInputType.datetime
/// parseInputType("textarea") => TextInputType.multiline
/// ```
TextInputType parsetInputType(String type) {
  TextInputType _inputType;
  switch (type) {
    case "email":
      _inputType = TextInputType.emailAddress;
      break;
    case "number":
      _inputType = TextInputType.number;
      break;
    case "currency":
      _inputType = TextInputType.number;
      break;
    case "phoneNumber":
      _inputType = TextInputType.phone;
      break;
    case "url":
      _inputType = TextInputType.url;
      break;
    case "time":
      _inputType = TextInputType.datetime;
      break;
    case "datetime":
      _inputType = TextInputType.datetime;
      break;
    case "date":
      _inputType = TextInputType.datetime;
      break;
    case "calendar":
      _inputType = TextInputType.datetime;
      break;
    case "textarea":
      _inputType = TextInputType.multiline;
      break;
    default:
      _inputType = TextInputType.text;
      break;
  }
  return _inputType;
}

/// Returns a [bool] if there's a signature widget that is empty.
/// ```dart
/// (empty != null) ? false : true
/// ```
Future<bool> checkSignatures(List<Widget> widgets) async {
  dynamic converted;
  widgets.asMap().forEach((key, value) {});
  for (var value in widgets) {
    switch (value.runtimeType) {
      case SignatureCreator:
        converted = value as SignatureCreator;
        if (await converted.data == null || await converted.data == "")
          return true;
        break;
      case PagerParserWidget:
        converted = value as PagerParserWidget;
        if (await checkSignatures(converted.widgets)) return true;
        break;
      case ColumnParserWidget:
        converted = value as ColumnParserWidget;
        if (await checkSignatures(converted.widgets)) return true;
        break;
    }
  }
  return false;
}

/// Similar to [checkSignatures], but check all the fields in the [List<Widget>]
/// ```dart
/// (empty != null) ? false : true
/// ```
Future<bool> checkFields(List<Widget> widgets) async {
  dynamic converted;
  widgets.asMap().forEach((key, value) {});
  for (var value in widgets) {
    switch (value.runtimeType) {
      case SignatureCreator:
        converted = value as SignatureCreator;
        if (await converted.data == null || await converted.data == "")
          return true;
        break;
      case FileCreator:
        converted = value as FileCreator;
        if (await converted.data == null || await converted.data == "")
          return true;
        break;
      case TextFieldCreator:
        converted = value as TextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case CurrencyTextFieldCreator:
        converted = value as CurrencyTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case TextAreaCreator:
        converted = value as TextAreaCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case UrlTextFieldCreator:
        converted = value as UrlTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case PhoneTextFieldCreator:
        converted = value as PhoneTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case NumberTextFieldCreator:
        converted = value as NumberTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case EmailTextFieldCreator:
        converted = value as EmailTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case DateTextFieldCreator:
        converted = value as DateTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case TimeTextFieldCreator:
        converted = value as TimeTextFieldCreator;
        if (!converted.map.disabled &&
            (await converted.data == null || await converted.data == ""))
          return true;
        break;
      case PagerParserWidget:
        converted = value as PagerParserWidget;
        if (await checkSignatures(converted.widgets)) return true;
        break;
      case ColumnParserWidget:
        converted = value as ColumnParserWidget;
        if (await checkSignatures(converted.widgets)) return true;
        break;
    }
  }
  return false;
}

/// Returns a [FormCollection] with a injected [List<Map<String, dynamic>>]
Future<FormCollection> parseFormCollectionDefaultValueListMap(
    FormCollection formCollection,
    List<Map<String, dynamic>> defaultMapValue) async {
  formCollection.components =
      await parseDefaultValue(formCollection.components, defaultMapValue);
  return formCollection;
}

/// Returns a [FormCollection] with a injected [Map<String, dynamic>]
Future<FormCollection> parseFormCollectionDefaultValueMap(
    FormCollection formCollection, Map<String, dynamic> defaultMapValue) async {
  formCollection.components =
      await parseByMap(formCollection.components, defaultMapValue);
  return formCollection;
}

/// Inject a default value from a [Map<String, dynamic>] into each [Component]
Future<List<Component>> parseByMap(
    List<Component> components, Map<String, dynamic> defaultMapper) async {
  await Future.forEach(components, (element) async {
    var index =
        components.indexWhere((indexElement) => indexElement == element);
    components[index].defaultValue =
        (defaultMapper.containsKey(components[index].key) &&
                defaultMapper[components[index].key] != null)
            ? defaultMapper[components[index].key]
            : components[index].defaultValue;
    if (components[index].component != null) {
      components[index].component =
          await parseByMap(components[index].component, defaultMapper);
    }
    if (components[index].columns != null) {
      components[index].columns =
          await parseByMap(components[index].columns, defaultMapper);
    }
  });
  return components;
}

/// Inject a default value from a [List<Map<String, dynamic>>] into each [Component]
Future<List<Component>> parseDefaultValue(List<Component> components,
    List<Map<String, dynamic>> defaultMapValue) async {
  await Future.forEach(components, (element) async {
    var _component = element as Component;
    defaultMapValue.forEach((mapElement) {
      if (mapElement.containsKey(_component.key)) {
        _component.defaultValue = (mapElement[_component.key] != null)
            ? mapElement[_component.key]
            : _component.defaultValue;
      }
    });
    if (_component.columns != null && _component.columns.isNotEmpty)
      _component.columns =
          await parseDefaultValue(_component.columns, defaultMapValue);
    if (_component.component != null && _component.component.isNotEmpty)
      _component.component =
          await parseDefaultValue(_component.component, defaultMapValue);
    element = _component;
  });
  return components;
}

/// Parse a list of [widgets].
///
/// returns a [Map<String, dynamic>] that contains the [key] and [value]
/// from that widget.
Future<Map<String, dynamic>> parseWidgets(List<Widget> widgets) async {
  dynamic converted;
  widgets.asMap().forEach(
    (key, value) async {
      switch (value.runtimeType) {
        case FileCreator:
          converted = value as FileCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case TextFieldCreator:
          converted = value as TextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case TextAreaCreator:
          converted = value as TextAreaCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case UrlTextFieldCreator:
          converted = value as UrlTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case PhoneTextFieldCreator:
          converted = value as PhoneTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case NumberTextFieldCreator:
          converted = value as NumberTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case CurrencyTextFieldCreator:
          converted = value as CurrencyTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case EmailTextFieldCreator:
          converted = value as EmailTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case DateTextFieldCreator:
          converted = value as DateTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case CheckboxCreator:
          converted = value as CheckboxCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case TimeTextFieldCreator:
          converted = value as TimeTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case SignatureCreator:
          converted = value as SignatureCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case SelectParserWidget:
          converted = value as SelectParserWidget;
          map[converted.keyValue()] = converted.data;
          break;
        case PagerParserWidget:
          converted = value as PagerParserWidget;
          parseWidgets(converted.widgets);
          break;
        case ColumnParserWidget:
          converted = value as ColumnParserWidget;
          parseWidgets(converted.widgets);
          break;
      }
    },
  );
  return map;
}

/// Returns a [String] with the [base64] representation of the related file.
String convertFileToBase64(String filename) {
  return (filename == null || filename.isEmpty)
      ? ""
      : (base64Encode(File(filename).readAsBytesSync()));
}

/// Similar to [convertFileToBase64], but instead check a [Signature Widget]
/// and returns the [base64] representation.
Future<String> convertSignatureToBase64(SignatureController controller) async {
  return (await controller.toPngBytes() != null)
      ? base64Encode(await controller.toPngBytes())
      : "";
}

/// Returns an Image based on the [base64] representation.
Image decodeSignatureFromBase64({String signature, Color color}) =>
    Image.memory(
      base64Decode(signature),
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      color: color,
      colorBlendMode: BlendMode.modulate,
      fit: BoxFit.cover,
    );

/// Returns a [Color] from a [String] with the color name.
/// the filter is based on the [colorMap] list.
/// ```dart
/// parseColor("aqua") => colorMap["aqua"]
/// ```
Color parseColor(String color) {
  var v = colorMap[color];
  Color out = Color((0xff << 24) | v);
  return (v == null) ? Colors.cyan : out;
}

/// Returns a [Color] from a [String]
/// ```dart
/// parseRgb("rgb(245,245,235)") => Color.fromARGB(255, 245, 245, 235)
/// ```
Color parseRgb(String input) {
  var startIndex = input.indexOf("(") + 1;
  var endIndex = input.indexOf(")");
  var values =
      input.substring(startIndex, endIndex).split(",").map((v) => int.parse(v));
  return Color.fromARGB(
      255, values.elementAt(0), values.elementAt(1), values.elementAt(2));
}
