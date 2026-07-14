import 'package:flutter_svg/flutter_svg.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/core/widgets/logo.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/routes/home/cubit.dart';
import 'package:mayflypass/routes/home/widgets/timer.dart';
import 'package:mayflypass/routes/home/widgets/otp_code.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..load(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Logo(size: 40),
              actions: [
                IconButton(
                  onPressed: () => router.push('/settings'),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => cubit.sync(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 66),
                child: MainContainer(
                  child: Column(
                    children: [
                      TotpEntryList(
                        items: _fav(_filter(state.totps, state.query)),
                        title: 'favorites',
                      ),
                      SpacerSection,
                      TotpEntryList(
                        items: _nonFav(_filter(state.totps, state.query)),
                        title: 'accounts',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            bottomSheet: Padding(
              padding: EdgeInsetsGeometry.directional(
                bottom: 16,
                top: 0,
                start: 20,
                end: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (q) => cubit.search(q),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: () async {
                      await router.push<bool?>('/totp');
                      await cubit.load();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<(String, Totp)> _filter(List<(String, Totp)> totps, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return totps;
    return totps.where((item) {
      final t = item.$2;
      return t.issuer.toLowerCase().contains(q) ||
          t.account.toLowerCase().contains(q);
    }).toList();
  }

  List<(String, Totp)> _fav(List<(String, Totp)> totps) {
    return totps.where((item) => item.$2.favorite).toList();
  }

  List<(String, Totp)> _nonFav(List<(String, Totp)> totps) {
    return totps.where((item) => !item.$2.favorite).toList();
  }
}

class TotpEntryList extends StatelessWidget {
  final String title;
  final List<(String, Totp)> items;
  const TotpEntryList({super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final children =
        items.map((item) {
              return GestureDetector(
                onLongPress: () =>
                    _showEntryMenu(context, cubit, item.$1, item.$2),
                child: TotpEntryItem(id: item.$1, totp: item.$2),
              );
            }).toList()
            as List<Widget>;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            Text(
              '${items.length} ${title.toUpperCase()}',
              style: AppTheme.labelStyle,
            ),
            SizedBox(width: 5),
            Expanded(child: Divider(height: 1, thickness: 1)),
          ],
        ),
        ...children,
      ],
    );
  }
}

Future<void> _showEntryMenu(
  BuildContext context,
  HomeCubit cubit,
  String id,
  Totp totp,
) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.AppBackgroundColor,
    builder: (sheetCtx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(totp.favorite ? Icons.star : Icons.star_border),
            title: Text(
              totp.favorite ? 'Remove from favorites' : 'Add to favorites',
            ),
            onTap: () async {
              Navigator.pop(sheetCtx);
              await cubit.toggleFavorite(id, totp);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Update'),
            onTap: () async {
              Navigator.pop(sheetCtx);
              await router.push<bool?>('/totp/$id');
              await cubit.load();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete'),
            onTap: () async {
              Navigator.pop(sheetCtx);
              final confirmed = await _confirmDelete(context);
              if (confirmed) await cubit.delete(id);
            },
          ),
        ],
      ),
    ),
  );
}

Future<bool> _confirmDelete(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete account?'),
      content: const Text('This will remove this TOTP entry.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}

class TotpEntryItem extends StatelessWidget {
  final String id;
  final Totp totp;

  const TotpEntryItem({super.key, required this.id, required this.totp});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.InputBackgroundColor,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          _icon(),
          SizedBox(width: 20),
          Expanded(child: _otp()),
          SizedBox(width: 20),
          _timer(),
        ],
      ),
    );
  }

  Widget _icon() {
    final iconPath = BrandIcons.resolve(totp.issuer);

    String totpIssuer = totp.issuer.isEmpty ? '*' : totp.issuer;
    totpIssuer = totpIssuer[0].toUpperCase();

    return SizedBox(
      height: 44,
      width: 44,
      child: Stack(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Color(0xFF3a3a44),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            height: 44,
            width: 44,
            child: Center(
              child: iconPath != null
                  ? SvgPicture.asset(iconPath, height: 28, width: 28)
                  : Text(
                      totpIssuer,
                      style: TextStyle(
                        fontWeight: FontWeight(600),
                        fontSize: 20,
                        fontFamily: 'Roboto Mono',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otp() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          crossAxisAlignment: .end,
          children: [
            Text(
              totp.issuer,
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight(600)),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                totp.account,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight(400),
                  color: Color(0xff7c7788),
                  overflow: .ellipsis,
                ),
              ),
            ),
          ],
        ),
        OTPCode(
          secret: totp.secret,
          algorithm: totp.algorithm,
          digits: totp.digits,
          period: totp.period,
        ),
      ],
    );
  }

  Widget _timer() {
    return Timer(period: totp.period);
  }
}
