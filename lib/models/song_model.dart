class SongModel {
  final String title;
  final String fileName;

  SongModel({required this.title, required this.fileName});
}

// Pastikan file-file ini ada di assets/audio/
List<SongModel> listLagu = [
  SongModel(title: "Hujan Tropis", fileName: "hujan.mp3"),
  SongModel(title: "Hutan Malam", fileName: "hutan.mp3"),
  SongModel(title: "Piano Lembut", fileName: "piano.mp3"),
  SongModel(title: "Kicau Burung", fileName: "burung.mp3"),
  SongModel(title: "Debur Ombak", fileName: "laut.mp3"),
];
