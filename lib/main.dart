import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'dart:html' as html;

import 'dart:ui' as ui;

void main() {
  runApp(SizedBox(
    height: 1000,
    width: 1000,
    child: new HtmlEditorWidgetWeb(
      value: "",
      height: 1000,
      useBottomSheet: false,
      imageWidth: 100,
    ),
  ));
}

class HtmlEditorWidgetWeb extends StatelessWidget {
  HtmlEditorWidgetWeb({
    Key? key,
    required this.value,
    required this.height,
    required this.useBottomSheet,
    required this.imageWidth,
  }) : super(key: key);

  final String value;
  final double height;
  final bool useBottomSheet;
  final double imageWidth;

  final UniqueKey webViewKey = UniqueKey();

  final String createdViewId = 'html_editor_web';

  @override
  Widget build(BuildContext context) {
    String summernoteToolbar = "[\n";
    summernoteToolbar = summernoteToolbar + "],";
    String darkCSS = "";

    String htmlString = """
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <meta name="description" content="Flutter Summernote HTML Editor">
        <meta name="author" content="xrb21">
        <title>Summernote Text Editor HTML</title>
        <script src="main.dart.js" type="application/javascript"></script>
        <script src="app.js" defer></script>
        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
        
        <script>
        function test() {
              console.log("Listening");
          }
        </script>
      </head>
      <body>
      <input id='i1'> 
      <input id='i2'> 
      <button onClick="cal();">123</button>
      <script type="text/javascript">   
        window.parent.addEventListener('message', handleMessage, false);
        function handleMessage(e) {
          var data = JSON.parse(e.data);
          console.log(data);
        }   

        function cal(){
          var inputVal = document.getElementById("i1").value + document.getElementById("i2").value;
          window.parent.postMessage({haha: inputVal}, '*');
        }
      </script>
      <style>
        body {
            display: block;
            margin: 0px;
        }
        .note-editor.note-airframe, .note-editor.note-frame {
            border: 0px solid #a9a9a9;
        }
        .note-frame {
            border-radius: 0px;
        }
      </style>
      </body>
      </html>
    """;
    // html.window.onMessage.forEach((element) {
    //   print('Event Received in callback: ${element.data}');
    // });
    final data = <String, dynamic>{"hey": 123};
    final jsonEncoder = JsonEncoder();
    final json = jsonEncoder.convert(data);
    html.window.postMessage(json, "*");
    html.window.onMessage.listen((event) {
      var data = event.data;
      print(data);
    });
    // todo use postmessage and concatenation to accomplish callbacks
    final html.IFrameElement iframe = html.IFrameElement()
      ..width = '800' //'800'
      ..height = '400' //'400'
      ..srcdoc = htmlString
      ..style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => iframe);
    return Column(
      children: <Widget>[
        Expanded(
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: HtmlElementView(
                  key: UniqueKey(),
                  viewType: createdViewId,
                ))),
      ],
    );
  }
}
