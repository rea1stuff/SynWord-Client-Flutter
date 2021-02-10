import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:synword/userData/currentUser.dart';

import 'package:synword/widgets/documentHandle/documentData.dart';
import 'package:synword/widgets/documentHandle/dialogState.dart';
import 'package:synword/userData/Controller/serverRequestsController.dart';


class ChoiceCase extends StatefulWidget {
  Function _setStateCallback;

  ChoiceCase(Function setStateCallback) {
    this._setStateCallback = setStateCallback;
  }

  @override
  State<StatefulWidget> createState() => _ChoiceCaseState(_setStateCallback);
}

class _ChoiceCaseState extends State<ChoiceCase> {
  bool uniqueUpSwitchValue = true;
  bool uniqueCheckSwitchValue = false;
  Function _setStateCallback;

  _ChoiceCaseState(Function setStateCallback) {
    this._setStateCallback = setStateCallback;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: HexColor('#262626'),
      content: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        height: MediaQuery.of(context).size.height / 1.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              color: HexColor('#366CCA'),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('icons/docx_logo.png'),
                      height: 90,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(docData.file.names.first,
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Roboto')),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
                color: HexColor('#5C5C5C'),
                child: ListTile(
                  dense: true,
                  title: Center(
                      child: Text(
                        'Повысить уникальность',
                        style: TextStyle(color: Colors.white),
                      )),
                  trailing: Switch(
                      activeColor: Colors.blue,
                      value: uniqueUpSwitchValue,
                      onChanged: (value) {
                        setState(() {
                          uniqueUpSwitchValue = value;
                        });
                      }),
                )),
            Card(
                color: HexColor('#5C5C5C'),
                child: ListTile(
                  dense: true,
                  title: Center(
                      child: Text(
                        'Проверить уникальность',
                        style: TextStyle(color: Colors.white),
                      )),
                  trailing: Switch(
                      activeColor: Colors.blueAccent,
                      value: uniqueCheckSwitchValue,
                      onChanged: (value) {
                        CurrentUser user = CurrentUser();

                        if(user.userData.isPremium == false){
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Show Snackbar'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                        else{
                          setState(() {
                            uniqueCheckSwitchValue = value;
                          });
                        }
                      }),
                )),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              disabledColor: Colors.grey,
              color: Colors.blueAccent,
              onPressed: uniqueCheckSwitchValue == true || uniqueUpSwitchValue == true ? () => onClickButtonHandler(uniqueUpSwitchValue, uniqueCheckSwitchValue, _setStateCallback) : null,
              child: const Text(
                'ЗАГРУЗИТЬ',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> onClickButtonHandler(bool uniqueUpSwitchValue, bool uniqueCheckSwitchValue, Function setStateCallback) async{
    docData.uniqueUp = uniqueUpSwitchValue;
    docData.uniqueCheck = uniqueCheckSwitchValue;
    setStateCallback(state: DialogState.loading);

    var downloadDirectory = await getExternalStorageDirectory();

    if(uniqueUpSwitchValue == true && uniqueCheckSwitchValue == true){

    }
    else if (uniqueUpSwitchValue == true){
      ServerRequestsController serverRequest = ServerRequestsController();
      Response docxUniqueUpResponse = await serverRequest.docxUniqueUpRequest(filePickerResult: docData.file);

      File file = File(
        join(DocumentData.downloadPath, "synword_" + docData.file.names.first),
      );

      file.writeAsBytesSync(docxUniqueUpResponse.data);
    }
    else if(uniqueCheckSwitchValue == true){

    }
    else{

    }

    setStateCallback(state: DialogState.finish);
}