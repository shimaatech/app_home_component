import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_notifications/flutternotifications.dart';

import 'app_bloc.dart';

abstract class BaseAppHome<B extends BaseAppBloc> extends Component<B> {}

abstract class BaseAppHomeView<B extends BaseAppBloc> extends ComponentView<B> {
  BaseAppHomeView(B bloc) : super(bloc);
}

abstract class AppHomeWithNotifications<B extends AppBlocWithNotifications> extends BaseAppHome<B> {}

abstract class AppHomeWithNotificationsView<B extends AppBlocWithNotifications> extends BaseAppHomeView<B> {
  AppHomeWithNotificationsView(B bloc) : super(bloc);

  void onNotificationReceived(BuildContext context, NotificationMessage notification) {}

  void onNotificationClicked(BuildContext context, NotificationMessage notification) {}

  @mustCallSuper
  void stateListener(BuildContext context, BlocState state) {
    if (state is StateNotificationReceived) {
      onNotificationReceived(context, state.notification);
    } else if (state is StateNotificationClicked) {
      onNotificationClicked(context, state.notification);
    }
  }
}
