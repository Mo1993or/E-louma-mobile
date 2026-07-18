import 'dart:ui';

import 'package:E_louma/Interface/notificationInterface.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/shimmersAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

enum NotificationType {
  order,
  payment,
  warning,
  message,
  success,
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Notificationinterface> notifications = [];
  bool showShimmers = true;
  int get unreadCount => notifications.where((e) => !e.read).length;

  _fetchNotifications() async {
    try {
      await ProductService().fetchNotification().then((value) {
        setState(() {
          print("values $value");
          notifications = value;
          showShimmers = false;
        });
      });
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 12,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.done_all_rounded),
        label: const Text(
          "Tout lire",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          HapticFeedback.mediumImpact();

          setState(() {
            for (final n in notifications) {
              n.read = true;
            }
          });
          await ProductService().readAllNotification();
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: 56,
                      //       height: 56,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(18),
                      //         gradient: const LinearGradient(
                      //           colors: [
                      //             Color(0xff5B6CFF),
                      //             Color(0xff7D8DFF),
                      //           ],
                      //         ),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.blue.withOpacity(.25),
                      //             blurRadius: 25,
                      //             offset: const Offset(0, 10),
                      //           )
                      //         ],
                      //       ),
                      //       child: const Icon(
                      //         Icons.notifications_rounded,
                      //         color: Colors.white,
                      //         size: 28,
                      //       ),
                      //     ),
                      //     const Spacer(),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(18),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.black.withOpacity(.05),
                      //             blurRadius: 15,
                      //           )
                      //         ],
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(
                      //           Icons.done_all_rounded,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      const SizedBox(height: 26),
                      const Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$unreadCount nouvelles notifications",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Dismissible(
                    key: ValueKey(notification.id),
                    direction: DismissDirection.endToStart,
                    background: const NotificationDeleteBackground(),
                    movementDuration: const Duration(milliseconds: 350),
                    confirmDismiss: (_) async {
                      HapticFeedback.mediumImpact();
                      return true;
                    },
                    onDismissed: (_) async {
                      final removed = notification;
                      final removedIndex = index;

                      setState(() {
                        notifications.removeAt(index);
                      });
                      await ProductService()
                          .deleteNotification(notification.id);

                      // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     behavior: SnackBarBehavior.floating,
                      //     margin: const EdgeInsets.all(20),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(18),
                      //     ),
                      //     content: const Text(
                      //       "Notification supprimée",
                      //     ),
                      //     action: SnackBarAction(
                      //       label: "ANNULER",
                      //       onPressed: () {
                      //         setState(() {
                      //           notifications.insert(
                      //             removedIndex,
                      //             removed,
                      //           );
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // );
                    },
                    child: showShimmers
                        ? ShimmersPage().statShimmer()
                        : NotificationCard(
                            notification: notification,
                            onTap: () async {
                              HapticFeedback.selectionClick();

                              setState(() {
                                notification.read = true;
                              });
                              await ProductService()
                                  .readNotification(notification.id);
                            },
                            onDelete: () {},
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final Notificationinterface notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  bool pressed = false;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: .96,
      upperBound: 1,
      value: 1,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Color get color {
    switch (widget.notification.type) {
      case NotificationType.order:
        return const Color(0xff4F7CFF);

      case NotificationType.payment:
        return const Color(0xff1DBA72);

      case NotificationType.warning:
        return const Color(0xffF59E0B);

      case NotificationType.message:
        return const Color(0xff8B5CF6);

      case NotificationType.success:
        return const Color(0xff14B86A);
    }
    return const Color(0xff14B86A);
  }

  IconData get icon {
    switch (widget.notification.type) {
      case NotificationType.order:
        return Icons.local_shipping_rounded;

      case NotificationType.payment:
        return Icons.payments_rounded;

      case NotificationType.warning:
        return Icons.warning_amber_rounded;

      case NotificationType.message:
        return Icons.chat_bubble_rounded;

      case NotificationType.success:
        return Icons.check_circle_rounded;
    }
    return Icons.check_circle_rounded;
  }

  String get badge {
    switch (widget.notification.type) {
      case NotificationType.order:
        return "Livraison";

      case NotificationType.payment:
        return "Paiement";

      case NotificationType.warning:
        return "Alerte";

      case NotificationType.message:
        return "Message";

      case NotificationType.success:
        return "Succès";
    }
    return "Succès";
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          pressed = true;
        });

        controller.reverse();
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });

        controller.forward();
      },
      onTapUp: (_) {
        setState(() {
          pressed = false;
        });

        controller.forward();

        widget.onTap();
      },
      child: ScaleTransition(
        scale: controller,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: notification.read ? Colors.white : const Color(0xffFDFEFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: notification.read
                  ? Colors.grey.shade200
                  : color.withOpacity(.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: color.withOpacity(.06),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(.65),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: notification.read ? 0 : 1,
                          child: Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: const Color(0xff3B82F6),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(.45),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.body,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: Colors.grey.shade500,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          notification.createdAt.substring(11, 16),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(.08),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationDeleteBackground extends StatelessWidget {
  const NotificationDeleteBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xffFF6B6B),
            Color(0xffFF3B30),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            "Supprimer",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
