import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Scanner();
  }
}

class _Scanner extends StatefulWidget {
  const _Scanner();

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
    final barcode = barcodes.barcodes.firstOrNull;
    router.pop<String?>(barcode?.rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            tapToFocus: true,
            onDetect: (barcodes) => _handleBarcode(context, barcodes),
          ),
        ],
      ),
    );
  }
}
