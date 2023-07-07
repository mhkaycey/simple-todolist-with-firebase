// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BottomDrag extends StatelessWidget {
  final List<Widget> child;
  const BottomDrag({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.07,
          minChildSize: 0.07,
          maxChildSize: 0.6,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
