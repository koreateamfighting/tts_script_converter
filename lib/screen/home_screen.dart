import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:tts_script_converter/screen/result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Icon(Icons.edit_note),
              SizedBox(
                width: 15,
              ),
              Text('TTS Script File Converter')
            ],
          ),
          backgroundColor: Colors.redAccent.withOpacity(0.6),
        ),
        body: Center(
          child: DragTarget(),
        ));
  }
}

class DragTarget extends StatefulWidget {
  const DragTarget({Key? key}) : super(key: key);

  @override
  _DragTargetState createState() => _DragTargetState();
}

class _DragTargetState extends State<DragTarget> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final List<XFile> _list = [];
  final List<String> filesList = [];
  final List<String> languageList = [];
  String filepath = "";
  String language = "";
  bool _dragging = false;
  Offset? offset;
  var result;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
        onDragDone: (detail) async {
          //debugPrint('onDragDone:');
          for (final file in detail.files) {
            count++;
           // print("${count}번째 파일 ");
           // print("${file.name}");
            filesList.add(file.path);

            // debugPrint('  ${file.path} ${file.name}'
            //     '  ${await file.lastModified()}'
            //     '  ${await file.length()}'
            //     '  ${file.mimeType}');

            if (!file.path.contains(".xlsx")) {
              ScaffoldMessenger.of(context).showSnackBar(failMessageSnackBar());
            } else {
              setState(() {
                filepath = file.path;
                _list.addAll(detail.files);
              });
            }
          }
          for(int i = 0; i < filesList.length; i++) {
            print("들어간 파일들 : ${filesList[i]}");
          }

          languageRegister(filesList);

        },
        onDragUpdated: (details) {
          setState(() {
            //offset = details.localPosition;
          });
        },
        onDragEntered: (detail) {
          setState(() {
            _dragging = true;
            //offset = detail.localPosition;
          });
        },
        onDragExited: (detail) {
          setState(() {
            _dragging = false;
            //offset = null;
          });
        },
        child: _list.isEmpty
            ? Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.black26),
                  color: _dragging
                      ? Colors.blue.withOpacity(0.4)
                      : Colors.redAccent.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    if (_list.isEmpty)
                      const Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Center(
                            child: Icon(
                              Icons.save_alt,
                              size: 100,
                              color: Colors.black12,
                            ),
                          ),
                          Row(
                            children: [
                              Text("\t\t\t\t Drop Your",
                                  style: TextStyle(
                                      color: Colors.black26, fontSize: 20)),
                              Text("\t .xlsx File(s)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26,
                                      fontSize: 20)),
                              Icon(
                                Icons.insert_drive_file_rounded,
                                color: Colors.black26,
                              ),
                              Text(
                                " Here!",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          )
                        ],
                      )

                    // if (offset != null)
                    //   Align(
                    //     alignment: Alignment.topRight,
                    //     child: Text(
                    //       'result : ${offset}',
                    //       style: Theme.of(context).textTheme.bodySmall,
                    //     ),
                    //   )
                  ],
                ),
              )
            :
            // Text(_list.map((e) => e.path).join("\n")),
            Container(
                child: ResultScreen(
                  filesList: filesList,
                  languageList: languageList,
                ),
              ));
  }

  SnackBar failMessageSnackBar() {
    return SnackBar(
      duration: Duration(seconds: 2),
      content: Text("잘못된 형식의 파일입니다."),
      action: SnackBarAction(
        onPressed: () {},
        label: "Done",
        textColor: Colors.blue,
      ),
    );
  }

  Future<List<String>> languageRegister(filesList) async {
    for (int i = 0; i < filesList.length; i++) {
      print("자른 대상 : ${filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[3]}");
      if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Portuguese") {
        language = "ptp";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Czech") {
        language = "czc";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Slovakia") {
        language = "sks";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Swedish") {
        language = "sws";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Czech") {
        language = "czc";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Turkish") {
        language = "trt";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Croatian") {
        language = "hrh";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Dutch") {
        language = "dun";
      } else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Italian") {
        language = "iti";
      }
      else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "Norwegian") {
        language = "non";
      }
      else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "UK") {
        language = "eng";
      }
      else if (filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[2] == "European") {
         if(filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[3] == "French"){
           language = "fif";
         }
         else if(filesList[i].substring(filesList[i].lastIndexOf('\\')).split('_')[3] == "Spanish"){
           language = "spe";
         }
         else {
           language = "unknown";
         };
      }
      else {
        language = "unknown";
      }
      languageList.add(language);
    }
    return languageList;
  }
}
