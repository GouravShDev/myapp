abstract interface class AuthService {
  Future<AuthenticationStatus> checkAuthentication();
  Future<AuthenticationStatus> loginWithLeetcodeAccount(
    Map<String, dynamic> credentials,
  );
  Future<AuthenticationStatus> loginWithLeetcodeUserName(
    String leetcodeUsername,
  );
  Future<AuthenticationStatus> logout();
}

sealed class AuthenticationStatus {}

class LeetcodeAccountAuthenticated extends AuthenticationStatus {
  final Map<String, dynamic> credentials;
  final String userName;
  final bool shouldRenewCredentials;
  LeetcodeAccountAuthenticated({
    required this.credentials,
    required this.userName,
    required this.shouldRenewCredentials,
  });
}

class LeetcodeUsernameAuthenticated extends AuthenticationStatus {
  final String userName;

  LeetcodeUsernameAuthenticated({required this.userName});
}

class UnAuthenticatedStatus extends AuthenticationStatus {}
