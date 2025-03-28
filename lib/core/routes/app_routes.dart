enum AppRoutes {
  signIn('/signIn'),
  signUp('/signUp'),
  userList('/userList'),
  chatPage('/chatPage/:uid');

  const AppRoutes(this.route);

  final String route;
}
