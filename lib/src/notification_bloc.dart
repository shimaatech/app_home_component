import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/flutternotifications.dart';

class _NotificationEvent extends Equatable {
  final NotificationMessage notification;

  _NotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class _NotificationEventReceived extends _NotificationEvent {
  _NotificationEventReceived(NotificationMessage notification)
      : super(notification);
}

class _NotificationEventClicked extends _NotificationEvent {
  _NotificationEventClicked(NotificationMessage notification)
      : super(notification);
}


class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationStateInitial extends NotificationState {}

class _NotificationStateData extends NotificationState {
  final NotificationMessage notification;

  _NotificationStateData(this.notification);

  @override
  List<Object> get props => [notification];
}

class NotificationStateReceived extends _NotificationStateData {
  NotificationStateReceived(NotificationMessage notification)
      : super(notification);
}

class NotificationStateClicked extends _NotificationStateData {
  NotificationStateClicked(NotificationMessage notification)
      : super(notification);
}

class NotificationBloc extends Bloc<_NotificationEvent, NotificationState> {
  @protected
  final NotificationsServices notificationsServices;

  StreamSubscription<NotificationMessage> _notificationReceivedSubscription;
  StreamSubscription<NotificationMessage> _notificationClickedSubscription;

  NotificationBloc(this.notificationsServices) {
    _notificationReceivedSubscription =
        notificationsServices.onNotificationReceived.listen((message) {
      add(_NotificationEventReceived(message));
    });

    _notificationClickedSubscription =
        notificationsServices.onNotificationClicked.listen((message) {
      add(_NotificationEventClicked(message));
    });
  }
  
  @override
  Future<void> close() async {
    await super.close();
    _notificationClickedSubscription.cancel();
    _notificationReceivedSubscription.cancel();
  }

  @override
  NotificationState get initialState => NotificationStateInitial();

  @override
  Stream<NotificationState> mapEventToState(_NotificationEvent event) async* {
    if (event is _NotificationEventReceived) {
      yield (NotificationStateReceived(event.notification));
    } else if (event is _NotificationEventClicked) {
      yield NotificationStateClicked(event.notification);
    }
  }
}
