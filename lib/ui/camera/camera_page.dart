import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat/ui/camera/list_images_page.dart';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';


class CameraPage extends StatefulWidget {
  final cameras;
  final CameraController controller;
  final User usuario;

  const CameraPage(this.cameras, this.controller, this.usuario,{super.key,});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  TelaChatController telaChatController = TelaChatController();
  List<String> pathList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (() {}), icon: const Icon(Icons.check))
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
             CameraPreview(widget.controller),
              Positioned(
                bottom: 0,
                child: StreamBuilder<bool>(
                stream: telaChatController.controllerIsSendingFile.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          pathList.isNotEmpty ?
                            InkWell(
                             onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(paths: pathList, usuario: widget.usuario)));}, 
                              child: Container(
                                width: 70,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(File(pathList.last)
                                    )
                                  )
                                ),
                              ),
                            )
                            : const SizedBox(width: 70, height: 70),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(100)),
                            child: snapshot.data == null || snapshot.data == false ?
                              IconButton(
                                    icon: const Icon(Icons.camera, color: Colors.grey, size: 50,),
                                    onPressed: () async {
                                      XFile file = await widget.controller.takePicture();
                                      pathList.add(file.path);
                                      print(pathList.where((element) => element.isNotEmpty));
                                      telaChatController.controllerIsSendingFile.add(false);
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(image: file.path, usuario: widget.usuario,)));
                                    },
                              ) 
                            : const Center(child: CircularProgressIndicator(strokeWidth: 5,))
                            ),
                            const SizedBox(width: 70, height: 70),
                        ],
                      ),
                    ),
                  );
                  }
                ),
              ),
          ],
        ),
      ),
    );
  }
}