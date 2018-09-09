class Nullable<T> {
  T value;
  Nullable(this.value);
  String get strValue => value.toString();
}