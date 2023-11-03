import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:crud_operation_cloud_firestore/StorageAudio/play_song.dart';
import 'package:crud_operation_cloud_firestore/Widget/show_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSongScreen extends StatefulWidget {
  const AllSongScreen({super.key});

  @override
  State<AllSongScreen> createState() => _AllSongScreenState();
}

class _AllSongScreenState extends State<AllSongScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  AudioPlayer audioPlayer = AudioPlayer();
  String? url;

  bool audioUpload = false;

  Future<List<String>> fetchMp3Files() async {
    List<String> mp3Urls = [];

    var ref = FirebaseStorage.instance.ref().child('Audio');

    final result = await ref.listAll();

    for (var file in result.items) {
      String downloadURL = await file.getDownloadURL();
      mp3Urls.add(downloadURL);
    }

    return mp3Urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: audioUpload
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() {
                      audioUpload = true;
                    });
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['mp3'],
                    );
                    if (result != null) {
                      File file = File(result.files.single.path!);

                      TaskSnapshot snapshot = await storage
                          .ref('Audio/${result.files.single.name}')
                          .putFile(file);

                      url = await snapshot.ref.getDownloadURL();
                      log('URL  $url');
                    } else {
                      showToast("No file selected");
                    }
                    setState(() {
                      audioUpload = false;
                    });
                  } on FirebaseException catch (e) {
                    log('AUDIO UPLOAD ERROR CODE :: ${e.code}');
                    log('AUDIO UPLOAD ERROR MESSAGE :: ${e.message}');

                    showToast(e.code);
                    setState(() {
                      audioUpload = false;
                    });
                  }
                },
                child: const Text("upload"),
              ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await audioPlayer.play(AssetSource(
                'assets/audio/x2mate.com - Pasand Amari Pan Lajavab Che _ Apexa Pandya _ Mv Studio #short #shorts (128 kbps).mp3',
              ));
            },
            child: const Text(
              'play',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: fetchMp3Files(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No MP3 found'));
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text('MP3 File ${(index + 1)}'),
                  subtitle: Text(snapshot.data![index]),
                  onTap: () {
                    Get.to(() => PlaySongScreen(
                          songUrl: snapshot.data![index],
                        ));
                    // await player.play(UrlSource(snapshot.data![index]));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
