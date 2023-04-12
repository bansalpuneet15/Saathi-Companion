class Relative {
  String name, email, phoneNumber, uid, elderUID;
  Relative();
  Relative getData(Map<String, dynamic> data) {
    this.phoneNumber = data['phoneNumber'];
    this.email = data['email'];
    this.uid = data['uid'];
    this.name = data['name'];
    this.elderUID = data['elderUID'];

    return this;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['elderUID'] = this.elderUID;
    return data;
  }
}
