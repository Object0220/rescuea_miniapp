import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 签名板组件 - 对应小程序 signature.wxml
class SignaturePad extends StatefulWidget {
  final void Function(Uint8List bytes)? onSave;

  const SignaturePad({super.key, this.onSave});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  List<Offset> _points = [];
  final _signatureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _points.add(details.localPosition);
              });
            },
            onPanEnd: (_) => _points.add(Offset.zero),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  painter: _SignaturePainter(_points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _points.clear()),
                  child: const Text('清除'),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final boundary = _signatureKey.currentContext?.findRenderObject()
                        as RenderRepaintBoundary?;
                    if (boundary == null) return;
                    final image = await boundary.toImage(pixelRatio: 3);
                    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                    if (byteData != null && widget.onSave != null) {
                      widget.onSave!(byteData.buffer.asUint8List());
                    }
                  },
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
