import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/databox/databox.dart';
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
    @Default([]) List<(String, DataBox)> databoxes,
  }) = _HomeState;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    logger.d('loading entried from database');
    try {
      // get all entried from the database
      final entries = await gloablDB.selectStorage();
      // remove the deleted ones
      entries.removeWhere((e) => e.deleted);
      // for each entry, decrypt the payload and get
      // the databox.
      final databoxes = <(String, DataBox)>[];
      for (var entry in entries) {
        try {
          databoxes.add((
            entry.id,
            await decryptDataBox(
              getGlobalKek()!,
              entry.encryptedDek,
              entry.encryptedPayload,
            ),
          ));
        } catch (e) {
          logger.e(e);
        }
      }
      emit(state.copyWith(databoxes: databoxes));
    } catch (e) {
      logger.e(e);
    } finally {
      emit(state.copyWith(status: .ready));
    }
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
            body: ListView.separated(
              itemCount: state.databoxes.length,
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
                          await gloablDB.deleteStorage(
                            state.databoxes[index].$1,
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
                          await router.push(
                            '/totp/${state.databoxes[index].$1}',
                          );
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
                                Text(state.databoxes[index].$2.totp.issuer),
                                Text(state.databoxes[index].$2.totp.account),
                                OTPCode(
                                  algorithm:
                                      state.databoxes[index].$2.totp.algorithm,
                                  secret: state.databoxes[index].$2.totp.secret,
                                  digits: state.databoxes[index].$2.totp.digits,
                                  period: state.databoxes[index].$2.totp.period,
                                ),
                              ],
                            ),
                          ),
                          Timer(period: state.databoxes[index].$2.totp.period),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Spacer16;
              },
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
