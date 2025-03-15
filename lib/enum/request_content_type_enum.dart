enum RequestContentType {
  json("application/json"),
  textEventStreamValue("text/event-stream"),
  plainText("text/plain"),
  multiPartFormData("multipart/form-data");

  const RequestContentType(this.value);
  final String value;
}
