import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/notification_model.dart';
import 'package:ronan_pensec/route/planning_route.dart';
import 'package:ronan_pensec/services/data_controls/notification_data_control.dart';
import 'package:ronan_pensec/services/notification_service.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationDataControl _dataControl = NotificationDataControl.instance;
  final NotificationService _service = NotificationService.instance;

  invalidContent({required Widget image, required String subtext}) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: image,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: Text(
              "OOPS!",
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              // "",
              "$subtext",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey, fontSize: 16.5, letterSpacing: 1),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    offset: Offset(0, 40),
                    onSelected: (value) {
                      if (value == 0) {
                        _service.markAllAsRead;
                      } else {
                        _service.all;
                      }
                    },
                    icon: Icon(Icons.more_horiz),
                    itemBuilder: (_) => <PopupMenuItem>[
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.mark_email_read_outlined,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "Tout marquer comme lu",
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "Rafraîchir",
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<NotificationModel>?>(
                  stream: _dataControl.stream,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0 && !snapshot.hasError) {
                        return Container(
                          width: double.infinity,
                          child: Scrollbar(
                            child: ListView(
                              children: [
                                for (NotificationModel notification
                                    in snapshot.data!) ...{
                                  MaterialButton(
                                    onPressed: (){
                                      Navigator.push(context, PlanningRoute.allRequests);
                                      if(notification.isRead == 0){
                                        _service.markAsRead(notification.id);
                                      }
                                    },
                                    color: notification.isRead == 1 ? Colors.grey.shade200 : Colors.grey.shade300,
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black45,
                                                  blurRadius: 2,
                                                  offset: Offset(2, 2))
                                            ],
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "${notification.sender.image}"))),
                                      ),
                                      title: Text(
                                        "${notification.title}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              "${notification.message}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              "${notification.time}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12.5
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(notification.isRead == 1 ? Icons.check : Icons.mark_as_unread, color: Colors.grey.shade400,),
                                    ),

                                  )
                                }
                              ],
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return invalidContent(
                              image: Image.asset(
                                "assets/images/info.png",
                                color: Colors.grey.shade600,
                              ),
                              subtext:
                                  "Une erreur s'est produite veuillez réessayer ou contacter l'administrateur");
                        } else {
                          return invalidContent(
                              image: Image.asset(
                                "assets/images/info.png",
                                color: Colors.grey.shade600,
                              ),
                              subtext: "Aucune notification n'a été trouvée");
                        }
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Palette.gradientColor[0]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
