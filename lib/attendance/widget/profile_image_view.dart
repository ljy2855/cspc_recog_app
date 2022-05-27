import 'package:flutter/material.dart';

import '../../urls.dart';

Widget profileImageView(final profileImageUrl, double size) {
  return profileImageUrl == null
      ? Container(
          constraints: BoxConstraints(
            maxHeight: size,
            maxWidth: size,
          ),
          child: CircleAvatar(
            minRadius: size * 0.9,
            backgroundImage: AssetImage('assets/images/profile_default.png'),
          ),
        )
      : SizedBox(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size * 0.9,
              maxWidth: size * 0.9,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    UrlPrefix.urls.substring(0, UrlPrefix.urls.length - 1) +
                        profileImageUrl),
              ),
            ),
          ),
        );
}
