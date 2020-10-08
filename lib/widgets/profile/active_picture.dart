import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hihellochat/screens/image_screen.dart';

class ActivePicture extends StatelessWidget {
  const ActivePicture(
      {Key key, this.imageCoverUrl, this.imageProfileUrl, this.isActive})
      : super(key: key);
  final bool isActive;
  final String imageCoverUrl;
  final String imageProfileUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .4 + 80,
        ),
        Hero(
          tag: imageCoverUrl.isEmpty ? 'Cover' : imageCoverUrl,
          child: GestureDetector(
              onTap: imageCoverUrl.isNotEmpty
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageScreen(
                            image:
                                imageCoverUrl.isEmpty ? "Cover" : imageCoverUrl,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  image: imageCoverUrl.isNotEmpty
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            imageCoverUrl,
                          ),
                        )
                      : null,
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  //image:
                ),
              )),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4 - 75,
          right: MediaQuery.of(context).size.width * 0.5 - 75,
          child: GestureDetector(
            onTap: imageProfileUrl.isNotEmpty
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          image: imageProfileUrl,
                        ),
                      ),
                    );
                  }
                : null,
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Colors.white,
              child: Hero(
                tag: imageProfileUrl.isEmpty ? 'Profile' : imageProfileUrl,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage: imageProfileUrl.isNotEmpty
                      ? CachedNetworkImageProvider(
                          imageProfileUrl,
                        )
                      : AssetImage('assets/person2.png'),
                ),
              ),
            ),
          ),
        ),
        if (isActive)
          Positioned(
            bottom: 25,
            right: MediaQuery.of(context).size.width * 0.5 - 65,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Color(0xff00FF00),
              ),
            ),
          ),
        Positioned(
          top: 10,
          left: 20,
          child: Container(
            height: 40,
            width: 40,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
