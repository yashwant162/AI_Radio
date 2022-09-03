import 'dart:convert';
import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_ai/model/radio.dart';
import 'package:radio_ai/utils/ai_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyRadio> radios = [];
  MyRadio? _selectedRadio;
  Color? _selectedColor;
  bool _isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
     super.initState();
     setupAlan();
     fetchRadios();

     _audioPlayer.onPlayerStateChanged.listen((event) {
       if(event == PlayerState.playing) {
         _isPlaying = true;
       } else{
         _isPlaying = false;
       }
       setState(() {});
     });
  }

  setupAlan(){
    AlanVoice.addButton(
        "bd3dbf0ccad1fd0651abf1183e2abe212e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

  }

  fetchRadios() async{
    await Future.delayed(Duration(seconds: 2));
    var radioJson = await rootBundle.loadString("assets/radio.json");
    //print(radioJson);
    var decodedData=jsonDecode(radioJson);
    var productData =decodedData["radios"];
    radios = List.from(productData).map<MyRadio>((radio) => MyRadio.fromMap(radio)).toList();
    //radios = await MyRadioList.fromJson(radioJson).radios;
    //print(radios);
    _selectedRadio = radios[0];
    _selectedColor = Color(int.parse(_selectedRadio!.color));
    setState(() {} );
  }

  _playMusic(String url, int id){
    _audioPlayer.play(UrlSource(url));
    //_audioPlayer.setSourceUrl(url);
    _selectedRadio = radios.firstWhere((element) => element.id == id);
    print(_selectedRadio!.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
                colors: [
                  AIColors.primaryColor1,
                  //Colors.blueAccent,
                  _selectedColor ?? AIColors.primaryColor2,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ))
              .make(),
          AppBar(
            title: "AI Radio".text.xl4.bold.make().shimmer(
              primaryColor: Vx.teal800,
              secondaryColor: Vx.gray900,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(120).p16(),

          (radios != null && radios.isNotEmpty) ?

              VxSwiper.builder(
                  itemCount: radios.length,
                  aspectRatio: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index){
                    final colorHex = radios[index].color;
                    _selectedColor = Color(int.parse(colorHex));
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final rad = radios[index];

                    return VxBox(child: ZStack([

                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        child:  VxBox(
                          child: rad.category.text.uppercase.white.make().px16(),
                        ).height(40).black.alignCenter.withRounded(value: 10).make(),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VStack(
                          [
                            rad.name.text.bold.white.xl3.make(),
                            5.heightBox,
                            rad.tagline.text.white.sm.semiBold.make(),

                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: [Icon(
                          CupertinoIcons.play_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                         10.heightBox,
                          "Double Tap to play".text.gray300.make(),
                        ].vStack()
                      )

                    ],
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(DecorationImage(
                          image: NetworkImage(rad.image),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                          )
                         )
                        )
                        .border(color: Colors.black,width: 5,)
                        .withRounded(value: 50,)
                        .make()
                        .onInkDoubleTap(() {
                          _playMusic(rad.url, rad.id);

                    })
                        .p16().centered();
                  },)
              :
          Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white,)
          ),
          //SizedBox(height: 5,),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
                 if(_isPlaying)
                      "Playing now - ${_selectedRadio!.name} FM"
                       .text.size(14).bold.cyan800.makeCentered().h(60),
              // Icon(
              // _isPlaying? CupertinoIcons.stop_circle
              //                   : CupertinoIcons.play_circle,
              // color: Colors.white,
              // size: 70.0,
              //        ).onInkTap(() {
              //     if(_isPlaying) {
              //     _audioPlayer.stop();
              //      } else{
              //      // var link = Uri.parse(_selectedRadio!.url);
              //       _playMusic(_selectedRadio!.url,_selectedRadio!.id);
              //     }
              // })
              Container(
                    padding: EdgeInsets.fromLTRB(3, 2, 0, 0),
                    width: 65,
                    height: 65,
                    child: Icon(
                      _isPlaying? CupertinoIcons.stop
                                              : CupertinoIcons.play,
                      size: 40,
                      color: AIColors.primaryColor2,

                    ).onInkTap(() {
                      if(_isPlaying) {
                      _audioPlayer.stop();
                       } else{
                       // var link = Uri.parse(_selectedRadio!.url);
                        _playMusic(_selectedRadio!.url,_selectedRadio!.id);
                      }
                  }),
                    decoration: BoxDecoration(
                      color: Color(0xff48c0a3),
                      borderRadius: BorderRadius.circular(54),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          // Color(0xff48c0a3),
                          // Color(0xff48c0a3),
                          AIColors.primaryColor1,
                          AIColors.primaryColor2,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AIColors.primaryColor1,
                          offset: Offset(-20.0, 20.0),
                          blurRadius: 55,
                          spreadRadius: 0.0,
                        ),
                        BoxShadow(
                          color: AIColors.primaryColor2,
                          offset: Offset(20.0, -20.0),
                          blurRadius: 55,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                  ),

            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
