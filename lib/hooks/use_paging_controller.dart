import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Creates [PagingController] that will be disposed automatically.
///
/// See also:
/// - [useScrollController]
/// - [PagingController]
PagingController<PageKeyType, ItemType> usePagingController<PageKeyType, ItemType>({
  required PageKeyType firstPageKey,
  required List<ItemType>? itemList,
  required PageKeyType? nextPageKey,
  required void Function(PageKeyType) addPageRequestListener,
  dynamic error,
  List<Object?>? keys,
}) {
  final pagingController = use(
    _PagingControllerHook<PageKeyType, ItemType>(
      firstPageKey: firstPageKey,
      addPageRequestListener: addPageRequestListener,
      keys: keys,
    ),
  );
  final state = PagingState<PageKeyType, ItemType>(
    itemList: itemList,
    nextPageKey: nextPageKey,
    error: error,
  );
  useValueChanged<PagingState<PageKeyType, ItemType>, void>(
    state,
    ((_, __) {
      pagingController.value = state;
    }),
  );
  return pagingController;
}

PagingController<void, ItemType> useStateLessPagingController<ItemType>({
  required List<ItemType>? itemList,
  required bool? isLast,
  required void Function() loadMore,
  dynamic error,
  List<Object?>? keys,
}) =>
    usePagingController<bool, ItemType>(
        firstPageKey: false,
        itemList: itemList,
        nextPageKey: isLast ?? false ? null : false,
        addPageRequestListener: (_) => loadMore(),
        error: error,
        keys: keys);

class _PagingControllerHook<PageKeyType, ItemType>
    extends Hook<PagingController<PageKeyType, ItemType>> {
  const _PagingControllerHook({
    required this.firstPageKey,
    required this.addPageRequestListener,
    List<Object?>? keys,
  }) : super(keys: keys);

  final PageKeyType firstPageKey;
  final void Function(PageKeyType) addPageRequestListener;

  @override
  HookState<PagingController<PageKeyType, ItemType>, Hook<PagingController<PageKeyType, ItemType>>>
      createState() => _PagingControllerHookState();
}

class _PagingControllerHookState<PageKeyType, ItemType> extends HookState<
    PagingController<PageKeyType, ItemType>, _PagingControllerHook<PageKeyType, ItemType>> {
  late final pagingController =
      PagingController<PageKeyType, ItemType>(firstPageKey: hook.firstPageKey);

  @override
  PagingController<PageKeyType, ItemType> build(BuildContext context) => pagingController;

  @override
  void initHook() {
    pagingController.addPageRequestListener(hook.addPageRequestListener);
  }

  @override
  void dispose() => pagingController.dispose();

  @override
  String get debugLabel => 'usePagingController';
}
