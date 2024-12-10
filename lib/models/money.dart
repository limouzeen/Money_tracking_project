class Money {
  String? message;
  String? moneyId;
  String? userId;
  String? moneyDetail;
  String? moneyInOut;
  String? moneyType;
  String? moneyDate;

  Money(
      {this.message,
      this.moneyId,
      this.userId,
      this.moneyDetail,
      this.moneyInOut,
      this.moneyType,
      this.moneyDate});

  Money.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    moneyId = json['moneyId'];
    userId = json['userId'];
    moneyDetail = json['moneyDetail'];
    moneyInOut = json['moneyInOut'];
    moneyType = json['moneyType'];
    moneyDate = json['moneyDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['moneyId'] = this.moneyId;
    data['userId'] = this.userId;
    data['moneyDetail'] = this.moneyDetail;
    data['moneyInOut'] = this.moneyInOut;
    data['moneyType'] = this.moneyType;
    data['moneyDate'] = this.moneyDate;
    return data;
  }
}