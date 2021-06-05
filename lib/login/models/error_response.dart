class ErrorResponse {
  String? error;
  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json){
    return ErrorResponse(error: json['error']);
  }

  Map<String, dynamic> toJson(){
    return {
      'error' : this.error
    };
  }
}