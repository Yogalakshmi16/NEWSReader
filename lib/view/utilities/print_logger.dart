import 'package:logger/logger.dart';

var loggerNoStack = Logger(
  printer: PrettyPrinter(
    lineLength: 150,
    printEmojis: false,
    methodCount: 0, // Set to 0 to hide method stack trace
  ),
);

void printToLog(String message) {
  loggerNoStack.t("LOG :: $message"); // Use the trace level (t) for logging
}
