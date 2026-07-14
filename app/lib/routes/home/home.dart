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
                child: MainContainer(
                  child: Column(
                    children: [
                      TotpEntryList(
                        items: _fav(state.totps),
                        title: 'favorites',
                      ),
                      SpacerSection,
                      TotpEntryList(
                        items: _nonFav(state.totps),
                        title: 'accounts',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: IconButton.filled(
              onPressed: () async {
                await router.push<bool?>('/totp');
                await cubit.load();
              },
              icon: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  List<(String, Totp)> _fav(List<(String, Totp)> totps) {
    return totps.takeWhile((item) => item.$2.favorite).toList();
  }

  List<(String, Totp)> _nonFav(List<(String, Totp)> totps) {
    return totps.takeWhile((item) => !item.$2.favorite).toList();
  }
}

class TotpEntryList extends StatelessWidget {
  final String title;
  final List<(String, Totp)> items;
  const TotpEntryList({super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) => TotpEntry(totp: item.$2)).toList();

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

class TotpEntry extends StatelessWidget {
  final Totp totp;

  const TotpEntry({super.key, required this.totp});

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
              child: Text(
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight(600)),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                totp.account,
                style: TextStyle(
                  fontSize: 13,
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
