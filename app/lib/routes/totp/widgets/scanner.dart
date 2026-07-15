import 'package:fixnum/fixnum.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/helpers/otpauth.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/secure/encryption.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/v7.dart';

class ScannerPage extends StatelessWidget {
  final bool saveOnResult;
  const ScannerPage({super.key, this.saveOnResult = true});

  @override
  Widget build(BuildContext context) {
    return _Scanner(saveOnResult: saveOnResult);
  }
}

class _Scanner extends StatefulWidget {
  final bool saveOnResult;

  const _Scanner({required this.saveOnResult});

  @override
  State<_Scanner> createState() => __ScannerState();
}

class __ScannerState extends State<_Scanner> {
  final _controller = MobileScannerController();
  var _isRunning = false;

  @override
  void initState() {
    _controller.start();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BuildContext context, BarcodeCapture barcodes) async {
    if (_isRunning) {
      return;
    }
    // no more events needed.
    await _controller.stop();
    _isRunning = true;
    final barcode = barcodes.barcodes.firstOrNull?.rawValue;
    final otpResult = OtpAuthResult.parse(barcode ?? '');
    if (otpResult == null) {
      router.pop<OtpAuthResult?>(null);
      return;
    }
    if (!widget.saveOnResult) {
      router.pop<OtpAuthResult?>(otpResult);
      return;
    }
    await _save(otpResult);
    router.pop<OtpAuthResult?>(otpResult);
  }

  Future<void> _save(OtpAuthResult otpResult) async {
    final kek = getGlobalKek();
    if (kek == null) {
      return;
    }
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final dbox = DataBox(
      totp: Totp(
        issuer: otpResult.issuer,
        account: otpResult.account,
        secret: otpResult.secret,
        algorithm: otpResult.algorithm,
        digits: otpResult.digits,
        period: otpResult.period,
        createdAtMs: Int64(nowMs),
        favorite: false,
        tags: [],
      ),
    );
    final (encryptedDek, encryptedPayload) = await encryptDataBox(kek, dbox);
    await gloablDB.upsertLocalStorage(
      LocalStorageData(
        id: UuidV7().generate(),
        updatedAtMs: nowMs,
        deleted: false,
        encryptedDek: encryptedDek,
        encryptedPayload: encryptedPayload,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final side = size.shortestSide * 0.7;
    final square = Rect.fromCenter(
      center: Offset(size.width / 2, (side / 2) + (36 + 16 + 28)),
      width: side,
      height: side,
    );
    return Scaffold(
      appBar: AppBar(title: Text('Add account')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            tapToFocus: true,
            scanWindow: square,
            onDetect: (barcodes) => _handleBarcode(context, barcodes),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ScannerOverlayPainter(square)),
            ),
          ),
          Positioned(
            left: (size.width / 2) - (size.width / 4 / 2),
            top: (36 + 16 + 28) + (size.width / 4) - 5,
            child: Icon(
              Icons.qr_code_scanner_outlined,
              color: Colors.white.withValues(alpha: 0.3),
              size: size.width / 4,
            ),
          ),
          SizedBox(
            width: size.width,
            height: 36 + 16 + 28,
            child: Center(
              child: Text(
                'Scan QR code',
                style: AppTheme.subTitleStyle,
                textAlign: .center,
              ),
            ),
          ),
          Positioned(
            top: 36 + 16 + 28 + side + 28,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  'Point your camera at the QR code \nshown by the service you\'re adding.',
                  style: AppTheme.helperStyle,
                  textAlign: .center,
                ),
                SpacerSection,
                Or(),
                SpacerSection,
                OutlinedButton(
                  onPressed: () {
                    router.replace('/totp-manual');
                  },
                  child: Row(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.keyboard,
                        color: AppTheme.BrightColor,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text('Enter setup key manually'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter(this.square);

  final Rect square;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(square, const Radius.circular(16));
    final overlay = Path()..addRect(Offset.zero & size);
    final hole = Path()..addRRect(rrect);
    final cut = Path.combine(PathOperation.difference, overlay, hole);
    canvas.drawPath(cut, Paint()..color = AppTheme.AppBackgroundColor);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppTheme.BrightColor,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter old) =>
      old.square != square;
}
