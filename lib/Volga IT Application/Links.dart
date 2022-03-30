class Link{

  late String createdLink;

Link.createLink(String i, String token) {
  createdLink = "https://finnhub.io/api/v1/quote?symbol=$i&token=$token";

  }

}