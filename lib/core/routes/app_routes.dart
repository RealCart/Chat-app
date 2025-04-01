enum AppRoutes {
  signIn('/signIn'),
  signUp('/signUp'),
  userList('/userList'),
  chatPage('/chatPage/:uid'),
  profile('/profile');

  const AppRoutes(this.route);

  final String route;
}
