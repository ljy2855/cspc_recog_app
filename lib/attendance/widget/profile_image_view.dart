import 'package:flutter/material.dart';

import '../../urls.dart';

Widget profileImageView(final profileImageUrl, double size) {
  return Container(
    constraints: BoxConstraints(
      maxHeight: size,
      maxWidth: size,
    ),
    child: CircleAvatar(
      minRadius: size * 0.9,
      backgroundImage: profileImageUrl == null
          ? AssetImage('assets/images/profile_default.png')
          : NetworkImage(
              UrlPrefix.urls.substring(0, UrlPrefix.urls.length - 1) +
                  profileImageUrl),
    ),
  );
}
