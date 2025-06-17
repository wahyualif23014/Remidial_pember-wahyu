class Activity {
  final String id;
  final String namaKegiatan;
  final String kategori;
  final String tanggal;
  final String deskripsi;
  final String? dokumentasi;

  Activity({
    required this.id,
    required this.namaKegiatan,
    required this.kategori,
    required this.tanggal,
    required this.deskripsi,
    this.dokumentasi,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaKegiatan': namaKegiatan,
      'kategori': kategori,
      'tanggal': tanggal,
      'deskripsi': deskripsi,
      'dokumentasi': dokumentasi,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      namaKegiatan: json['namaKegiatan'],
      kategori: json['kategori'],
      tanggal: json['tanggal'],
      deskripsi: json['deskripsi'],
      dokumentasi: json['dokumentasi'],
    );
  }
}