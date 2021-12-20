import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/movie_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPager extends StatefulWidget {
  final List<MovieVideo>? videos;

  const VideosPager({this.videos, Key? key}) : super(key: key);

  @override
  State<VideosPager> createState() => _VideosPagerState();
}

class _VideosPagerState extends State<VideosPager> {
  late PageController pageController;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.9);
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.videos == null
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(
                  "Videos",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: widget.videos?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: VideoPlayerItem(
                        widget.videos![index].key,
                        currentPage.floor() == index,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoId;
  final bool current;

  const VideoPlayerItem(this.videoId, this.current, {Key? key})
      : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          disableDragSeek: true,
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
    );
  }
}
