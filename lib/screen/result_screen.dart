import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:tts_script_converter/screen/home_screen.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';


class ResultScreen extends StatefulWidget {
  const ResultScreen(
      {super.key, required this.filesList, required this.languageList});

  final List<String> filesList;
  final List<String> languageList;

  @override
  State<ResultScreen> createState() => _ResultScreen();
}

class _ResultScreen extends State<ResultScreen> {
  late List<String> filesList = widget.filesList;
  late List<String> languageList = widget.languageList;
  bool isSaved = false;
  bool isEdited = false;
  bool isTextView = false;
  bool isGrammarCheck = false;
  String _selectedFile = '';
  List<String> beforeResult = [];
  List<String> afterResult = [];
  TextEditingController resultController = TextEditingController();

  void initState() {
    super.initState();
    setState(() {
      _selectedFile = filesList[0];
      afterResult = getExcelData(filesList);
    });
  }

  Widget build(BuildContext context) {
    resultController = TextEditingController(text: afterResult.first);
    int fileIndex;

    return Center(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 12,
            ),
            new SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  AlertDialog alert = AlertDialog(
                    content: Text("변환된 파일이 모두 사라집니다.\n 첫 화면으로 이동하시겠습니까?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen()));
                          },
                          child: Text("예",
                              style: TextStyle(
                                color: Colors.red.withOpacity(0.6),
                              ))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("아니오",
                              style: TextStyle(
                                color: Colors.red.withOpacity(0.6),
                              ))),
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.4)),
                child: Row(
                  children: [
                    Icon(Icons.chevron_left),
                    Text("Back"),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            new SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    fileIndex = filesList.indexOf(_selectedFile);
                    _onSetText(fileIndex);
                    isGrammarCheck = !isGrammarCheck;

                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.4)),
                child: Row(
                  children: [
                    Icon(Icons.verified),
                    SelectableText(
                      "\tGrammar Check",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            new SizedBox(
              width: 260,
              height: 50,
              child: SwitchListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.edit),
                      Text('Edit Activate'),
                    ],
                  ),
                  tileColor: Colors.redAccent.withOpacity(0.4),
                  activeColor: Colors.red,
                  value: isEdited,
                  onChanged: (bool value) {
                    if (isEdited == false && isGrammarCheck == true) {
                      setState(() {
                        isGrammarCheck = false;
                      });
                    }
                    fileIndex = filesList.indexOf(_selectedFile);
                    _onChangedTextController(fileIndex);
                    if (beforeResult[fileIndex] == resultController.text) {
                      setState(() {
                        isTextView = !isTextView;
                        isSaved = !isSaved;
                        _onSwitchChanged(value);
                      });
                    } else {
                      AlertDialog alert = AlertDialog(
                        content: Text("변경된 내용이 있습니다. 저장하시겠습니까?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                fileIndex = filesList.indexOf(_selectedFile);
                                afterResult[fileIndex] = resultController.text;
                                setState(() {
                                  isEdited = false;
                                  isTextView = false;
                                  isSaved = false;
                                });

                                Navigator.pop(context);
                              },
                              child: Text("저장",
                                  style: TextStyle(
                                    color: Colors.red.withOpacity(0.4),
                                  ))),
                          TextButton(
                              onPressed: () {
                                fileIndex = filesList.indexOf(_selectedFile);
                                setState(() {
                                  resultController.text =
                                      beforeResult[fileIndex];
                                });
                                Navigator.pop(context);
                                setState(() {
                                  isEdited = false;
                                  isTextView = false;
                                  isSaved = false;
                                });
                              },
                              child: Text("저장안함",
                                  style: TextStyle(
                                    color: Colors.red.withOpacity(0.4),
                                  ))),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("취소",
                                  style: TextStyle(
                                    color: Colors.red.withOpacity(0.4),
                                  ))),
                        ],
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          });
                    }
                  }
                  ),
            ),
            SizedBox(
              width: 30,
            ),
            new SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaved
                    ? () {
                        final snackBar = SnackBar(
                          duration: const Duration(milliseconds: 500),
                          backgroundColor: Colors.redAccent.withOpacity(0.5),
                          content: const Text('저장되었습니다.'),
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        fileIndex = filesList.indexOf(_selectedFile);
                        afterResult[fileIndex] = resultController.text;
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.4)),
                child: Row(
                  children: [
                    Icon(Icons.save_as),
                    SelectableText("Save"),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            new SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  AlertDialog alert = AlertDialog(
                    content: Text("변환된 Text 파일을 다운로드 하시겠습니까?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _writeData(afterResult);
                          },
                          child: Text("예",
                              style: TextStyle(
                                color: Colors.red.withOpacity(0.4),
                              ))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("아니오",
                              style: TextStyle(
                                color: Colors.red.withOpacity(0.4),
                              ))),
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.4)),
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SelectableText("Download"),
                  ],
                ),
              ),
            )
          ],
        ),
        Container(
            child: DropdownButton(
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          dropdownColor: Colors.grey,
          value: _selectedFile,
          items: filesList
              .map((e) => DropdownMenuItem(
                    child: Text(  "▷ ${e.substring(e.lastIndexOf('\\') + 1)}의 변환 결과"),
                    value: e,
                  ))
              .toList(),
          onChanged: (value) {

            setState(() {
              _selectedFile = value!;
              fileIndex = filesList.indexOf(_selectedFile);
             _onChangedTextController(fileIndex);
            });

          },
        )),
        SizedBox(
          width: 20,
        ),
        Visibility(
          child: Text(
            "(Edit Available)",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          visible: isTextView,
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.all(10),
                color: isEdited ? Colors.white : Colors.black12,
                child: SingleChildScrollView(
                    child: TextFormField(
                  key: Key('Result'),
                  readOnly: !isEdited,
                  controller: resultController,
                  maxLines: null,
                ))))
      ],
    ));
  }
  //홈스크린에서 가져온 엑셀 파일들을 가져오는 함수
  List<String> getExcelData(List<String> filesList) {
    String output = '';

    for (int i = 0; i < filesList.length; i++) {
      var bytes = File(filesList[i]).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      output =
          "[HEADER]\nPromptSculptor Script\nScriptVersion = v2.0.0\nScriptEncoding = UTF-8\nLanguage = ${languageList[i]}\n\n[TTS]\n";

      for (var table in excel.tables.keys) {
        // print("테이블 : ${table}");
        // print("열의 개수 : ${excel.tables[table]!.maxColumns}");
        // print("행의 개수 : ${excel.tables[table]!.maxRows}");

        // for (var row in excel.tables[table]!.rows) {
        //   print("${row.map((e) => e?.value)}");
        // }
        Sheet sheetObject = excel[table];

        for (int a = 4; a < excel.tables[table]!.maxRows; a++) {
          if (sheetObject
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: 4, rowIndex: a))
                      .value
                      .toString() ==
                  "New" ||
              sheetObject
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: 4, rowIndex: a))
                      .value
                      .toString() ==
                  "Changed") {
            output +=
                "${sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: a)).value}\;\n${sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: a)).value}\n\n";
          }
        }
      }
      beforeResult.add(output);
    }

    return beforeResult;
  }
  // 텍스트필드에 유저가 지정한 엑셀파일들의 인덱스로 해당 파일의 컨버팅된 결과를 반환
  TextEditingController _onChangedTextController(int index) {
    Future.delayed(const Duration(milliseconds: 30), () {
      resultController.text = afterResult[index];
      resultController.selection =
          TextSelection.collapsed(offset: resultController.text.length);
      //print(resultController.text.substring(1,150));
    });

    return resultController;
  }
  // 검증모드시 텍스트필드는 텍스트모드로 전환됨. 따라서 해당 인덱스에 따라 컨버팅된 결과를 반환
  String _onSetText(int index){
    Future.delayed(const Duration(milliseconds: 30), () {
      resultController.text = afterResult[index];
      resultController.selection =
          TextSelection.collapsed(offset: resultController.text.length);
      //print(resultController.text.substring(1,150));
    });

    return resultController.text;
  }
  //최종 결과 (afterResult) 리스트를 받아 지정된 경로에 다운로드 하는 함수
  Future<void> _writeData(List<String> afterResult) async {
    final dirPath = await _getDirPath();
    for (int i = 0; i < afterResult.length; i++) {
      final myFile =
          File('$dirPath/${languageList[i].toUpperCase()}_SCRIPT.txt');
      await myFile.writeAsString(afterResult[i]);
    }
  }
  // _selectFolder에 이어서 선택된 경로 지정 함수
  Future<String> _getDirPath() async {
    final dir = await _selectFolder();
    return dir;
  }
  // 폴더 선택 함수
  Future<String> _selectFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    return path.toString();
  }
  // 수정모드 on/off 함수
  void _onSwitchChanged(bool value) {
    isEdited = value;
  }

}
