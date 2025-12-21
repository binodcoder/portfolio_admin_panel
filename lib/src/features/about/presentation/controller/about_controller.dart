import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/about/data/about_repository.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';

class AboutController extends StateNotifier<AsyncValue> {
  AboutController({required this.aboutRepository}) : super(AsyncValue.data(null));

  final AboutRepository aboutRepository;

  Future<bool> createAbout(About data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => aboutRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateAbout(String id, About data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => aboutRepository.update(id, data));
    return state.hasError == false;
  }

  Future<void> deleteAbout(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => aboutRepository.delete(id));
  }
}

final aboutControllerProvider = StateNotifierProvider<AboutController, AsyncValue>((ref) {
  final aboutRepository = ref.watch(aboutRepositoryProvider);
  return AboutController(aboutRepository: aboutRepository);
});

final aboutCanSaveProvider = StateProvider<bool>((ref) => false);
