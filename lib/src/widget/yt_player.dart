import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:yt_player/yt_player.dart';

class YtPlayer extends StatefulWidget {
  /// A [YtPlayer] controller for [YtPlayer]
  final YtController controller;
///called when the player is ready to preform operation
    final VoidCallback? onReady;

  /// create a [YtPlayer] widget
  const YtPlayer({super.key, required this.controller , this.onReady});

  @override
  State<YtPlayer> createState() => _YtPlayerState();
}

class _YtPlayerState extends State<YtPlayer> {
  late YtController controller;
  @override
  void initState() {
    controller = widget.controller..addListener(listner);
    if(controller.value.isReady){

    }
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listner);
    super.dispose();
  }

  void listner() async {
    // controller.play();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InheritedYtPlayer(
      controller: controller,
      child: YtPlayer(controller: controller));
  }
}
