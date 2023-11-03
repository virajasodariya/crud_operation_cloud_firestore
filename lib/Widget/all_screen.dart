import 'package:crud_operation_cloud_firestore/CloudFirestore/cloud_firestore.dart';
import 'package:crud_operation_cloud_firestore/StorageAudio/all_song.dart';
import 'package:crud_operation_cloud_firestore/StoragePdf/pdf_view.dart';
import 'package:crud_operation_cloud_firestore/VideoPlayer/all_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({super.key});

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Practice"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => CloudFirestoreScreen());
              },
              child: Text("Cloud Firestore"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => AllSongScreen());
              },
              child: Text("Songs"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => PdfScreen());
              },
              child: Text("Pdf"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => AllVideo());
              },
              child: Text("Video Player"),
            ),
          ],
        ),
      ),
    );
  }
}
