import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String titleAppBar;
  final List<HomeMenuModel> menu;
  final List<HomeMenuModel> services;

  const HomeState({
    this.menu = const [],
    this.isLoading = false,
    this.services = const [],
    this.titleAppBar = '',
  });

  @override
  List<Object?> get props => [isLoading, titleAppBar, services, menu];

  HomeState copyWith({bool? isLoading, String? titleAppBar, List<HomeMenuModel>? services, List<HomeMenuModel>? menu}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      titleAppBar: titleAppBar ?? this.titleAppBar,
      services: services ?? this.services,
      menu: menu ?? this.menu,
    );
  }
}


class HomeNotifier extends StateNotifier<HomeState> {

  HomeNotifier() : super(HomeState());

  Future<String?> loadMenu() async {
    final (:response, :menuList) = await HomeDatasource().loadMenu();
    state = state.copyWith(isLoading: true);
    if (response.isError) {
      return response.error;
    }

    state = state.copyWith(menu: menuList, isLoading: false);
    return null;
  }

  void loadModuleMenu(List<HomeMenuModel> services, String titleAppBar) {
    state = state.copyWith(services: services, titleAppBar: titleAppBar);
  }

  void cleanState() {
    state = HomeState();
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
