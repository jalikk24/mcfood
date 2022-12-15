class ModelRegister {
  String namaUsername;
  int umur;
  String email;
  String password;
  int gender;
  int idProv;
  int idKotaKabs;
  int idKecamatan;
  int idKelurahan;
  double latitude;
  double longitude;
  String alamat;

  ModelRegister(
      this.namaUsername,
      this.umur,
      this.email,
      this.password,
      this.gender,
      this.idProv,
      this.idKotaKabs,
      this.idKecamatan,
      this.idKelurahan,
      this.latitude,
      this.longitude,
      this.alamat);

  static morph(ModelRegister modelRegister) {
    return {
      "namaUsername": modelRegister.namaUsername,
      "umur": modelRegister.umur,
      "email": modelRegister.email,
      "passwords": modelRegister.password,
      "gender": modelRegister.gender,
      "idProv": modelRegister.idProv,
      "idKotaKabs": modelRegister.idKotaKabs,
      "idKecamatan": modelRegister.idKecamatan,
      "idKelurahan": modelRegister.idKelurahan,
      "latitude": modelRegister.latitude,
      "longitude": modelRegister.longitude,
      "alamat": modelRegister.alamat,
    };
  }
}