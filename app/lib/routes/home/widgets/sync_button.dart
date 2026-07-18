import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/helpers/sync.dart';

class SyncButton extends StatefulWidget {
  final Function() onDone;

  const SyncButton({super.key, required this.onDone});

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const SizedBox(
            width: 48,
            height: 48,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : IconButton(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              await syncLocalAndRemote();
              setState(() {
                _loading = false;
              });
              widget.onDone();
            },
            icon: const Icon(Icons.sync),
          );
  }
}
