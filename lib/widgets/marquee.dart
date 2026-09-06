import 'package:flutter/material.dart';

/// A horizontally-scrolling marquee that continuously slides [text] at a
/// constant speed, gracefully handling short (non-overflowing) text by simply
/// showing it still.
///
/// Used for the live METAR bar so long airport reports can be read without
/// wrapping onto multiple lines.
class Marquee extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color background;
  final double speed; // pixels per second
  final EdgeInsetsGeometry padding;

  const Marquee({
    super.key,
    required this.text,
    required this.style,
    this.background = Colors.transparent,
    this.speed = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ScrollController _scroll = ScrollController();
  double? _maxExtent;
  bool _overflowing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(_onTick);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onTick() {
    if (!mounted || !_overflowing) return;
    final max = _maxExtent ?? 0;
    if (max <= 0) return;
    // Wrap: position cycles from 0 -> max -> 0.
    final total = _controller.duration!.inMilliseconds / 1000.0 * widget.speed;
    final pos = (_controller.value * total) % (max * 2);
    final offset = pos <= max ? pos : 2 * max - pos;
    if (_scroll.hasClients) {
      _scroll.jumpTo(offset);
    }
  }

  void _measure(_) {
    if (!_scroll.hasClients) return;
    final extent = _scroll.position.maxScrollExtent;
    final overflowing = extent > 0;
    if (overflowing != _overflowing) {
      setState(() => _overflowing = overflowing);
    }
    _maxExtent = extent;

    if (overflowing && !_controller.isAnimating) {
      final durationMs = ((_maxExtent! * 2) / widget.speed * 1000).clamp(4000, 60000);
      _controller.duration = Duration(milliseconds: durationMs.round());
      _controller.repeat();
    } else if (!overflowing && _controller.isAnimating) {
      _controller.stop();
      _scroll.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.background,
      width: double.infinity,
      child: SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: widget.padding,
          child: Builder(
            builder: (context) {
              // Measure on first layout and whenever text changes.
              WidgetsBinding.instance.addPostFrameCallback(_measure);
              return Text(widget.text, style: widget.style, maxLines: 1);
            },
          ),
        ),
      ),
    );
  }
}
