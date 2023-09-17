class UserDetails {
  Access? access;
  Subscription? subscription;
  bool? isCreator;
  bool? isSubscriber;
  String? avatar;
  List<void>? usedDiscountCodes;
  bool? isNumberOfAccountsWereExceeded;
  String? sId;
  String? email;
  String? name;
  String? timezone;
  int? phone;
  String? birthday;
  Metadata? metadata;
  String? address;

  UserDetails(
      {this.access,
      this.subscription,
      this.isCreator,
      this.isSubscriber,
      this.avatar,
      this.usedDiscountCodes,
      this.isNumberOfAccountsWereExceeded,
      this.sId,
      this.email,
      this.name,
      this.timezone,
      this.phone,
      this.birthday,
      this.metadata,
      this.address});

  UserDetails.fromJson(Map<String, dynamic> json) {
    access = json['access'] != null ? Access.fromJson(json['access']) : null;
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
        : null;
    isCreator = json['isCreator'];
    isSubscriber = json['isSubscriber'];
    avatar = json['avatar'];
    if (json['usedDiscountCodes'] != null) {
      usedDiscountCodes = <Null>[];
      json['usedDiscountCodes'].forEach((v) {
        // usedDiscountCodes!.add(new Null.fromJson(v));
      });
    }
    isNumberOfAccountsWereExceeded = json['isNumberOfAccountsWereExceeded'];
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    timezone = json['timezone'];
    phone = json['phone'];
    birthday = json['birthday'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (access != null) {
      data['access'] = access!.toJson();
    }
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    data['isCreator'] = isCreator;
    data['isSubscriber'] = isSubscriber;
    data['avatar'] = avatar;
    if (usedDiscountCodes != null) {
      // data['usedDiscountCodes'] =
      // this.usedDiscountCodes!.map((v) => v.toJson()).toList();
    }
    data['isNumberOfAccountsWereExceeded'] = isNumberOfAccountsWereExceeded;
    data['_id'] = sId;
    data['email'] = email;
    data['name'] = name;
    data['timezone'] = timezone;
    data['phone'] = phone;
    data['birthday'] = birthday;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['address'] = address;
    return data;
  }
}

class Access {
  List<void>? calendars;
  List<void>? libraryCategories;

  Access({this.calendars, this.libraryCategories});

  Access.fromJson(Map<String, dynamic> json) {
    if (json['calendars'] != null) {
      calendars = <Null>[];
      json['calendars'].forEach((v) {
        // calendars!.add(new Null.fromJson(v));
      });
    }
    if (json['libraryCategories'] != null) {
      libraryCategories = <Null>[];
      json['libraryCategories'].forEach((v) {
        // libraryCategories!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (calendars != null) {
      // data['calendars'] = this.calendars!.map((v) => v.toJson()).toList();
    }
    if (libraryCategories != null) {
      // data['libraryCategories'] =
      // this.libraryCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscription {
  int? paymentAmount;
  String? paymentProvider;
  PaymentProviderData? paymentProviderData;
  String? expirationDate;
  String? paymentPeriod;
  String? plan;

  Subscription(
      {this.paymentAmount,
      this.paymentProvider,
      this.paymentProviderData,
      this.expirationDate,
      this.paymentPeriod,
      this.plan});

  Subscription.fromJson(Map<String, dynamic> json) {
    paymentAmount = json['paymentAmount'];
    paymentProvider = json['paymentProvider'];
    paymentProviderData = json['paymentProviderData'] != null
        ? PaymentProviderData.fromJson(json['paymentProviderData'])
        : null;
    expirationDate = json['expirationDate'];
    paymentPeriod = json['paymentPeriod'];
    plan = json['plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentAmount'] = paymentAmount;
    data['paymentProvider'] = paymentProvider;
    if (paymentProviderData != null) {
      data['paymentProviderData'] = paymentProviderData!.toJson();
    }
    data['expirationDate'] = expirationDate;
    data['paymentPeriod'] = paymentPeriod;
    data['plan'] = plan;
    return data;
  }
}

class PaymentProviderData {
  String? subscriptionId;

  PaymentProviderData({this.subscriptionId});

  PaymentProviderData.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscriptionId'] = subscriptionId;
    return data;
  }
}

class Metadata {
  bool? shouldChangePlan;
  bool? planChanged;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Metadata(
      {this.shouldChangePlan,
      this.planChanged,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Metadata.fromJson(Map<String, dynamic> json) {
    shouldChangePlan = json['shouldChangePlan'];
    planChanged = json['planChanged'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shouldChangePlan'] = shouldChangePlan;
    data['planChanged'] = planChanged;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
