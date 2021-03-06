import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:settings_ui/settings_ui.dart';
// import 'package:path/path.dart' as p;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/brightness.dart';
import 'package:smart_home/change_pass.dart';
import 'package:smart_home/models/users.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/view/home/menu_widget.dart';
import 'package:smart_home/widgets/show_alert_dialog.dart';
import 'package:smart_home/widgets/widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSelected = false;

  File? file;

  Future<void> selectFile(String id) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result == null) {
      return;
    } else {
      final path = result.files.single.path!;
      setState(() {
        file = File(path);
        isSelected = true;
      });
      _upload(id);
    }
  }

  _upload(String id) async {
    final database = Provider.of<Database>(context, listen: false);
    // String path = p.basename(file!.path);
    var imageFile =
        FirebaseStorage.instance.ref().child("profileImage").child(id);
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    database.addImage(uId: id, url: url);
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;

    var lockInBackground;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: MenuWidget(),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFecf5fb),
      body: SafeArea(
        child: /*Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
                width: 100.w,
                child: StreamBuilder<Users?>(
                    stream: db.getUser(id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 3,
                                ),
                              ),
                              child: snapshot.data!.photoURL.isEmpty
                                  ? InkWell(
                                      onTap: () {
                                        selectFile(id);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.black54,
                                            width: 3,
                                          ),
                                        ),
                                        child: const CircleAvatar(
                                          radius: 50,
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: snapshot.data!.photoURL,
                                      ),
                                    ),
                            ),
                            Center(
                              child: Text(snapshot.data!.name),
                            )
                          ],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black54,
                                width: 3,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.account_circle,
                                size: 50,
                              ),
                            ));
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black54,
                              width: 3,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.account_circle,
                              size: 50,
                            ),
                          ),
                        );
                      }
                    }),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                // height: 80.h,
                // width: 100.h,
                child: ElevatedButton(
                  onPressed: () {
                    _signOut(context);
                  },
                  child: const Text("out"),
                ),
              ),
            ],
          ),
        ),*/
            Container(
          decoration: BoxDecoration(color: Color(0xFFecf5fb)),
          //  color: Color(0xFFecf5fb),
          child: SettingsList(
            lightTheme: SettingsThemeData(
                settingsListBackground: Color(0xFFecf5fb),
                settingsSectionBackground: Color(0xFFecf5fb)),
            sections: [
              SettingsSection(
                title: Text('Common'),
                tiles: [
                  SettingsTile(
                    title: Text('Language'),
                    description: Text('English'),
                    leading: Icon(Icons.language),
                  ),
                  SettingsTile(
                    title: Text("Change Brightness"),
                    leading: Icon(Icons.brightness_4),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Brightness())),
                    ),
                  )
                ],
              ),
              SettingsSection(
                title: Text('Account'),
                tiles: [
                  SettingsTile(
                      title: Text('Phone number'), leading: Icon(Icons.phone)),
                  SettingsTile(
                      title: Text('Email'), leading: Icon(Icons.email)),
                  SettingsTile(
                      onPressed: (context) => _signOut(context),
                      title: Text('Sign out'),
                      leading: Icon(Icons.exit_to_app)),
                ],
              ),
              SettingsSection(
                title: Text('Secutiry'),
                tiles: [
                  SettingsTile(
                    title: Text('Change password'),
                    leading: Icon(Icons.lock),
                    //switchValue: true,
                    trailing: IconButton(
                      icon: Icon(Icons.navigate_next),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword())),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signOut(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      auth.signOut();
    } on FirebaseAuthException catch (e) {
      showAlertDialog(
        context,
        title: "Error",
        content: e.message.toString(),
        defaultActionText: "OK",
      );
    }
  }
}
