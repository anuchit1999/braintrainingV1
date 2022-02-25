import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_game/widgets/show_progress.dart';

class ShowImage extends StatelessWidget {
  final String partUrl;
  const ShowImage({Key? key, required this.partUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: partUrl,
      placeholder: (context, url) => ShowProgress(),
    );
  }
}
