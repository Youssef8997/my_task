
import 'package:flutter/material.dart';

class JokarPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var rightpalyer=TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Wallpaperstack(size ),
            Positioned(
                right: 5,
                top: 190,
                child: Point_Input(rightpalyer)),
            Positioned(
                left:5,
                top: 260,
                child: Point_Input(rightpalyer)),
            Positioned(
                right:220,
                top: 170,
                child: Point_Input(rightpalyer)),
            Positioned(
                right: 120,
                top: 330,
                child: Point_Input(rightpalyer)),
          ],
        ),
      ),
    );
  }

  Container Point_Input(TextEditingController rightpalyer) {
    return Container(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(width:1,color: Colors.grey)
            ),
            child: TextFormField(
              controller:rightpalyer,
              decoration: const InputDecoration(
               border: InputBorder.none
              ),
          keyboardType:const  TextInputType.numberWithOptions(),

            ),

          );
  }
}
SizedBox Wallpaperstack(Size size) {
  return SizedBox(
    height: size.height - 106,
    width: size.width,
    child: Image.network(
        "https://www.fay3.com/iHA5QYfnjdi/download",
        fit: BoxFit.contain),
  );
}