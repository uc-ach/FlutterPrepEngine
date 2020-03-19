/*
 * File Name   : theme_action.dart
 * Author      : Akshay Pauranik
 * Function    : Gloablly used resource throught the app(UI features, enums, navigation etc.)
 * Version     : 1.0
 * Package     : model
 * Created On  : 14 Mar 2020
 * Updated By  : Akshay Pauranik
 * Last update : 14 Mar 2020
*/
library uc.core;

import 'package:flutter/material.dart';
import 'uc_lib.dart';
export 'uc_lib.dart' show DartJson, $;

part "db_types/content.dart";
part "db_types/user_data.dart";

class UC {
  UC._();
  static bool _isPortrait;
  static double _width, _height;
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static void setDim(bool isportrait, double width, double height) {
    _isPortrait = isportrait;
    _width = width;
    _height = height;
  }

  static void pushScene(String sceneName,
      {isReplace: false, Object arguments}) {
    if (isReplace) {
      navigatorKey.currentState
          .pushReplacementNamed(sceneName, arguments: arguments);
    } else {
      navigatorKey.currentState.pushNamed(sceneName, arguments: arguments);
    }
  }

  static void popScene(String sceneName,
      {isReplace: false, arguments: const {}}) {
    if (isReplace) {
      navigatorKey.currentState
          .pushReplacementNamed(sceneName, arguments: arguments);
    } else {
      navigatorKey.currentState.pushNamed(sceneName, arguments: arguments);
    }
  }

  static dynamic dim(portrait, landscape) {
    return _isPortrait ? portrait : landscape;
  }

  static get width {
    return isPortrait ? _width : _height;
  }

  static get height {
    return isPortrait ? _height : _width;
  }

  static get isPortrait {
    return _isPortrait;
  }

  static Map get client {
    return {
      'email': 'ajeet.chauhan@ucertify.com',
      'password': '',
      'isSocial': true,
    };
  }
}

class UCActive {
  static String userGuid, courseCode, contentGuid, userEmail, activeScene;
  static Map coverage, testSession; //hold reference
}

/// Reduce database query cost by using in-memory cache
class UCCache {
  static Map<String, Content> content = Map<String, Content>();
}

abstract class UCRoutes {
  static const String LAUNCH = '/';
  static const String LOGIN = '/login';
  static const String WELCOME = '/welcome';
  static const String TEST_NAVIGATION = '/testNavigation';
  static const String NATIVE_TOOLS = '/nativeTools';
}

enum UCItemType {
  MultipleChoice,
  DragAndDrop,
  HotspotHub,
  ChooseAndReorder,
  ChooseAndReorderMultiGrid,
  FillintheBlank,
  MatchList,
  SliderItem,
  Terminal,
  ExternalModule,
  AlignMatch,
  SmartChat,
  LiveLab,
  Insights,
  AlgoItem,
  TreeView,
  ReactItem,
  ChoiceMatrix,
  ProtoType
}

var _contentItemsTypes = {
  '0': UCItemType.MultipleChoice,
  "1": UCItemType.DragAndDrop,
  "3": UCItemType.ReactItem,
  "4": UCItemType.HotspotHub,
  "6": UCItemType.ChooseAndReorder,
  "7": UCItemType.TreeView,
  "8": UCItemType.AlgoItem,
  "9": UCItemType.FillintheBlank,
  "13": UCItemType.Terminal,
  "14": UCItemType.MatchList,
  "16": UCItemType.ExternalModule,
  "17": UCItemType.ExternalModule,
  "18": UCItemType.ExternalModule,
  "22": UCItemType.ReactItem,
  "23": UCItemType.ExternalModule,
  "24": UCItemType.ReactItem,
  "25": UCItemType.LiveLab,
  "26": UCItemType.ChooseAndReorderMultiGrid,
  "27": UCItemType.ChoiceMatrix,
  "30": UCItemType.SliderItem,
  "32": UCItemType.SmartChat,
  "35": UCItemType.AlignMatch,
  "36": UCItemType.Insights,
  "37": UCItemType.ReactItem,
  "38": UCItemType.ReactItem,
};
