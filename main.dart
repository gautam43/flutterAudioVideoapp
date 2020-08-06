import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyVideoAudio());
}

class MyVideoAudio extends StatefulWidget {
  @override
  _MyVideoAudio createState() => _MyVideoAudio();
}

class _MyVideoAudio extends State<MyVideoAudio> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  static AudioPlayer audioPlayer = new AudioPlayer();
  AudioCache audioCache = new AudioCache(fixedPlayer: audioPlayer);
  int play_status = 0;
  int pause_status = 1;

  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://r1---sn-8vq54voxpo-w5pe.googlevideo.com/videoplayback?expire=1596707025&ei=cXwrX-_YL9ri-gbgwL3YAw&ip=212.40.116.88&id=o-AHYRsQjp2Hcb7uZlTI97UP-7i63lf_X2Aj5dWc6HvdLm&itag=18&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&gir=yes&clen=11868462&ratebypass=yes&dur=250.659&lmt=1540892345538540&fvip=1&fexp=23883098&c=WEB&txp=5431432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRAIgD8wSnddinUu4QTSUSa8THb6hcBoTRh9NjyDNf_HRaUcCICZHljz0hZ-1dWgpTF0KqXxZjhbasnQIt1QdmgkeVleJ&title=No+Arms%2C+No+Legs%2C+No+Worries%21&cms_redirect=yes&mh=8i&mip=1.39.200.12&mm=31&mn=sn-8vq54voxpo-w5pe&ms=au&mt=1596685354&mv=m&mvi=1&pl=22&lsparams=mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRQIgby93Tl3ydT1F9LlSeonxaBL53uWos65iuwG3BDrpUW4CIQDBX2yEwys0p68k5RelUNK9l_RlUmHJ_viJiGD10trgSg%3D%3D',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          title: Text("Audio and Video Players"),
          backgroundColor: Colors.orange.shade300,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: () => print('volume up')),
            IconButton(
                icon: Icon(Icons.audiotrack),
                onPressed: () => Fluttertoast.showToast(
                    msg: 'Symbol of audio Track',
                    textColor: Colors.orange.shade300,
                    backgroundColor: Colors.orange.shade100))
          ],
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            FloatingActionButton(
              backgroundColor: Colors.orange.shade300,
              onPressed: () {
                // Wrap the play or pause in a call to `setState`. This ensures the
                // correct icon is shown.
                setState(() {
                  // If the video is playing, pause it.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    Fluttertoast.showToast(
                        msg: "Video Paused",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.orange.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    // If the video is paused, play it.
                    _controller.play();
                    Fluttertoast.showToast(
                        msg: "Video Played",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.orange.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                });
              },
              // Display the correct icon depending on the state of the player.
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              //color: Colors.amber,
              //shadowColor: Colors.blue,
            ),
            Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF5usIP8ZYGVSuc6DXh8C8I-c1f8-oC3z49Z2OZqbfCVyT6uk&s'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                            backgroundColor: Colors.orange.shade300,
                            mini: true,
                            onPressed: () async {
                              if (play_status == 0 || pause_status == 1) {
                                audioCache.play('krishna.mp3');
                                play_status = 1;
                                pause_status = 0;
                              }
                              Fluttertoast.showToast(
                                  msg: "Audio Played",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Icon(Icons.play_arrow)),

                        FloatingActionButton(
                            backgroundColor: Colors.orange.shade300,
                            mini: true,
                            onPressed: () async {
                              if (play_status == 1 || pause_status == 0) {
                                audioPlayer.pause();
                                play_status = 0;
                                pause_status = 1;
                              }
                              Fluttertoast.showToast(
                                  msg: "Audio Paused",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Icon(Icons.pause)),
                        FloatingActionButton(
                            backgroundColor: Colors.orange.shade300,
                            mini: true,
                            onPressed: () async {
                              if (play_status == 1 || pause_status == 1) {
                                audioPlayer.stop();
                                play_status = 0;
                                pause_status = 0;
                              }
                              Fluttertoast.showToast(
                                  msg: "Audio Stopped",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red.shade200,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Icon(Icons.stop)),

                        //color: Colors.amber,
                        //shadowColor: Colors.blue,
                      ],
                    ),
                  ],
                )),
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7BUoK5VVlJDhUvZAt2YTOvmMT9cfOLslklq-7XJq2sQ5xPEo&s'),
                                fit: BoxFit.cover),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(50))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                            backgroundColor: Colors.orange.shade300,
                            mini: true,
                            onPressed: () async {
                              if (play_status == 0 || pause_status == 1) {
                                audioCache.play('babylaugh.mp3');
                                play_status = 1;
                                pause_status = 0;
                              }
                              Fluttertoast.showToast(
                                  msg: "Audio Played",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Icon(Icons.play_arrow)),

                        FloatingActionButton(
                            backgroundColor: Colors.orange.shade300,
                            mini: true,
                            onPressed: () async {
                              if (play_status == 1 || pause_status == 0) {
                                audioPlayer.pause();
                                play_status = 0;
                                pause_status = 1;
                              }
                              Fluttertoast.showToast(
                                  msg: "Audio Paused",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Icon(Icons.pause)),
                        FloatingActionButton(
                            backgroundColor: Colors.orange.shade300,
                            mini: true,
                            onPressed: () async {
                              if (play_status == 1 || pause_status == 1) {
                                audioPlayer.stop();
                                play_status = 0;
                                pause_status = 0;
                              }
                              Fluttertoast.showToast(
                                  msg: "Audio Stopped",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red.shade200,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Icon(Icons.stop)),

                        //color: Colors.amber,
                        //shadowColor: Colors.blue,
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
