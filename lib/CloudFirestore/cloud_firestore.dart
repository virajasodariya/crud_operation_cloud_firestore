import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operation_cloud_firestore/Widget/show_toast.dart';
import 'package:crud_operation_cloud_firestore/Widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloudFirestoreScreen extends StatefulWidget {
  const CloudFirestoreScreen({super.key});

  @override
  State<CloudFirestoreScreen> createState() => _CloudFirestoreScreenState();
}

class _CloudFirestoreScreenState extends State<CloudFirestoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController age = TextEditingController();

  CollectionReference user = FirebaseFirestore.instance.collection('UserData');

  Center buildBody() {
    return Center(
      child: StreamBuilder(
        stream: user.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('ERROR : ${snapshot.error}');
          } else {
            var userData = snapshot.data!.docs;

            return allContactListView(userData);
          }
        },
      ),
    );
  }

  ListView allContactListView(List<QueryDocumentSnapshot<Object?>> userData) {
    return ListView.builder(
      itemCount: userData.length,
      itemBuilder: (context, index) {
        var item = userData[index];
        return ListTile(
          leading: IconButton(
            onPressed: () {
              buildDeleteDialog(item);
            },
            icon: const Icon(Icons.delete),
          ),
          title: Text("${item.get('First Name')} ${item.get('Last Name')}"),
          subtitle: Text("${item.get('Age')}"),
          trailing: IconButton(
            onPressed: () {
              buildUpdateDialog(item);
            },
            icon: const Icon(Icons.edit),
          ),
        );
      },
    );
  }

  /// app bar
  AppBar buildAppBar() {
    return AppBar(
      title: appBarTitle(),
      actions: appBarActions(),
    );
  }

  /// app bar title
  Text appBarTitle() => const Text('Contact Book');

  /// app bar actions
  List<Widget> appBarActions() {
    return [
      TextButton(
        onPressed: () {
          Get.dialog(
            Form(
              key: formKey,
              child: AlertDialog(
                title: const Text("Create/Write Data"),
                actions: [
                  allTextField(),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await uploadData();
                      }
                    },
                    child: const Text('submit'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Text(
          "click to new data",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];
  }

  /// first time data upload
  Future<void> uploadData() async {
    try {
      Map<String, dynamic> uploadData = {
        "First Name": firstName.text,
        "Last Name": lastName.text,
        "Age": age.text,
      };

      await user.add(uploadData);

      showToast('success');

      firstName.clear();
      lastName.clear();
      age.clear();

      Get.back();
    } catch (e) {
      showToast('$e');
      log("ERROR WHILE CREATE DATA : $e");
    }
  }

  /// delete data
  Future<dynamic> buildDeleteDialog(QueryDocumentSnapshot<Object?> item) {
    return Get.dialog(
      AlertDialog(
        title: const Text("Delete Data"),
        actions: [
          ElevatedButton(
            onPressed: () {
              user.doc(item.id).delete();

              Get.back();
            },
            child: const Text("delete"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }

  /// update data
  Future<void> updateData(QueryDocumentSnapshot<Object?> item) async {
    try {
      Map<String, dynamic> updateData = {
        "First Name": firstName.text,
        "Last Name": lastName.text,
        "Age": age.text,
      };

      await user.doc(item.id).update(updateData);

      showToast('success');

      firstName.clear();
      lastName.clear();
      age.clear();

      Get.back();
    } catch (e) {
      showToast('$e');
      log("ERROR WHILE CREATE DATA : $e");
    }
  }

  /// update ui screen
  Future<dynamic> buildUpdateDialog(QueryDocumentSnapshot<Object?> item) {
    return Get.dialog(
      Form(
        key: formKey,
        child: AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const Text('update data'),
            ],
          ),
          actions: [
            allTextField(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await updateData(item);
                  }
                },
                child: const Text("submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allTextField() {
    return Column(
      children: [
        CommonTextFormField(
            keyboardType: TextInputType.name,
            controller: firstName,
            hintText: 'Enter your First Name',
            icon: Icons.account_circle),
        CommonTextFormField(
            keyboardType: TextInputType.name,
            controller: lastName,
            hintText: 'Enter your Last Name',
            icon: Icons.account_circle_outlined),
        CommonTextFormField(
            keyboardType: TextInputType.number,
            controller: age,
            hintText: 'Enter your Age',
            icon: Icons.cake),
      ],
    );
  }
}
