import 'package:crud_operation_cloud_firestore/VideoPlayer/play_video.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllVideo extends StatefulWidget {
  const AllVideo({super.key});

  @override
  State<AllVideo> createState() => _AllVideoState();
}

class _AllVideoState extends State<AllVideo> {
  Future<List<String>> getDownloadUrls() async {
    List<String> downloadUrls = [];
    final Reference storageRef = FirebaseStorage.instance.ref();
    final ListResult result = await storageRef.child('video').listAll();

    for (final Reference ref in result.items) {
      final url = await ref.getDownloadURL();
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Video")),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: getDownloadUrls(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final downloadUrls = snapshot.data;
              return ListView.builder(
                itemCount: downloadUrls!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Get.to(
                        () => VideoApp(videoLink: "${snapshot.data![index]}"),
                      );
                    },
                    leading: Icon(Icons.picture_as_pdf_outlined),
                    title: Text(downloadUrls[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
