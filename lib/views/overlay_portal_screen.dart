import 'package:flutter/material.dart';

class OverlayPortalScreen extends StatelessWidget {
  const OverlayPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OverlayPortal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => const OverlayPortalModalScreen());
          },
          child: const Text('Open Overlay Portal'),
        ),
      ),
    );
  }
}

class OverlayPortalModalScreen extends StatefulWidget {
  const OverlayPortalModalScreen({super.key});

  @override
  State createState() => _OverlayPortalModalScreenState();
}

class _OverlayPortalModalScreenState extends State<OverlayPortalModalScreen> {
  final _plusButtonOverlayController = OverlayPortalController();
  final _minusButtonOverlayController = OverlayPortalController();
  final _closeButtonOverlayController = OverlayPortalController();

  final GlobalKey _parentWidgetKey = GlobalKey();
  final GlobalKey _plusButtonKey = GlobalKey();
  final GlobalKey _minusButtonKey = GlobalKey();
  final GlobalKey _closeButtonKey = GlobalKey();

  double top = 0;
  double buttonWidth = 0;
  double overlayLeft = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: SizedBox.shrink()),
        Container(
          key: _parentWidgetKey,
          margin:
              const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OverlayPortal(
                controller: _plusButtonOverlayController,
                overlayChildBuilder: (context) => _OverlayView(
                  controller: _plusButtonOverlayController,
                  top: top,
                  buttonWidth: buttonWidth,
                  buttonLeft: overlayLeft,
                  label: 'プラスボタンが押されました',
                ),
                child: IconButton(
                    key: _plusButtonKey,
                    onPressed: () {
                      RenderBox? renderBox = _parentWidgetKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      final topPosition =
                          renderBox?.localToGlobal(Offset.zero).dy;

                      RenderBox? buttonBox = _plusButtonKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      setState(() {
                        top = topPosition ?? 0;
                        buttonWidth = buttonBox?.size.width ?? 0;
                        overlayLeft =
                            buttonBox?.localToGlobal(Offset.zero).dx ?? 0;
                      });
                      _plusButtonOverlayController.toggle();
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.purple,
                    )),
              ),
              OverlayPortal(
                controller: _minusButtonOverlayController,
                overlayChildBuilder: (context) => _OverlayView(
                  controller: _minusButtonOverlayController,
                  top: top,
                  buttonWidth: buttonWidth,
                  buttonLeft: overlayLeft,
                  label: 'マイナスボタンが押されました',
                ),
                child: IconButton(
                    key: _minusButtonKey,
                    onPressed: () {
                      RenderBox? renderBox = _parentWidgetKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      final topPosition =
                          renderBox?.localToGlobal(Offset.zero).dy;

                      RenderBox? buttonBox = _minusButtonKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      setState(() {
                        top = topPosition ?? 0;
                        buttonWidth = buttonBox?.size.width ?? 0;
                        overlayLeft =
                            buttonBox?.localToGlobal(Offset.zero).dx ?? 0;
                      });
                      _minusButtonOverlayController.toggle();
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    )),
              ),
              OverlayPortal(
                  controller: _closeButtonOverlayController,
                  overlayChildBuilder: (context) {
                    return _OverlayView(
                      controller: _closeButtonOverlayController,
                      top: top,
                      buttonWidth: buttonWidth,
                      buttonLeft: overlayLeft,
                      label: '閉じるボタンが押されました',
                    );
                  },
                  child: IconButton(
                      key: _closeButtonKey,
                      onPressed: () {
                        RenderBox? renderBox = _parentWidgetKey.currentContext
                            ?.findRenderObject() as RenderBox?;
                        final topPosition =
                            renderBox?.localToGlobal(Offset.zero).dy;

                        RenderBox? buttonBox = _closeButtonKey.currentContext
                            ?.findRenderObject() as RenderBox?;
                        setState(() {
                          top = topPosition ?? 0;
                          buttonWidth = buttonBox?.size.width ?? 0;
                          overlayLeft =
                              buttonBox?.localToGlobal(Offset.zero).dx ?? 0;
                        });
                        _closeButtonOverlayController.toggle();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.blueAccent,
                      ))),
            ],
          ),
        )
      ],
    );
  }
}

class _OverlayView extends StatefulWidget {
  const _OverlayView(
      {required this.top,
      required this.buttonWidth,
      required this.buttonLeft,
      required this.controller,
      required this.label});

  final double top;
  final double buttonWidth;
  final double buttonLeft;
  final OverlayPortalController controller;
  final String label;

  @override
  State createState() => _OverlayViewState();
}

class _OverlayViewState extends State<_OverlayView> {
  final GlobalKey _overlayWidgetKey = GlobalKey();

  double overlayHeight = 0;
  double overlayWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox? renderBox =
          _overlayWidgetKey.currentContext?.findRenderObject() as RenderBox?;
      setState(() {
        overlayHeight = renderBox?.size.height ?? 0;
        overlayWidth = renderBox?.size.width ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.controller.toggle();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              top: widget.top - overlayHeight - 8,
              left: (widget.buttonLeft -
                          overlayWidth / 2 +
                          widget.buttonWidth / 2) <=
                      0
                  ? 16
                  : (widget.buttonLeft -
                              overlayWidth / 2 +
                              widget.buttonWidth / 2) >=
                          MediaQuery.of(context).size.width
                      ? null
                      : (widget.buttonLeft -
                          overlayWidth / 2 +
                          widget.buttonWidth / 2),
              right: (widget.buttonLeft -
                          overlayWidth / 2 +
                          widget.buttonWidth / 2) <=
                      0
                  ? null
                  : (widget.buttonLeft -
                              overlayWidth / 2 +
                              widget.buttonWidth / 2) >=
                          MediaQuery.of(context).size.width
                      ? MediaQuery.of(context).size.width - 16
                      : null,
              child: Container(
                key: _overlayWidgetKey,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(widget.label),
              ),
            )
          ],
        ),
      ),
    );
  }
}
