// ignore_for_file: prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

// import 'package:musicify/assets/radio.json';
import 'package:musicify/models/radio.dart';
import 'package:musicify/utils/ai_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyRadio>? radios;
  MyRadio? _selectedRadio;
  Color? _selectedColor;
  bool _isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    setState(() {});
  }

  playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios!.firstWhere((element) => element.url == url);
    print(_selectedRadio?.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                    colors: [AIColor.primaryColor1, AIColor.primaryColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              )
              .make(),
          AppBar(
            title: "Musify".text.xl4.bold.white.make().shimmer(
                primaryColor: Color.fromARGB(255, 180, 221, 254),
                secondaryColor: Color.fromARGB(255, 88, 168, 131)),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(120),
          // ignore: unnecessary_null_comparison
          radios != null
              ? VxSwiper.builder(
                  itemCount: radios!.length,
                  enlargeCenterPage: true,
                  itemBuilder: (context, index) {
                    final rad = radios![index];
                    return VxBox(
                      child: ZStack(
                        [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: VxBox(
                              child: rad.lang.text.uppercase.bold.white
                                  .make()
                                  .px16(),
                            )
                                .height(40)
                                .black
                                .alignCenter
                                .withRounded(value: 10)
                                .make(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VStack(
                              [
                                rad.name.text.xl5.white.bold.make(),
                                5.heightBox,
                                rad.tagline.text.xl.white.bold.italic.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: [
                              const Icon(
                                CupertinoIcons.play_circle,
                                color: Colors.white54,
                                size: 60,
                              ),
                              10.heightBox,
                              "DOUBLE TAB TO PLAY".text.gray300.make()
                            ].vStack(),
                          ),
                        ],
                      ),
                    )
                        .clip(Clip.antiAlias)
                        .bgImage(
                          DecorationImage(
                            image: NetworkImage(rad.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                          ),
                        )
                        .border(color: Colors.black, width: 3)
                        .withRounded(value: 60.0)
                        .make()
                        .onInkDoubleTap(() {
                      _audioPlayer.play(rad.url);
                    }).p16();
                  },
                  aspectRatio: 1.0,
                ).centered()
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing - ${_selectedRadio?.name} FM"
                    .text
                    .white
                    .makeCentered(),
              Icon(
                _isPlaying
                    ? CupertinoIcons.stop_circle
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50,
              ).onInkTap(() {
                if (_isPlaying) {
                  _audioPlayer.stop();
                } else {
                  _audioPlayer.play(_selectedRadio!.url);
                }
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
