import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'intro_controller.g.dart';

@riverpod
class IntroController extends _$IntroController {
  @override
  Stream<List<Intro>> build() {
    final repo = ref.watch(introRepositoryProvider);
    return repo.getIntro();
  }
}
