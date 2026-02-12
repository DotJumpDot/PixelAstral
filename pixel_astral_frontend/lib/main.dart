import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'router.dart';
import 'store/auth.dart';
import 'store/user.dart';
import 'store/novel.dart';
import 'service/http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NovelProvider()),
      ],
      child: MaterialApp.router(
        title: 'PixelAstral',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }
}
