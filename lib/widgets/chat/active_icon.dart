import 'package:flutter/material.dart';

class ActiveIcon extends StatefulWidget {
  const ActiveIcon({
    @required this.imageUrl,
    @required this.isActive,
  });
  final String imageUrl;
  final bool isActive;

  @override
  _ActiveIconState createState() => _ActiveIconState();
}

class _ActiveIconState extends State<ActiveIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          CircleAvatar(
            radius: 11,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
          if (widget.isActive)
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: Color(0xff00FF00),
                //backgroundImage: NetworkImage('imageUrl'),
              ),
            ),
        ],
      ),
    );
  }
}
