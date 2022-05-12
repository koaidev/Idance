/// status : 200
/// data : [{"id":"29","order_id":"ID1650502463041","request_id":"ID1650502463041","amount":"50000","order_info":"uvvuvuv - 05868683 - Gói học 1 tháng","message":"Giao dịch thành công.","user_id":"SjwXCRBYGOO78IfxNGy5MbESUM92","created_at":null,"updated_at":null}]

class PaymentObject {
  PaymentObject({
      int? status, 
      List<Data>? data,}){
    _status = status;
    _data = data;
}

  PaymentObject.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  int? _status;
  List<Data>? _data;
PaymentObject copyWith({  int? status,
  List<Data>? data,
}) => PaymentObject(  status: status ?? _status,
  data: data ?? _data,
);
  int? get status => _status;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "29"
/// order_id : "ID1650502463041"
/// request_id : "ID1650502463041"
/// amount : "50000"
/// order_info : "uvvuvuv - 05868683 - Gói học 1 tháng"
/// message : "Giao dịch thành công."
/// user_id : "SjwXCRBYGOO78IfxNGy5MbESUM92"
/// created_at : null
/// updated_at : null

class Data {
  Data({
      String? id, 
      String? orderId, 
      String? requestId, 
      String? amount, 
      String? orderInfo, 
      String? message, 
      String? userId, 
      dynamic createdAt, 
      dynamic updatedAt,}){
    _id = id;
    _orderId = orderId;
    _requestId = requestId;
    _amount = amount;
    _orderInfo = orderInfo;
    _message = message;
    _userId = userId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _requestId = json['request_id'];
    _amount = json['amount'];
    _orderInfo = json['order_info'];
    _message = json['message'];
    _userId = json['user_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _orderId;
  String? _requestId;
  String? _amount;
  String? _orderInfo;
  String? _message;
  String? _userId;
  dynamic _createdAt;
  dynamic _updatedAt;
Data copyWith({  String? id,
  String? orderId,
  String? requestId,
  String? amount,
  String? orderInfo,
  String? message,
  String? userId,
  dynamic createdAt,
  dynamic updatedAt,
}) => Data(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  requestId: requestId ?? _requestId,
  amount: amount ?? _amount,
  orderInfo: orderInfo ?? _orderInfo,
  message: message ?? _message,
  userId: userId ?? _userId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get orderId => _orderId;
  String? get requestId => _requestId;
  String? get amount => _amount;
  String? get orderInfo => _orderInfo;
  String? get message => _message;
  String? get userId => _userId;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['request_id'] = _requestId;
    map['amount'] = _amount;
    map['order_info'] = _orderInfo;
    map['message'] = _message;
    map['user_id'] = _userId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}