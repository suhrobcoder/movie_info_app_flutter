import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/movie_video.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

class VideosColumn extends StatelessWidget {
  final List<MovieVideo>? videos;
  final Function(String) launchUrl;
  const VideosColumn(this.videos, this.launchUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videos == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(
              "Videos",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Column(
            children: videos
                    ?.map((video) => VideoItem(video.name, () {
                          launchUrl(video.getYoutubeUrl());
                        }))
                    .toList() ??
                const [SizedBox()],
          )
        ],
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final String name;
  final Function onClick;
  const VideoItem(this.name, this.onClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 4)]),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onClick(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            name,
            style: const TextStyle(fontSize: 20, color: textColor),
          ),
        ),
      ),
    );
  }
}
