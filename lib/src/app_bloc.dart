import 'dart:async';

import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_notifications/flutternotifications.dart';

class AppState extends BlocState {}

class AppEvent extends BlocEvent {}

abstract class BaseAppBloc extends BaseBloc {}

class _NotificationEvent extends AppEvent {
  final NotificationMessage notification;

  _NotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class _EventNotificationReceived extends _NotificationEvent {
  _EventNotificationReceived(NotificationMessage notification)
      : super(notification);
}

class _EventNotificationClicked extends _NotificationEvent {
  _EventNotificationClicked(NotificationMessage notification)
      : super(notification);
}

class _NotificationState extends AppState {
  final NotificationMessage notification;

  _NotificationState(this.notification);

  @override
  List<Object> get props => [notification];
}

class StateNotificationReceived extends _NotificationState {
  StateNotificationReceived(NotificationMessage notification)
      : super(notification);
}

class StateNotificationClicked extends _NotificationState {
  StateNotificationClicked(NotificationMessage notification)
      : super(notification);
}

abstract class AppBlocWithNotifications extends BaseAppBloc {
  @protected
  final NotificationsServices notificationsServices;

  StreamSubscription<NotificationMessage> _notificationReceivedSubscription;
  StreamSubscription<NotificationMessage> _notificationClickedSubscription;

  AppBlocWithNotifications(this.notificationsServices) {
    _notificationReceivedSubscription =
        notificationsServices.onNotificationReceived.listen((message) {
      add(_EventNotificationReceived(message));
    });

    _notificationClickedSubscription =
        notificationsServices.onNotificationClicked.listen((message) {
      add(_EventNotificationClicked(message));
    });
  }

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is _EventNotificationReceived) {
      yield (StateNotificationReceived(event.notification));
    } else if (event is _EventNotificationClicked) {
      yield StateNotificationClicked(event.notification);
    }
  }

  @override
  Future<void> close() async {
    await super.close();
    _notificationClickedSubscription.cancel();
    _notificationReceivedSubscription.cancel();
  }
}
