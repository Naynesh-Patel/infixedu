// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:badges/badges.dart' as bz;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Saksham/controller/system_controller.dart';
import 'package:Saksham/controller/user_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:themify_flutter/themify_flutter.dart';

// Project imports:
import 'package:Saksham/controller/notification_controller.dart';
import 'package:Saksham/screens/main/NotificationsScreen.dart';
import 'package:Saksham/screens/main/student/DBStudentFees.dart';
import 'package:Saksham/screens/main/student/DBStudentProfile.dart';
import 'package:Saksham/screens/main/student/DBStudentRoutine.dart';
import 'package:Saksham/screens/main/teacher/DBTeacherAcademic.dart';
import 'package:Saksham/screens/main/teacher/DBTeacherHW.dart';
import 'package:Saksham/screens/parent/ChildDashboardScreen.dart';
import 'package:Saksham/utils/FunctinsData.dart';
import 'package:Saksham/utils/Utils.dart';
import '../Home.dart';
import 'teacher/DBTeacherAttendance.dart';

class DashboardScreen extends StatefulWidget {
  final titles;
  final images;
  final role;
  final childUID, image, token, childName, childId;

  const DashboardScreen(this.titles, this.images, this.role,
      {Key? key, this.childUID, this.image, this.token, this.childName, this.childId}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final UserController userController = Get.put(UserController());
  final NotificationController controller = Get.put(NotificationController());
  final SystemController _systemController = Get.put(SystemController());

  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  String _id = '';

  static Future<bool> _popCamera(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.red,
            ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.green,
            ),
      ),
      onPressed: () async {
        SystemNavigator.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Logout",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: const Text("Would you like to logout?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: true);
    return Future.value(false);
  }

  int _studentId = 0;
  Future initate() async {
    print("ROLE ID ${widget.role} ${widget.role.runtimeType}");

    await Utils.getStringValue('id').then((value) async {
      setState(() {
        _id = value ?? '';
      });
      if (widget.role == "3" || widget.role == "2") {
        if (widget.role == "3") {
          userController.studentId.value = widget.childId;
        } else {
          await Utils.getIntValue('studentId').then((studentIdVal) async {
            setState(() {
              _studentId = studentIdVal ?? 0;
            });
          });
          userController.studentId.value = _studentId;
        }
        await userController.getStudentRecord();
      }
    });
    await controller.getNotifications();
  }

  @override
  void initState() {
    initate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _popCamera(context),
      child: Obx(() {
        return _systemController.isLoading.value
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : PersistentTabView(
                context,
                controller: persistentTabController,
                screens: [
                  widget.role == "3"
                      ? ChildHome(
                          AppFunction.students,
                          AppFunction.studentIcons,
                          widget.childUID,
                          widget.image,
                          widget.token,
                          widget.childName)
                      : Home(widget.titles, widget.images, widget.role),
                  NotificationScreen(_id),
                  widget.role == "4"
                      ? DashboardTeacherAttendance(AppFunction.attendance, AppFunction.attendanceIcons)
                      : DBStudentFees(
                          id: widget.role == "3"
                              ? widget.childUID.toString()
                              : _id.toString(),
                        ),
                  widget.role == "4"
                      ? DBTeacherAcademic(
                          AppFunction.academics, AppFunction.academicsIcons)
                      : DBStudentRoutine(
                          id: widget.role == "3"
                              ? widget.childUID.toString()
                              : _id.toString(),
                        ),
                  widget.role == "4"
                      ? DBTeacherHW(
                          AppFunction.homework, AppFunction.homeworkIcons)
                      : DBStudentProfile(
                          id: widget.role == "3"
                              ? widget.childUID.toString()
                              : _id.toString(),
                          image: widget.image,
                        ),
                ],
                items: [
                  PersistentBottomNavBarItem(
                    inactiveIcon: Icon(
                      Themify.home,
                      size: 18.sp,
                    ),
                    icon: Icon(
                      Themify.home,
                      size: 18.sp,
                    ),
                    title: "Home".tr,
                    activeColorPrimary:  const Color(0xff261C59).withOpacity(0.9),
                    inactiveColorPrimary: Colors.grey.withOpacity(0.9),
                  ),
                  PersistentBottomNavBarItem(
                    inactiveIcon: Obx(() {
                      if (controller.isLoading.value) {
                        return bz.Badge(
                          badgeContent: Text(
                            '0',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          badgeStyle: bz.BadgeStyle(
                            badgeColor:  const Color(0xff261C59).withOpacity(0.9),
                          ),
                          // badgeAnimation: BadgeAnimationType.fade,
                          // toAnimate: false,
                          badgeAnimation: const bz.BadgeAnimation.fade(
                            animationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                          ),
                          child: Icon(
                            Themify.bell,
                            size: 22.sp,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                        );
                      }
                      return bz.Badge(
                        badgeContent: Text(
                          '${controller.notificationCount.value}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        // badgeColor: Colors.deepPurple,
                        badgeStyle:  bz.BadgeStyle(
                          badgeColor:   const Color(0xff261C59).withOpacity(0.9),
                        ),
                        // animationType: bz.BadgeAnimationType.fade,
                        badgeAnimation: const bz.BadgeAnimation.fade(
                          // animationDuration: Duration(seconds: 1),
                        ),
                        child: Icon(
                          Themify.bell,
                          size: 22.sp,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      );
                    }),
                    icon: Obx(() {
                      if (controller.isLoading.value) {
                        return bz.Badge(
                          showBadge: false,
                          // badgeColor: Colors.deepPurple.withOpacity(0.8),
                          // animationType: bz.BadgeAnimationType.fade,
                          // toAnimate: false,
                          badgeStyle: bz.BadgeStyle(
                            badgeColor:  const Color(0xff261C59).withOpacity(0.9),
                          ),
                          // badgeAnimation: BadgeAnimationType.fade,
                          // toAnimate: false,
                          badgeAnimation: const bz.BadgeAnimation.fade(
                            animationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                          ),
                          child: Icon(
                            Themify.bell,
                            size: 22.sp,
                            color:  const Color(0xff261C59).withOpacity(0.9),
                          ),
                        );
                      }
                      return bz.Badge(
                        badgeContent: Text(
                          '${controller.notificationCount.value}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        // badgeColor: Colors.deepPurple,
                        // animationType: bz.BadgeAnimationType.fade,
                        badgeStyle:  bz.BadgeStyle(
                          badgeColor:   Color(0xff261C59).withOpacity(0.9),
                        ),
                        badgeAnimation: const bz.BadgeAnimation.fade(),
                        child: Icon(
                          Themify.bell,
                          size: 22.sp,
                          color:  const Color(0xff261C59).withOpacity(0.9),
                        ),
                      );
                    }),
                    title: "Notification".tr,
                    activeColorPrimary: const Color(0xff261C59).withOpacity(0.9),
                    inactiveColorPrimary: Colors.grey.withOpacity(0.9),
                  ),
                  PersistentBottomNavBarItem(
                    inactiveIcon: widget.role == "4"
                        ? Image.asset(
                            "assets/images/classattendance.png",
                            width: 25.w,
                            height: 25.h,
                            color: Colors.white,
                          )
                        : Image.asset(
                            "assets/images/fees_icon.png",
                            width: 25.w,
                            height: 25.h,
                            color: Colors.white,
                          ),
                    icon: widget.role == "4"
                        ? Image.asset(
                            "assets/images/classattendance.png",
                            width: 25.w,
                            height: 25.h,
                            color: Colors.white,
                          )
                        : Image.asset(
                            "assets/images/fees_icon.png",
                            width: 25.w,
                            height: 25.h,
                            color: Colors.white,
                          ),
                    title: widget.role == "4" ? "Attendance".tr : "Donations".tr,
                    activeColorPrimary: const Color(0xff261C59).withOpacity(0.9),
                    inactiveColorPrimary: Colors.grey.withOpacity(0.9),
                  ),
                  PersistentBottomNavBarItem(
                    inactiveIcon: widget.role == "4"
                        ? Image.asset(
                            "assets/images/academics.png",
                            width: 30.w,
                            height: 30.h,
                            color: Colors.grey.withOpacity(0.9),
                          )
                        : Image.asset(
                            "assets/images/routine.png",
                            width: 30.w,
                            height: 30.h,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                    icon: widget.role == "4"
                        ? Image.asset(
                            "assets/images/academics.png",
                            width: 30.w,
                            height: 30.h,
                            color:  const Color(0xff261C59).withOpacity(0.9),
                          )
                        : Image.asset(
                            "assets/images/routine.png",
                            width: 30.w,
                            height: 30.h,
                            color:  const Color(0xff261C59).withOpacity(0.9),
                          ),
                    title: widget.role == "4" ? "Academic".tr : "Routine".tr,
                    activeColorPrimary:  const Color(0xff261C59).withOpacity(0.9),
                    inactiveColorPrimary: Colors.grey.withOpacity(0.9),
                  ),
                  PersistentBottomNavBarItem(
                    inactiveIcon: widget.role == "4"
                        ? Image.asset(
                            "assets/images/homework.png",
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey.withOpacity(0.9),
                          )
                        : Image.asset(
                            "assets/images/profile.png",
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                    icon: widget.role == "4"
                        ? Image.asset(
                            "assets/images/homework.png",
                            width: 25.w,
                            height: 25.h,
                            color:  const Color(0xff261C59).withOpacity(0.9),
                          )
                        : Image.asset(
                            "assets/images/profile.png",
                            width: 25.w,
                            height: 25.h,
                            color: const Color(0xff261C59).withOpacity(0.9),
                          ),
                    title: widget.role == "4" ? "Assignment".tr : "Profile".tr,
                    activeColorPrimary:   const Color(0xff261C59).withOpacity(0.9),
                    inactiveColorPrimary: Colors.grey.withOpacity(0.9),
                  ),
                ],
                hideNavigationBar: false,
                navBarHeight: 70,
                margin: const EdgeInsets.all(0),
                padding: const NavBarPadding.symmetric(horizontal: 5),
                confineInSafeArea: true,
                backgroundColor: Colors.white,
                handleAndroidBackButtonPress: true,
                resizeToAvoidBottomInset: true,
                stateManagement: false,
                hideNavigationBarWhenKeyboardShows: true,
                onItemSelected: (index) async {
                  if (index == 1) {
                    await controller.getNotifications();
                  }
                },
                decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  colorBehindNavBar: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: const ItemAnimationProperties(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: const ScreenTransitionAnimation(
                  animateTabTransition: false,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle.style15,
              );
      }),
    );
  }
}
