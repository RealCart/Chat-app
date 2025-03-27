enum AppRoutes {
  signIn('/signIn'),
  signUp('/signUp'),
  chats('/chats');

  const AppRoutes(this.route);

  final String route;
}
