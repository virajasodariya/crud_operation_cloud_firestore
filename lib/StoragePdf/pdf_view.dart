import 'package:crud_operation_cloud_firestore/StoragePdf/open_pdf.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  Future<List<String>> getDownloadUrls() async {
    List<String> downloadUrls = [];
    final Reference storageRef = FirebaseStorage.instance.ref();
    final ListResult result = await storageRef.child('pdf').listAll();

    for (final Reference ref in result.items) {
      final url = await ref.getDownloadURL();
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All PDF")),
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
                        () => OpenPdf(pdfLink: "${snapshot.data![index]}"),
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
