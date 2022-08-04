import 'dart:io';

import 'package:assessment_application/dialog.dart';
import 'package:assessment_application/image_upload_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:video_player/video_player.dart';

import 'package:path/path.dart' as p;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var bucket = '';
  var object = '';
  Minio minio=Minio(
      endPoint: '',
      accessKey: '',
      secretKey: '',
      region: ''
  );

  bool isLoading = false;
  var serverRespond = '';
  VideoPlayerController? controller;

  String extension = '';

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network('');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.only(left: 5),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height-80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(0)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(0),
                  child:(extension.toLowerCase().contains('.mp4') || extension.toLowerCase().contains('.mov'))?AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ) :CachedNetworkImage(
                  imageUrl: '${serverRespond}',
                  placeholder: (context, value) => Image.network('https://picsum.photos/id/1/200/300'),
                  errorWidget: (context, url, error) => Image.network('https://picsum.photos/id/1/200/300'),
                  fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if(Platform.isAndroid){
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
              allowMultiple: false,
            );
            if (result != null) {
              setState(() {
                isLoading = true;
              });
              for(int i=0; i< result.files.length; i++){
                object = p.basename(result.files[i].path??'');
                var response = await minio.fPutObject(bucket, object, '${result.files[i].path}');
                serverRespond = await minio.presignedGetObject(bucket, object);
                print(serverRespond);

                extension =  p.extension(serverRespond);

                if(p.extension(serverRespond).toLowerCase().contains('.mp4')  || p.extension(serverRespond).toLowerCase().contains('.mov')) {
                  controller = VideoPlayerController.network(serverRespond);
                  controller!.initialize().then((_) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                  controller!.setLooping(true);
                  controller!.play();
                }else{
                  setState(() {
                    isLoading = false;
                  });
                }
              }
            }
          }else{
            showFullWidthDialogBox(context, ImageUploadPopup((selection)async{
              Navigator.pop(context);
              XFile? image = null;
              final ImagePicker _picker = ImagePicker();
              if(selection == 'Picture'){
                 image = await _picker.pickImage(source: ImageSource.gallery);
              }else{
                image = await _picker.pickVideo(source: ImageSource.gallery);
              }
              if(image != null){
                setState(() {
                  isLoading = true;
                });
                object = p.basename(image.path);
                print(object);
                var response = await minio.fPutObject(bucket, object, '${image.path}');
                serverRespond = await minio.presignedGetObject(bucket, object);

               extension =  p.extension(serverRespond);
               print(extension);

                if(p.extension(serverRespond).toLowerCase().contains('.mp4')  || p.extension(serverRespond).toLowerCase().contains('.mov')) {
                  controller = VideoPlayerController.network(serverRespond);
                  controller!.initialize().then((_) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                  controller!.setLooping(true);
                  controller!.play();
                }else{
                  setState(() {
                    isLoading = false;
                  });
                }

                print(serverRespond);
              }
            }), false, DialogType.bottomSheet);
          }
        },
        tooltip: 'Upload',
        child: const Icon(Icons.upload),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
