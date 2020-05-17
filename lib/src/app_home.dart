import 'package:flutter/cupertino.dart';
import 'package:flutter_base_bloc/flutterbasebloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/flutternotifications.dart';

import 'notifications_bloc.dart';

abstract class BaseAppHome extends StatelessWidget {}

abstract class AppHomeWithNotifications extends BaseAppHome {
  void onNotificationReceived(BuildContext context, NotificationMessage notification) {}

  void onNotificationClicked(BuildContext context, NotificationMessage notification) {}

  Widget buildHomePage(BuildContext buildContext);

  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<NotificationsBloc>(context),
      child: buildHomePage(context),
      listener: (context, state) {
        if (state is StateNotificationReceived) {
          onNotificationReceived(context, state.notification);
        } else if (state is StateNotificationClicked) {
          onNotificationClicked(context, state.notification);
        }
      }
    );
  }

}
