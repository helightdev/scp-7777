import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heptaphobia/background_painter.dart';
import 'package:heptaphobia/encoder.dart';
import 'package:heptaphobia/header_painter.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() => Stream.value(const LicenseEntryWithLineBreaks(
      <String>["SCP-7777"],
      "\"SCP-7777\" by Yossipossi, from the SCP Wiki. Source: https://scpwiki.com/scp-7777. Licensed under CC-BY-SA.")));
  runApp(const HeptaphobiaApp());
}

Color raisaLight = const Color(0xFFf6f6a6);
Color raisaPrimary = const Color(0xFFa2a239);
Color barColor = const Color(0xFF282805);
Color backgroundColor = const Color(0xFFfcfcfc);
Gradient raisaGradient = const LinearGradient(colors: [Color(0xFFe1c64d), Color(0xFFcaca72)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
Gradient backgroundGradient = LinearGradient(colors: [raisaLight, backgroundColor], begin: Alignment.topCenter, end: Alignment.bottomCenter);
TextStyle barTextStyle = TextStyle(color: raisaPrimary, fontSize: 14);

var boxBorder = OutlineInputBorder(
  borderSide: BorderSide(color: raisaPrimary, width: 2),
  borderRadius: BorderRadius.zero,
);

var inputBoxDecoration = InputDecoration(
  border: boxBorder,
  enabledBorder: boxBorder,
  focusedBorder: boxBorder,
  fillColor: barColor,
  labelStyle: TextStyle(color: raisaPrimary),
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
);

var buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(barColor),
  foregroundColor: MaterialStateProperty.all(raisaPrimary),
  shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
);

class HeptaphobiaApp extends StatelessWidget {
  const HeptaphobiaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heptaphobia Cipher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFa2a239)),
        useMaterial3: true,
        textTheme: GoogleFonts.oxaniumTextTheme(),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController inputController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var displaySize = queryData.size;
    var formWidth = min(displaySize.width - 32, 700.0);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(displaySize.width, 100 + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomPaint(
                painter: RaisaHeaderPainter(),
                child: switch (queryData.orientation) {
                  Orientation.portrait => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildHeaderRow(),
                    ),
                  Orientation.landscape => Center(
                      child: SizedBox(
                        width: displaySize.width * 0.5,
                        child: _buildHeaderRow(),
                      ),
                    ),
                },
              ),
            ),
            _buildNavBar(context),
          ],
        ),
      ),
      body: CustomPaint(
        painter: RaisaBackgroundPainter(),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: formWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 16,),
                  _buildTitleRow(),
                  const SizedBox(height: 16,),
                  _buildWarningBox(formWidth),
                  const SizedBox(height: 16,),
                  const Text.rich(TextSpan(
                      children: [
                        TextSpan(text: "Tool Identifier: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "WT-2857-3094\n\n"),
                        TextSpan(text: "Description: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "This is a web-based application that has been developed "
                            "to facilitate the encoding and decoding of messages related to SCP-7777, "
                            "an anomalous phenomenon that disrupts random number generators (RNGs) "
                            "utilized by the SCP Foundation. SCP-7777 is characterized by the sporadic "
                            "production of sequences consisting primarily of the numerals '7' and '0'. "
                            "These sequences have been hypothesized to carry encoded messages that are "
                            "significant to Foundation research and containment efforts.")
                      ]
                  ), style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 32,),
                  TextField(
                    controller: inputController,
                    maxLines: 5,
                    decoration: inputBoxDecoration.copyWith(
                      labelText: "Input",
                    ),
                    style: GoogleFonts.courierPrime(color: raisaPrimary),
                  ),
                  const SizedBox(height: 8,),
                  _buildButtonRow(),
                  const SizedBox(height: 8,),
                  TextField(
                      controller: outputController,
                      maxLines: 5,
                      decoration: inputBoxDecoration.copyWith(
                        labelText: "Output",
                      ),
                      textAlign: TextAlign.center,
                      readOnly: true,
                      style: GoogleFonts.courierPrime(color: raisaPrimary))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildNavBar(BuildContext context) {
    return Container(
            color: barColor,
            height: 24,
            alignment: Alignment.center,
            child: SizedBox(
              width: 512,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                TextButton(
                    onPressed: () {
                      launchUrlString("https://scp-wiki.wikidot.com/scp-7777");
                    },
                    child: Text("SCP Document", style: barTextStyle)),
                TextButton(onPressed: () {
                  launchUrlString("https://github.com/helightdev/scp-7777");
                }, child: Text("GitHub", style: barTextStyle)),
                TextButton(
                    onPressed: () {
                      launchUrlString("https://helight.dev");
                    },
                    child: Text("Author", style: barTextStyle)),
                TextButton(
                    onPressed: () {
                      showAboutDialog(context: context, applicationLegalese: "© 2023 Christoph 'Helight' Feuerer.\nThe fictional work this website is based on is SCP-7777 by Yossipossi.");
                    },
                    child: Text("About", style: barTextStyle))
              ]),
            ),
          );
  }

  Row _buildButtonRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 1, color: Colors.black)),
          const SizedBox(
            width: 16,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                outputController.text = encodeHeptobinary(inputController.text);
              });
            },
            style: buttonStyle,
            child: const Text("[ENCODE]"),
          ),
          const SizedBox(
            width: 16,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                outputController.text = decodeHeptobinary(inputController.text);
              });
            },
            style: buttonStyle,
            child: const Text("[DECODE]"),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(child: Container(height: 1, color: Colors.black)),
        ],
      );

  Row _buildTitleRow() {
    return Row(
      children: [
        const Text("SCP-7777 Cipher",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Expanded(child: Container(height: 1, color: Colors.black)),
      ],
    );
  }

  WarningBox _buildWarningBox(double formWidth) {
    return WarningBox(
      title: "ACCESS-SPECIFIC INFORMATION",
      span: const TextSpan(children: [
        TextSpan(text: "The following document contains "),
        TextSpan(text: "1", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " (one) addendum that is "),
        TextSpan(text: "RAISA/4", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " clearance classified. Any information enclosed within the classified "
            "addendum is forbidden to communicate with "),
        TextSpan(text: "any", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " external parties. By accessing this information, you agree to keep any "
            "knowledge gained confidential or risk demotion and/or termination of employment."),
      ]),
      width: formWidth,
    );
  }

  Widget _buildHeaderRow() {
    return GestureDetector(
      onTap: () {
        launchUrlString("https://scp-wiki.wikidot.com/scp-7777");
      },
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/raisa_logo.svg",
            height: 80,
          ),
          const SizedBox(width: 8),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text("RAISA ARCHIVE", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 0.75)),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Text("Records And Information Security Administration",
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WarningBox extends StatelessWidget {
  final String title;
  final InlineSpan span;
  final double width;

  const WarningBox({super.key, required this.title, required this.span, this.width = 512});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: raisaLight,
        border: Border.all(color: Colors.black54),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text.rich(
            span,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
