import 'package:flutter/material.dart';

class TextFieldCom extends StatelessWidget {
  const TextFieldCom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 295,
          height: 78,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Label',
                  style: TextStyle(
                    color: Color(0xFFA7ADBF),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    height: 0.10,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: ShapeDecoration(
                  color: Color(0xFF21242D),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0xFF2E333F)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      padding: const EdgeInsets.all(1),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Lorem Ipsum',
                      style: TextStyle(
                        color: Color(0xFF484C58),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        height: 0.10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}