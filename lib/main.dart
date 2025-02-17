import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/databases/databases_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // load the config database
    DatabasesHelper.dbHelper.init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      routes: routes,
    );
  }
}
