extension KotlinLikeList<T> on Iterable<T> {
  T? getOrNull(int index) {
    if (index >= 0 && index < length) return elementAt(index);
    return null;
  }
}
