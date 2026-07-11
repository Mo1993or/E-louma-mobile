enum UserRole {
  client('client'),
  seller('seller');

  final String storageValue;
  const UserRole(this.storageValue);

  static UserRole? fromStorage(String? v) {
    switch (v) {
      case 'seller':
        return UserRole.seller;
      case 'client':
        return UserRole.client;
      default:
        return null;
    }
  }
}
