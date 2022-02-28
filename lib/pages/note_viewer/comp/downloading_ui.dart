import 'package:flutter/material.dart';
import 'package:note_app_teachers/constants/values.dart';

class DownloadingUi extends StatefulWidget {
  const DownloadingUi({Key? key}) : super(key: key);

  @override
  _DownloadingUiState createState() => _DownloadingUiState();
}

class _DownloadingUiState extends State<DownloadingUi> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: CircularProgressIndicator(
          color: mainColor,
        )),
        const SizedBox(
          height: 15,
        ),
        const Text("Downloading...")
      ],
    ));
  }
}
