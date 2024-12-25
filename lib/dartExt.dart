/**
 * @author Raining
 * @date 2024-12-25 14:12
 *
 * 对dart工具类进行扩展
 */
extension IterableExt<T> on Iterable<T> {
  T? firstOrNullExt(bool Function(T) test) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
