import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/widget/drawer.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class VerificationPage extends StatelessWidget {
  VerificationPage({Key key}) : super(key: key);
  StorageService storageService = Get.find();
  GlobalKey<ScaffoldState> k = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: k,
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            25.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome,\n${storageService.currentFireStoreUser['fullName'] ?? "Doctor"}",
                  textAlign: TextAlign.left,
                  style: headline,
                ),
                Icon(
                  Icons.menu,
                  color: Utils.mainColor,
                )
                    .p(16)
                    .box
                    .color(Utils.mainColor.withOpacity(0.1))
                    .roundedFull
                    .make()
                    .onTap(() {
                  k.currentState.openDrawer();
                }),
              ],
            ),
            Spacer(),
            Icon(
              EvaIcons.clipboard,
              color: Utils.mainColor,
              size: 75,
            )
                .p(30)
                .box
                .color(Utils.mainColor.withOpacity(0.1))
                .make()
                .cornerRadius(100),
            20.heightBox,
            Text(
              "Thank you for registeration",
              style:
                  GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            10.heightBox,
            Text(
                "Our team will review your profile and verify you within 24 hours.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontSize: 16, fontWeight: FontWeight.w400)),
            100.heightBox,
            Spacer(),
          ],
        ).px(16),
      ),
    );
  }
}
