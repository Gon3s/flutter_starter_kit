/// Function to add delay in the execution of the code.
Future<void> delay({required bool addDelay, int milliseconds = 2000}) {
  if (addDelay) {
    return Future.delayed(Duration(milliseconds: milliseconds));
  } else {
    return Future.value();
  }
}
