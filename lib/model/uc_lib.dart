/*
 * File Name   : uc_lib.dart
 * Author      : Akshay Pauranik
 * Function    : uc_lib
 * Version     : 1.0
 * Package     : model
 * Created On  : 12 Mar 2020
 * Dependency  : No any dependency ( Core javascript library )
 * Updated By  : Akshay Pauranik
 * Last update : 12 Mar 2020
*/

import 'dart:convert';

import '../model/theme_action.dart';

/* To handle(read/write) complex json in dart */
/* Reference https://dev.to/onmyway133/how-to-resolve-deep-json-object-in-dart-5c5l */
/* Usage:-
    var myjson = '''your strigified json''';
    var jsonObject = DartJson(myjson);
    var jsonObject = DartJson(myjson, customSeperator: '/');
    var newObj = jsonObject.read('Employee.Entitlements.GP.Balance');
    newObj.read('xyz.abc').raw();
    var newObj = jsonObject.read('Employee.Entitlements.GP.Balance', rawData: true); //return rawValues instead of DartJSON object
    jsonObject.read('Employee.Entitlements.GP.Balance', defaultValue: 0);
    jsonObject.read('Dependents.0.Relationship').raw();
    jsonObject.write('Dependents.5.Relationship', 10); //create new segments as object only
    jsonObject.write('Dependents.5.Relationship', {'newKey1': true, 'newKey2': '3'}, appendMode: true); //appendItem if already exists(works on both array and object)
    jsonObject.write('Dependents.5.Relationship', 10, arrayMode: true); //create new segments as array if possible
    jsonObject.write('Dependents.5.Relationship', null, delete: true); //create new segments as object only
    jsonObject.encode(); //encodeJSON object as string
    jsonObject.type();  //check basic return type existing currently
    jsonObject.raw(); //return the raw value of object else it will always be wrapped in a DartJson wrapper. Need always to get values.
    jsonObject.isValid(); //if passed string is a valid json
*/
class DartJson {
  dynamic _json;
  String customSeperator;
  bool _isInvalidJson = false;
  DartJson _parent;

  DartJson get parent {
    return _parent ?? DartJson(null);
  }

  /// Constructs a DartJson Object
  /// The constructor accepts any type of object
  /// and if it is a string then tries parsing to JSON object
  /// if parsing fails then marks it as invalid json
  /// a customSeperator can be used to seperate perperties of object
  /// by default the seperator is .(dot)
  DartJson(json, {this.customSeperator: '.'}) {
    if (json is String) {
      try {
        _json = jsonDecode(json);
      } catch (e) {
        _isInvalidJson = true;
        _json = json;
      }
    } else {
      if (json is! Map<String, dynamic>) {
        _isInvalidJson = true;
      }
      _json = json;
    }
  }

  void forEach(Function fun) {
    if (_json is Map) {
      _json.forEach(fun);
    } else if (_json is List) {
      _json.map(fun);
    }
  }

  /// If the json/object is a valid Map<String, dynamic>
  bool isValid() {
    return !_isInvalidJson;
  }

  /// Get type as string of the object amonst
  /// bool, int, string, double, object, array or other
  String type() {
    if (_json is bool) {
      return 'bool';
    } else if (_json is int) {
      return 'int';
    } else if (_json is String) {
      return 'string';
    } else if (_json is double) {
      return 'double';
    } else if (_json is Map) {
      return 'object';
    } else if (_json is List) {
      return 'array';
    } else {
      return 'other';
    }
  }

  /// If json is a valid Map<String, dynamic> object
  /// then return stringified version else return blank string
  String encode() {
    if (_json is Map<String, dynamic>) {
      return jsonEncode(_json);
    } else {
      return '';
    }
  }

  /// Get raw dart object(data) stored in the DartJson object
  dynamic raw() {
    return this._json;
  }

  /// Edit json content by defining the path
  /// The path should have the same seperator as defined in the constructor
  /// delete: If some attribute needs to be deleted(false by default)
  /// arrayMode: Try creating array based structure i.e. if integers are passed in path and new object has to created
  ///   then it would be an array (false by default). arrayMode scenario:-
  ///   obj.write('con.2.a', 6, arrayMode: true) -> {'con': [null, null, 'a': 6]}
  ///   obj.write('con.2.a', 6) -> {'con': {'2': {'a': 6}}}
  /// appendMode: If true then try to append Map or List items in existing List or Map, by default false which means
  /// replace with given value(object/array or any other)
  /// onReplace: is a callback function which will be invoke to edit the current value
  DartJson write(String path, newValue,
      {bool delete: false,
      bool arrayMode: false,
      bool appendMode: false,
      Function onReplace}) {
    try {
      if (_json is Map<String, dynamic> || _json is List<dynamic>) {
        dynamic current = _json;
        var pathArr = path.split(this.customSeperator);
        int counter = 0;
        for (final segment in pathArr) {
          final maybeInt = int.tryParse(segment);
          var isArray = (maybeInt != null && current is List);
          if (isArray && maybeInt >= current.length) {
            while (maybeInt >= current.length) {
              current.add(null);
            }
          }
          var nextIndex = maybeInt == null || !arrayMode ? segment : maybeInt;
          if (isArray) {
            nextIndex = int.tryParse(nextIndex);
          }
          if (counter == pathArr.length - 1) {
            if (delete) {
              if (maybeInt != null) {
                current[maybeInt] = null;
              } else {
                current.remove(segment);
              }
              return this;
            } else {
              if (onReplace != null) {
                current[nextIndex] = onReplace(current[nextIndex]);
              } else if (appendMode && current[nextIndex] is List) {
                var arr = (current[nextIndex] as List);
                (newValue is List) ? arr.addAll(newValue) : arr.add(newValue);
              } else if (appendMode && current[nextIndex] is Map) {
                var obj = (current[nextIndex] as Map);
                (newValue is Map)
                    ? obj.addAll(newValue)
                    : obj[nextIndex] = newValue;
              } else {
                current[nextIndex] = newValue;
              }
              return this;
            }
          }

          var nextValue = current[nextIndex];

          if ((isArray && current[maybeInt] == null) ||
              (current is Map && current[segment] == null) ||
              (nextValue is! Map && nextValue is! List)) {
            final segmentNext = pathArr[counter + 1];
            final maybeIntNext = int.tryParse(segmentNext);

            if (maybeIntNext != null && arrayMode) {
              current[nextIndex] = List<dynamic>();
            } else {
              current[nextIndex] = Map<String, dynamic>();
            }
          }

          current = current[nextIndex];
          counter++;
        }
      }
    } catch (error) {
      print(error);
    }
    return this;
  }

  /// provide path to read the value
  /// defaultValue will be returned if nothing found(by default null)
  /// raw value is returned
  dynamic $(String path, {dynamic defaultValue}) {
    _parent = this;
    try {
      if (_json is! Map<String, dynamic> && _json is! List<dynamic>) {
        return (defaultValue);
      }
      dynamic current = _json;
      var pathArr = path.split(this.customSeperator);
      for (final segment in pathArr) {
        final maybeInt = int.tryParse(segment);
        if (maybeInt != null && current is List<dynamic>) {
          current = current.length <= maybeInt ? null : current[maybeInt];
        } else if (current is Map<String, dynamic>) {
          current = current[segment];
        } else {
          current = defaultValue;
          break;
        }
      }
      return (current ?? defaultValue);
    } catch (error) {
      print(error);
      return (defaultValue);
    }
  }

  /// provide path to read the value
  /// defaultValue will be returned if nothing found(by default null)
  /// DartJson wrapped object to perform further operations
  DartJson read(String path, {dynamic defaultValue}) {
    return DartJson(this.$(path, defaultValue: defaultValue));
  }
}

/**
 * Safe type conversion for basic dart types
 */
class $ {
  dynamic obj;

  $(this.obj);

  /// Convert to int from int, double, bool, string etc. along with null values
  int toInt() {
    if (obj is num) {
      return obj.toInt();
    } else if (obj is bool) {
      return obj ? 1 : 0;
    } else if (obj is String) {
      var i = num.tryParse(obj);
      return (obj.isEmpty ? 0 : (i ?? 1).toInt());
    }
    return obj == null ? 0 : 1;
  }

  /// Convert to bool from int, double, bool, string etc. along with null values
  /// Useful while directly using in the if and other conditional statements
  bool toBool({bool isStrict: false}) {
    if (obj is num) {
      return obj != 0;
    } else if (obj is bool) {
      return obj;
    } else if (obj is String) {
      if (obj.isEmpty) {
        return false;
      } else {
        return isStrict
            ? (num.tryParse(obj) != 0 && obj.toLowerCase() != "false")
            : num.tryParse(obj) != 0;
      }
    }
    return obj != null;
  }

  String toString() {
    return obj == null ? '' : obj.toString();
  }
}
