import 'package:fluro/fluro.dart';
import 'package:trashapp/pages/newsDetailPage.dart';
import 'package:trashapp/pages/trashDetailPage.dart';
import 'package:trashapp/pages/trashList.dart';

final router = Router();

// var usersHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//   return UsersScreen(params["id"][0]);
// });

// void defineRoutes(Router router) {
//   router.define("/users/:id", handler: usersHandler);

//   // it is also possible to define the route transition to use
//   // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);
// }

// router.navigateTo(context, "/users/1234", transition: TransitionType.fadeIn);

void defineRoutes(Router router) {
  router.define("/trashDetail/:keyword",
      handler: Handler(handlerFunc: (context, params) {
    String keyword = params["keyword"][0];
    return TrashDetailPage(keyword);
  }));


}
