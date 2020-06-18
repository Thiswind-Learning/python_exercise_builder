import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:python_exercise_builder/pages/home_page.dart';
import 'package:python_exercise_builder/redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

// https://github.com/brianegan/flutter_redux/issues/51
// https://github.com/brianegan/flutter_redux/issues/143
Store<AppState> store = Store<AppState>(
  reducer,
  initialState: AppState.initState(),
  middleware: [thunkMiddleware, LoggingMiddleware.printer()],
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (_, store) {
          // print('app build, locale: ${store.state.themeData}, title: ${translate('title')}');
          // https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
          // https://github.com/flutter/flutter/issues/17895
          return GestureDetector(
            onTap: () {
              print('MaterialApp onTap');
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                // currentFocus.unfocus();
                FocusScope.of(context).requestFocus(new FocusNode());
              }
            },
            child: MaterialApp(
              locale: store.state.locale,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                localizationDelegate
              ],
              supportedLocales: localizationDelegate.supportedLocales,
              theme: ThemeData(
                fontFamily: "romantic_garden, FZLanTingYuan",
                primarySwatch: store.state.appThemeData.primarySwatch,
                brightness: store.state.appThemeData.brightness,
                toggleableActiveColor: store.state.appThemeData.primarySwatch,
                accentColor: store.state.appThemeData.primarySwatch,
                // see more on https://stackoverflow.com/questions/50196913/how-to-change-navigation-animation-using-flutter
                // Add the line below to get horizontal sliding transitions for routes.
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                }),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: HomePage(title: 'Python Exercise Builder'),
            ),
          );
        },
      ),
    );
  }
}
