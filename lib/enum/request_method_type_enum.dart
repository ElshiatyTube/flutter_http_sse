enum RequestMethodType {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  final String value;

  const RequestMethodType(this.value);
}
