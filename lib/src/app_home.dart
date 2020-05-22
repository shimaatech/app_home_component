import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/flutternotifications.dart';

import 'notification_bloc.dart';

abstract class BaseAppHome extends StatelessWidget {}

abstract class AppHomeWithNotifications extends BaseAppHome {
  AppHomeWithNotifications();

  void onNotificationReceived(
      BuildContext context, NotificationMessage notification) {}

  void onNotificationClicked(
      BuildContext context, NotificationMessage notification) {}

  Widget buildHomePage(BuildContext buildContext);

  Widget build(BuildContext context) {
    return BlocListener(
        bloc: notificationsBloc(context),
        child: buildHomePage(context),
        listener: (context, state) {
          if (state is NotificationStateReceived) {
            onNotificationReceived(context, state.notification);
          } else if (state is NotificationStateClicked) {
            onNotificationClicked(context, state.notification);
          }
        });
  }

  NotificationBloc notificationsBloc(BuildContext context);
}
