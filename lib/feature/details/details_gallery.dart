part of 'details_page.dart';

class _DetailsGallery extends StatefulWidget {
  const new({
    required this.images,
    required this.initialIndex,
    required this.onDismiss,
  });

  final List<String> images;
  final int initialIndex;
  final VoidCallback onDismiss;

  @override
  State<_DetailsGallery> createState() => _DetailsGalleryState();
}

class _DetailsGalleryState extends State<_DetailsGallery> {
  late final PageController _controller;
  late int _page;

  @override
  void initState() {
    super.initState();
    final last = widget.images.length - 1;
    _page = widget.initialIndex.clamp(0, last);
    _controller = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xF2000000),
      child: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: _NetworkImage(
                    url: widget.images[index],
                    cacheWidth: _cacheWidth(context, 780),
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                tooltip: 'Закрыть',
                onPressed: widget.onDismiss,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x80000000),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      '${_page + 1} / ${widget.images.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
