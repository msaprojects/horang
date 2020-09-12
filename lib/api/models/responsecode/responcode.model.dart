class ResponseCode {
  String sStatusCode, mMessage;

  ResponseCode({
    this.sStatusCode,
    this.mMessage
  });

  factory ResponseCode.fromJson(Map<String, dynamic> map){
    return ResponseCode(
        sStatusCode: map["statuscode"],
        mMessage: map["message"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "statuscode": sStatusCode,
      "message": mMessage
    };
  }

  @override
  String toString(){
    return 'MessageAndCode{statuscode: ${sStatusCode}, message: ${mMessage}';
  }
}