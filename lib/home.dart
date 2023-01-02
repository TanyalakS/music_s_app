import 'package:flutter/material.dart';
import 'package:music_s_app/music_list_card.dart';
import 'package:audioplayers/audioplayers.dart';

import 'music_item/music_item.dart';

//after the song fix icon 'pause' // make screen looks finish
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List musicItem = MusicItem().musicItem;
  String currentTitle = '';
  String currentSinger = '';
  String currentImage = '';

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isJustOpenApp = true;
  bool isCompleted = true;
  String currentSong = "";
  int? playingSongIndex;
  Duration duration = const Duration(seconds: 0);
  Duration position = const Duration(seconds: 0);

  playMusic(int index) {
    //play music
    audioPlayer.play(UrlSource(musicItem[index]['url']));
   
    //slider event
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Playlist'),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: musicItem.length,
              itemBuilder: (context, index) => MusicListCard(
                title: musicItem[index]['title'],
                artist: musicItem[index]['artist'],
                imagePath: musicItem[index]['imagePath'] ?? "",
                onTap: () {
                  playMusic(index);
                  setState(() {
                    isJustOpenApp = false;
                    isPlaying = true;
                    currentTitle = musicItem[index]['title'];
                    currentSinger = musicItem[index]['artist'];
                    currentImage = musicItem[index]['imagePath'];
                    playingSongIndex = index;
                  });
                },
              ),
            ),
          ),
          if (!isJustOpenApp) ...[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x55212121),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Slider.adaptive(
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble() + 1,
                      onChanged: (value) {
                        audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                image: DecorationImage(
                                  image: AssetImage(currentImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentTitle,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  currentSinger,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (isPlaying) {
                                  audioPlayer.pause();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                } else {
                                  audioPlayer.resume();
                                  setState(() {
                                    isPlaying = true;
                                  });
                                }
                              },
                              icon: isPlaying == true
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                            ),
                            IconButton(
                              onPressed: () {
                                if(playingSongIndex! < musicItem.length - 2){
                                setState(() {
                                  playingSongIndex = playingSongIndex! + 1;
                                  currentTitle =
                                      musicItem[playingSongIndex!]['title'];
                                  currentSinger =
                                      musicItem[playingSongIndex!]['artist'];
                                  currentImage =
                                      musicItem[playingSongIndex!]['imagePath'];
                                });
                                audioPlayer.play(UrlSource(
                                    musicItem[playingSongIndex!]['url']));
                                }else{
                                  audioPlayer.stop();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                }
                              },
                              icon: const Icon(Icons.skip_next),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
