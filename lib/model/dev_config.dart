/*
 * File Name   : dev_config.dart
 * Author      : Akshay Pauranik
 * Function    : Globally used constants required for the App and API
 * Version     : 1.0
 * Package     : model
 * Created On  : 14 Mar 2020
 * Updated By  : Akshay Pauranik
 * Last update : 14 Mar 2020
*/

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:device_info/device_info.dart';

class DevConfig {
  static String _homeDirPath;
  static String _basicUrl;
  static dynamic _deviceInfo;
  static final bool isIOS = Platform.isIOS;
  static const _a = [
    'http://localhost/pe-gold3/',
    'https://www.ucertify.com/',
    'https://www.jigyaasa.info/',
    'http://172.10.195.139/pe-gold3/',
  ];

  static const String STORAGE_KEY_IS_LOGGED_IN = '@uCertifyApp:isLoggedIn';
  static const String STORAGE_KEY_EMAIL = '@uCertifyApp:email';
  static const String STORAGE_KEY_IS_INSTALLED = '@uCertifyApp:isInstalled';
  static const String STORAGE_KEY_USER = '@uCertifyApp:user';

  static Future<void> init({String basicUrl: '', int index: 1}) async {
    if (_homeDirPath?.isEmpty ?? true) {
      Directory directory = await getApplicationDocumentsDirectory();
      _homeDirPath = directory.path;

      var devInfo = DeviceInfoPlugin();
      if (isIOS) {
        _deviceInfo = await devInfo.iosInfo;
      } else {
        _deviceInfo = await devInfo.androidInfo;
      }
      // print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

      // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"

    }
    _basicUrl = basicUrl?.isEmpty ? _a[index] : basicUrl;
  }

  static getDeviceInfo({valueOf: 'all'}) {
    dynamic returnVal = _deviceInfo;
    switch (valueOf) {
      case 'device_id':
        returnVal =
            isIOS ? _deviceInfo.identifierForVendor : _deviceInfo.androidId;
        break;
      default:
    }
    return returnVal;
  }

  static String get HOME_PATH {
    return _homeDirPath;
  }

  static String get REMOTE_API_URL {
    return _a[1] + 'pe-api/1/index.php';
  }

  static String get BASIC_URL => _basicUrl;
  static String get TERMINAL_URL =>
      BASIC_URL + 'sim/terminal/nativeTerminal.php';
  static String get CERTIFICATE_URL => BASIC_URL + 'my/certificate.php?';
  static String get MYPROFILE_URL => BASIC_URL + 'myprofile.php?func=myprofile';
  static String get COURSE_URL => _a[1] + 'courses/';
  static String get VIRTUAL_LAB =>
      BASIC_URL + 'custom/docker/nativeLiveLab.php';
  static String get JAVA_REPL => _a[1] + 'sim/?module=terminal&type=java&';

  // static LOCAL_IMG_URL           = `file://${RNFS.DocumentDirectoryPath}/`;
  // static HOME                    = `file://${RNFS.DocumentDirectoryPath}/`;

  static const SITE_THEME_URL =
      'https://www.ucertify.com/layout/themes/bootstrap4/';
  static const USER_ASSETS_URL = "https://s3.amazonaws.com/";
  static const CATALOG_IMG_URL =
      USER_ASSETS_URL + "jigyaasa_assets/images/new/";
  static const USER_IMG_URL = USER_ASSETS_URL + "ucertify_user/";
  static const MEDIA_URL = USER_ASSETS_URL + "jigyaasa_content_static/";
  static const VIDEO_URL = USER_ASSETS_URL + "jigyaasa_content_stream/";
  static const N_MEDIA_URL = USER_ASSETS_URL + "ucertify-course-package/";
  static const DOWNLOAD_IMAGE_URL =
      USER_ASSETS_URL + "ucertify-course-package/";
  static const YOUTUBE_VIDEO_URL = 'https://www.youtube.com/embed/';
  static const VIMEO_VIDEO_URL = 'https://player.vimeo.com/video/';
  static const LOCALHOST_URL = 'http://localhost/pe-gold3/';
  static const BASE_URL = 'http://www.jigyaasa.info/';

  static const FIREBASE_URL = 'https://ucertify-fb.firebaseio.com/';
  static const CRASH_REPORT_URL = FIREBASE_URL + 'crash_report/';
  static const QR_STATS_URL = FIREBASE_URL + 'qr-stats/';
  static const USER_LOG_URL = FIREBASE_URL + 'user_log/';

  static const EMAIL_FROM = 'support@ucertify.com';
  static const EMAIL_FROMNAME = 'uCertify support';
  static const EMAIL_SUPPORT = 'support@ucertify.com';

  static const DOWNLOAD_COURSE_File = USER_ASSETS_URL + "jigyaasa_download/";
}
