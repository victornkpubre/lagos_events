import 'package:flutter/material.dart';
import 'package:lagos_events/presentation/views/upload/upload_view.dart';

Widget buildFAB(Size size, BuildContext context){
  return SizedBox(
    height: 40,
    width: 40,
    child: FloatingActionButton(
      shape: const RoundedRectangleBorder(),
      backgroundColor: const Color.fromRGBO(207, 195, 226, 0.3),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute<Widget>(
          builder: (BuildContext context) => UploadPage(size)
        ));
      },
      child: const Icon(Icons.file_upload, size: 20, color: Color.fromRGBO(89, 234, 193, 1.0))
    ),
  );
}