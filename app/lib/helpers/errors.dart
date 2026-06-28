sealed class ValueError {
  const ValueError();
}

class EmailInvalidError extends ValueError {
  const EmailInvalidError();
}

class CredentialsInvalidError extends ValueError {
  const CredentialsInvalidError();
}

class ChallengeInvalidError extends ValueError {
  const ChallengeInvalidError();
}

class ValueTooShortError extends ValueError {
  final int min;
  const ValueTooShortError(this.min);
}

class ValueTooLongError extends ValueError {
  final int max;
  const ValueTooLongError(this.max);
}

class ValueRangeError extends ValueError {
  final int min;
  final int max;
  const ValueRangeError(this.min, this.max);
}

class ValueMismatchError extends ValueError {
  const ValueMismatchError();
}

class ValueDuplicatedError extends ValueError {
  const ValueDuplicatedError();
}

class ValueLengthError extends ValueError {
  final int len;
  const ValueLengthError(this.len);
}

class ValueRequiredError extends ValueError {
  const ValueRequiredError();
}
