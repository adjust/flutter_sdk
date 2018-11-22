// very primitive logger, visible only in our dart library (not visible outside, for clients)
// in the future, we might think of using something more sophisticated for logging 
class Logger {
  static bool isEnaled = true;
  static void d(String message) {
    print(message);
  }
}