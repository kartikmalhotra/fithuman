// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       throw UnsupportedError(
//         'DefaultFirebaseOptions have not been configured for web - '
//         'you can reconfigure this by running the FlutterFire CLI again.',
//       );
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for macos - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.windows:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for windows - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyA5ZqAjcBdYcWqDTJMoxRB3zNHmF84MtHs',
//     appId: '1:438982583676:android:c9c271bc0df1d3a5fab0f9',
//     messagingSenderId: '438982583676',
//     projectId: 'inpharmd-e5a9e',
//     storageBucket: 'inpharmd-e5a9e.appspot.com',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyASQNKyN5HpaO2QBzWMeRtdILT73C_inAM',
//     appId: '1:438982583676:ios:80f3e26491a117d2fab0f9',
//     messagingSenderId: '438982583676',
//     projectId: 'inpharmd-e5a9e',
//     storageBucket: 'inpharmd-e5a9e.appspot.com',
//     iosClientId:
//         '438982583676-78d121s2gdh4nl0spc88bdg9vm8kb55c.apps.googleusercontent.com',
//     iosBundleId: 'edu.mercer.InpharmD',
//   );
// }
