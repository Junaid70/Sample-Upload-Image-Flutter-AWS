import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'decorations.dart';

class ImageUploadPopup extends StatefulWidget {
  final Function(String selection) callback;
  const ImageUploadPopup(this.callback,{Key? key}) : super(key: key);


  @override
  State<ImageUploadPopup> createState() => _ImageUploadPopupState();
}
class _ImageUploadPopupState extends State<ImageUploadPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.4,
      decoration: rectangularCustomColorBoxDecorationWithRadius(20, 0, 0, 20, Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: rectangularLighterGreyBoxDecorationWithRadius(2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              widget.callback('Picture');
                            },
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Text('Picture'),
                            ),
                          ),
                          SizedBox(height: 7,),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              widget.callback('Video');
                            },
                            child: Container(
                              child: Text('Video'),
                            ),
                          ),
                          SizedBox(height: 7,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

