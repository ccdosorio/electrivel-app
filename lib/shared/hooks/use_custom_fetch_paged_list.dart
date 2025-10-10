// External dependencies
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';

void useFetchPagedItems<T extends Object>({
  required PagingController<int, T> controller,
  required Future<PageListSharedModel<T>> Function(int pageKey) fetch,
}) {
  final fetchPage = useCallback((int pageKey) async {
    final response = await fetch(pageKey);
    if (response.isLastPage) {
      controller.appendLastPage(response.items);
      return;
    }

    controller.appendPage(response.items, pageKey + 1);
  }, [controller, fetch]);

  useEffect(() {
    controller.addPageRequestListener(fetchPage);
    return () => controller.removePageRequestListener(fetchPage);
  }, [fetchPage]);
}
