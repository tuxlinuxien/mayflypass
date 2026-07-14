import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/helpers/sync.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/routes/home/widgets/timer.dart';
import 'package:mayflypass/routes/home/widgets/otp_code.dart';
import 'package:mayflypass/secure/secure.dart';

part 'home.freezed.dart';

enum HomeStatus { loading, ready }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.loading) HomeStatus status,
    @Default([]) List<(String, Totp)> totps,
  }) = _HomeState;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> sync() async {
    emit(state.copyWith(status: .loading));
    await syncLocalAndRemote();
    await load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    logger.d('loading entried from database');
    try {
      // get all entried from the database
      final entries = await gloablDB.selectLocalStorage(withDeleted: false);
      // for each entry, decrypt the payload and get
      // the Totp.
      final totps = await decryptEntries(entries);
      sortEntries(totps);
      emit(state.copyWith(totps: totps));
    } catch (e) {
      logger.e(e);
    } finally {
      emit(state.copyWith(status: .ready));
    }
  }

  void sortEntries(List<(String, Totp)> entries) {
    entries.sort((a, b) {
      var kA = '${a.$2.issuer}:${a.$2.account}';
      var kB = '${b.$2.issuer}:${b.$2.account}';
      return kA.compareTo(kB);
    });
  }

  Future<List<(String, Totp)>> decryptEntries(
    List<LocalStorageData> entries,
  ) async {
    final totps = <(String, Totp)>[];
    for (var entry in entries) {
      try {
        final databox = await decryptDataBox(
          getGlobalKek()!,
          entry.encryptedDek,
          entry.encryptedPayload,
        );
        totps.add((entry.id, databox.totp));
      } catch (e) {
        logger.e(e);
      }
    }
    return totps;
  }
}

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
              title: Text(AppLocalizations.of(context)!.appName),
              actions: [
                IconButton(
                  onPressed: () => router.push('/settings'),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => cubit.sync(),
              child: ListView.separated(
                itemCount: state.totps.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    direction: .horizontal,
                    enabled: true,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            // remove record
                            await gloablDB.deleteLocalStorage(
                              state.totps[index].$1,
                            );
                            // reload the entries
                            await cubit.load();
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (_) async {
                            await router.push('/totp/${state.totps[index].$1}');
                            // reload the entries
                            await cubit.load();
                          },
                          backgroundColor: Colors.grey.shade900,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0.0,
                      child: Padding(
                        padding: EdgeInsets.all(DEFAULT_SPACING),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: <Widget>[
                                  Text(state.totps[index].$2.issuer),
                                  Text(state.totps[index].$2.account),
                                  OTPCode(
                                    algorithm: state.totps[index].$2.algorithm,
                                    secret: state.totps[index].$2.secret,
                                    digits: state.totps[index].$2.digits,
                                    period: state.totps[index].$2.period,
                                  ),
                                ],
                              ),
                            ),
                            Timer(period: state.totps[index].$2.period),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SpacerHomeEntries;
                },
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
}
