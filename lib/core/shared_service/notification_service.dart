import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

/*
  * @class PushNotificationsService
  * @desc  This class configures push notifications for android and ios
  *        and provides methods to push notifications on device.
*/

class PushNotificationsService {
  final notifications = FlutterLocalNotificationsPlugin();

  /*
   * @desc Constructs a PushNotificationsService object with configuration settings
   *       for android and iOS.
   */
  PushNotificationsService() {
    _configure();
  }

  void _configure() async {
    /*
     * Platform : Android
     * @desc   Notification Settings - Sets a default application icon to be shown
     *         in notification tray
     */
    final settingsAndroid = AndroidInitializationSettings('app_icon');

    /*
     * Platform : iOS
     * @desc   Notification Settings - Requests alert, sound, badge permissions.
     *         Sets default sound, badge, alert
     */
    final settingsIOS = IOSInitializationSettings(
        //  onDidReceiveLocalNotification: (id, title, body, payload) =>
        //     onSelectNotification(payload)
        );

    /*
     * @desc   Initializes notifications plugin with given parameters.
     *         On iOS, it requests permissions to show notifications.
     * 
     * @param  settingsIOS - IOSInitializationSettings
     * @param  settingsAndroid - AndroidInitializationSettings
     */
    notifications.initialize(
      InitializationSettings(settingsAndroid, settingsIOS),
      // onSelectNotification: onSelectNotification
    );
  }

  // Future onSelectNotification(String payload) async => await showDialogBox(
  //     title: "Notification", description: "Route Completed");

  // Configure notification detail settings for each platform
  NotificationDetails get _notificationDetails {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: false,
    );
    final iOSChannelSpecifics = IOSNotificationDetails();
    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
  }

  /*
   * @desc    A callable function to show notifications.
   * @param title - a string title of notification.
   * @param body - a string description of notification.
   * @returns _notification function to display notification on device.
   */
  Future showNotification({
    @required String title,
    @required String body,
    int id = 0,
  }) {
    return _notification(
        title: title, body: body, id: id, type: _notificationDetails);
  }

  /*
   * @desc  Shows notifications with specified parameters.
   * @param title - a string title of notification.
   * @param body - a string description of notification.  
   * @param type - NotificationDetails with respect to each platform 
   */
  Future _notification({
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 0,
  }) =>
      this.notifications.show(id, title, body, type);
}
