class ResponseCodeCustom {
  String mMessage;
  num sStatusCode;

  ResponseCodeCustom({
    this.sStatusCode,
    this.mMessage
  });

  factory ResponseCodeCustom.fromJson(Map<String, dynamic> map){
    return ResponseCodeCustom(
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