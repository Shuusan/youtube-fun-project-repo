import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_project/constants/interface_constant.dart';
import 'package:fun_project/controllers/led_strip_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fun Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xff385a7c),
          textTheme: TextTheme(
            headline2: GoogleFonts.openSans(
              fontSize: 24,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
            headline3: GoogleFonts.openSans(
              fontSize: 21,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
            headline4: GoogleFonts.openSans(
              fontSize: 18,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
            headline5: GoogleFonts.openSans(
              fontSize: 14,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
            bodyText1: GoogleFonts.openSans(
              fontSize: 14,
              color: const Color(0xff636363),
              fontWeight: FontWeight.w700,
            ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final LedStripController controller = Get.put(LedStripController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff152b40),
        title: Text(
          'FUN PROJECT',
          style: GoogleFonts.openSans(
            fontSize: 22,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TitleBar(),
            for (String mode in ledStripMode)
              Obx(() => GestureDetector(
                    onTap: () {
                      controller.changeMode(mode);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 450),
                        width: mode == controller.chosenMode ? Get.width * 0.9 : Get.width * 0.75,
                        height: mode == controller.chosenMode ? Get.height * 0.1 : Get.height * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: mode == controller.chosenMode ? Color(0xff8AD6CC) : const Color(0xffb2eee6),
                        ),
                        child: AnimatedAlign(
                          duration: Duration(milliseconds: 450),
                          alignment: mode == controller.chosenMode ? Alignment.center : Alignment.centerLeft,
                          child: Padding(
                            padding: mode == controller.chosenMode ? EdgeInsets.zero : const EdgeInsets.only(left: 8.0),
                            child: Text(
                              mode,
                              style: GoogleFonts.openSans(
                                fontSize: mode == controller.chosenMode ? 20 : 14,
                                color: mode == controller.chosenMode ? Colors.white : const Color(0xff636363),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Text(
                    'Brightness',
                    style: context.textTheme.headline5,
                  ),
                  Obx(
                    () => Slider(
                      value: controller.brightnessLed,
                      onChanged: (value) {
                        controller.brightnessLed = value;
                      },
                      min: 0,
                      max: 225,
                      activeColor: const Color(0xfff97171),
                      onChangeEnd: (value) {
                        controller.dbRealtime.child("LedStrips").update({"brightness": value.round()});
                      },
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'Frame/Second',
                  style: context.textTheme.headline5,
                ),
                Obx(
                  () => Slider(
                    value: controller.framePerSecond,
                    onChanged: (value) {
                      controller.framePerSecond = value;
                    },
                    min: 0,
                    max: 225,
                    activeColor: const Color(0xfff97171),
                    onChangeEnd: (value) {
                      controller.dbRealtime.child("LedStrips").update({"fps": value.round()});
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: Get.width * 0.3,
            height: 6.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffb2eee6),
            ),
          ),
          Text('LED STRIP', style: context.textTheme.headline4),
          Container(
            width: Get.width * 0.3,
            height: 6.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffb2eee6),
            ),
          ),
        ],
      ),
    );
  }
}
