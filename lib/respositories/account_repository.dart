abstract class IAccountRepository  {
  Future<void> deleteAccount();
  Future<void> changePassword(String oldPassword, String newPassword);
}