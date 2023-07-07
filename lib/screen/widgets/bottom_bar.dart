import 'package:flutter/material.dart';

class BottomBarBotton extends StatelessWidget {

   final String label;
 final Function() onTap;
   final   Color clr;
  final    bool isClosed = false;
   const BottomBarBotton({super.key, required this.label, required this.onTap, required this.clr});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 50),
        height: 45,
        width: MediaQuery
            .of(context)
            .size
            .width * 1,
        decoration: BoxDecoration(
          color: isClosed == true ? Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClosed == true ? Colors.black12 : clr,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClosed
                ? const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey,
            )
                : const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey,
            ).copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
