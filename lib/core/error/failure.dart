sealed class PaymentFailure implements Exception {
  const PaymentFailure(this.message);

  final String message;
}

class UnknownFailure extends PaymentFailure {
  const UnknownFailure() : super('Something went wrong.');
}
