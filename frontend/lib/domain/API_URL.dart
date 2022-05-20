class API_URL{

  static late String _url;

  static void setUrl(String url, int port) {
    _url = "http://" + url + ":" + port.toString();
  }
  static String getURL(){
    return _url;
  }
}