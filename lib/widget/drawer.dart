import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/authService.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/AuthWrapper.dart';
import 'package:dappointment/screen/profileScreen.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:material_dialogs/material_dialogs.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key key}) : super(key: key);
  StorageService storageService = Get.find();
  @override
  Widget build(BuildContext context) {
    print(storageService.currentFireStoreUser.toString());
    // print(storageService.user.uid.toString());
    return Drawer(
        child: Obx(
      () => SafeArea(
        child: Column(
          children: [
            18.heightBox,
            CircleAvatar(
              backgroundColor: Utils.mainColor.withOpacity(0.1),
              radius: 60,
              foregroundImage: storageService
                      .currentFireStoreUser['profilePhoto']
                      .toString()
                      .isNotEmpty
                  ? NetworkImage(
                      storageService.currentFireStoreUser['profilePhoto'])
                  : null,
              child: Icon(
                EvaIcons.personOutline,
                color: blue,
                size: 80,
              ),
            ),
            12.heightBox,
            Text(
              storageService.currentFireStoreUser['fullName'] ?? "user",
              style: subtitle1,
            ),
            12.heightBox,
            ListTile(
              onTap: () {
                context.push((context) => ProfilePage());
              },
              visualDensity: VisualDensity.compact,
              title: Text(
                "Profile",
                style: navItemStyle,
              ),
              leading: Icon(
                EvaIcons.personOutline,
                color: Colors.black87,
              ),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              onTap: () {
                Dialogs.materialDialog(
                    msg: 'Are you sure to logout?',
                    title: "Logout",
                    color: Colors.white,
                    msgStyle: bodyText2,
                    titleStyle: subtitle1.copyWith(fontWeight: FontWeight.bold),
                    context: context,
                    actions: [
                      IconsOutlineButton(
                        onPressed: () {
                          context.pop();
                        },
                        text: 'Cancel',
                        iconData: EvaIcons.close,
                        textStyle: TextStyle(color: Colors.grey),
                        iconColor: Colors.grey,
                      ),
                      IconsButton(
                        onPressed: () async {
                          await AuthenticationService(FirebaseAuth.instance)
                              .signOut();
                          storageService.dispose();
                          BotToast.showText(text: "Logged out succesfully.");
                          context.nextAndRemoveUntilPage(AuthWrapper());
                        },
                        text: 'Logout',
                        iconData: EvaIcons.logOutOutline,
                        color: Colors.red,
                        textStyle: TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
              },
              title: Text(
                "Logout",
                style: navItemStyle,
              ),
              leading: Icon(
                EvaIcons.logOutOutline,
                color: Colors.black87,
              ),
            ),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    ));
  }
}
