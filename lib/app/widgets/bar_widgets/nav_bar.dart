import 'package:asocapp/app/config/config.dart';
import 'package:asocapp/app/services/session_service.dart';
import 'package:asocapp/app/resources/resources.dart';
import 'package:asocapp/app/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final SessionService session = Get.put<SessionService>(SessionService());

    return Drawer(
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                ' ${session.userConnected.userNameUser}',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryTextTextColor,
                ),
              ),
              accountEmail: Text(
                ' ${session.userConnected.shortNameAsoc}',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryTextTextColor,
                ),
              ),
              currentAccountPicture: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const ProfilePage());
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.blue.shade900,
                  backgroundImage: session.userConnected.avatarUser == '' ? null : NetworkImage(session.userConnected.avatarUser),
                  radius: 30,
                  child: session.userConnected.userNameUser == ''
                      ? null
                      : session.userConnected.avatarUser == ''
                          ? Text(
                              session.userConnected.userNameUser.substring(0, 2).toUpperCase(),
                              style: const TextStyle(fontSize: 30),
                            )
                          : null,
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  // background bar
                  image: NetworkImage(EglImagesPath.iconBackgroundDrawer),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (session.userConnected.profileUser == 'admin')
              ListTile(
                leading: const Icon(Icons.person_3),
                title: Text('cUsersList'.tr),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const ListUsersPage());
                },
              ),
            ListTile(
              leading: const Icon(Icons.note_add_outlined),
              title: Text('cNewArticle'.tr),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ListUsersPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('cNotifications'),
              trailing: ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      session.listUserMessages.isEmpty ? '' : session.listUserMessages.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('cSettings'.tr),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ProfilePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text('cPolices'.tr),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.key),
              title: Text('cChangePassword'.tr),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ChangePage());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('cExit'.tr),
              onTap: () {
                session.exitSession();
                Navigator.pop(context);
                Get.offAll(() => const LoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
