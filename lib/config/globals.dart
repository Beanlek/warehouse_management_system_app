class Globals {
  static const String debugURL = 'https://tnvsales.amastsales-sandbox.com';
  static const List<Server> serversList = [
    Server("https://tnvsales.amastsales-sandbox.com/", true),
    Server("https://pnvsales.amastsales.com/", false),
  ];
}

class Server {
  final String url;
  final bool isDev;
  const Server(this.url, this.isDev);
  List<Object?> get props => [url, isDev];
}
