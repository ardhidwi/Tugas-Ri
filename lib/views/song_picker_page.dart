import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/song_model.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';

class SongPickerPage extends StatefulWidget {
  const SongPickerPage({super.key});

  @override
  State<SongPickerPage> createState() => _SongPickerPageState();
}

class _SongPickerPageState extends State<SongPickerPage> {
  String? _selectedFile; // Lagu yang dipilih untuk alarm
  String? _previewingFile; // Lagu yang sedang didengarkan sekarang

  @override
  void initState() {
    super.initState();
    _loadSavedSong();
  }

  // Mengambil lagu yang tersimpan saat halaman dibuka agar Radio tersisi otomatis
  void _loadSavedSong() async {
    String saved = await StorageService.ambilLagu();
    setState(() {
      _selectedFile = saved;
    });
  }

  // Fungsi untuk memutar/menghentikan cuplikan suara
  void _handlePreview(String fileName) async {
    if (_previewingFile == fileName) {
      await AudioService.stopLagu();
      setState(() => _previewingFile = null);
    } else {
      await AudioService.putarLagu(fileName);
      setState(() => _previewingFile = fileName);
    }
  }

  @override
  void dispose() {
    // Memastikan suara berhenti saat pengguna keluar dari halaman ini
    AudioService.stopLagu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Nada Alarm"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Pilih salah satu suara di bawah ini untuk menjadi nada alarm Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listLagu.length,
              itemBuilder: (context, index) {
                final song = listLagu[index];
                bool isSelected = _selectedFile == song.fileName;
                bool isPlaying = _previewingFile == song.fileName;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: GestureDetector(
                      onTap: () => _handlePreview(song.fileName),
                      child: CircleAvatar(
                        backgroundColor: isPlaying
                            ? Colors.orange
                            : Colors.blue.withOpacity(0.1),
                        child: Icon(
                          isPlaying ? Icons.stop : Icons.play_arrow,
                          color: isPlaying ? Colors.white : Colors.blue,
                        ),
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Radio<String>(
                      value: song.fileName,
                      groupValue: _selectedFile,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFile = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Tombol Simpan
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (_selectedFile != null) {
                  // Simpan ke StorageService
                  await StorageService.simpanLagu(_selectedFile!);
                  // Hentikan preview suara jika ada
                  await AudioService.stopLagu();

                  // Kembali ke halaman sebelumnya dan beri notifikasi sukses
                  Get.back();
                  Get.snackbar(
                    "Tersimpan",
                    "Nada alarm '${_selectedFile}' berhasil dipilih",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(15),
                  );
                }
              },
              child: const Text(
                "SIMPAN PILIHAN",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
