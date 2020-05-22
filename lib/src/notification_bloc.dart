import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/flutternotifications.dart';

class NotificationEvent extends Equatable {
  final NotificationMessage notification;

  NotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class NotificationEventReceived extends NotificationEvent {
  NotificationEventReceived(NotificationMessage notification)
      : super(notification);
}

class NotificationEventClicked extends NotificationEvent {
  NotificationEventClicked(NotificationMessage notification)
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

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @protected
  final NotificationsServices notificationsServices;

  StreamSubscription<NotificationMessage> _notificationReceivedSubscription;
  StreamSubscription<NotificationMessage> _notificationClickedSubscription;

  NotificationBloc(this.notificationsServices) {
    _notificationReceivedSubscription =
        notificationsServices.onNotificationReceived.listen((message) {
      add(NotificationEventReceived(message));
    });

    _notificationClickedSubscription =
        notificationsServices.onNotificationClicked.listen((message) {
      add(NotificationEventClicked(message));
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
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationEventReceived) {
      yield (NotificationStateReceived(event.notification));
    } else if (event is NotificationEventClicked) {
      yield NotificationStateClicked(event.notification);
    }
  }
}
