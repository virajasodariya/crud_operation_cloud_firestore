import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlaySongScreen extends StatefulWidget {
  final String songUrl;
  const PlaySongScreen({super.key, required this.songUrl});

  @override
  State<PlaySongScreen> createState() => _PlaySongScreenState();
}

class _PlaySongScreenState extends State<PlaySongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    String url = widget.songUrl;
    await audioPlayer.setSourceUrl(url);
    audioPlayer.play(UrlSource(url));
    isPlaying = true;
    setState(() {});
  }

  @override
  void initState() {
    setAudio();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            isPlaying != isPlaying;
          },
          child: Icon(isPlaying ? Icons.public : Icons.play_arrow),
        ),
      ),
    );
  }
}
