import 'package:flutter/material.dart';

import '../../constants/assets.dart';

class UserAvatar extends StatelessWidget {
  final String? profileUrl;

  const UserAvatar({
    Key? key,
    required this.profileUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: (profileUrl != null && profileUrl!.isNotEmpty
          ? NetworkImage('https://${profileUrl!}')
          : const AssetImage(DEFAULT_PROFILE) as ImageProvider),
      backgroundColor: Colors.transparent,
    );
  }
}
