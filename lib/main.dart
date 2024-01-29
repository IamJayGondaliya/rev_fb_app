import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rev_fb_app/firebase_options.dart';
import 'package:rev_fb_app/helpers/fb_helper.dart';
import 'package:rev_fb_app/modals/user_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FB App"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder(
            stream: FbHelper.fbHelper.getUsers(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                QuerySnapshot? snaps = snapShot.data;
                List<QueryDocumentSnapshot> data = snaps?.docs ?? [];
                List<UserModal> allUsers = data
                    .map(
                      (e) => UserModal.fromMap(data: e.data() as Map),
                    )
                    .toList();

                return ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      UserModal user = allUsers[index];

                      return Card(
                        child: ExpansionTile(
                          leading: Text(user.uId.toString()),
                          title: Text(user.name),
                          trailing: Text(user.age.toString()),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    user.name = "NewName";
                                    FbHelper.fbHelper.editUser(userModal: user);
                                  },
                                  child: const Text("EDIT"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    FbHelper.fbHelper
                                        .deleteUser(userModal: user);
                                  },
                                  child: const Text("DELETE"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int uId = DateTime.now().millisecondsSinceEpoch;
            UserModal userModal = UserModal(
              uId,
              "Aman",
              18,
            );

            FbHelper.fbHelper.addUser(userModal: userModal);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
