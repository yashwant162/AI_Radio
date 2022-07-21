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
    List <MyRadio>? radios;
  @override
  void initState() {
     super.initState();
     fetchRadios();
  }
  fetchRadios() async{
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    print(radios);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
                colors: [
                  AIColors.primaryColor1,
                  //Colors.blueAccent,
                  AIColors.primaryColor2,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ))
              .make(),
          AppBar(
            title: "AI Radio".text.xl3.bold.make().shimmer(
              primaryColor: Colors.white,
              secondaryColor: Vx.orange400
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(120).p16()
        ],
      ),
    );
  }
}
