import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardStatistikTidurController extends GetxController {
  RxInt qualityScore = 0.obs;
  RxDouble totalSleepHours = 0.0.obs;

  RxString sleepTimeString = "".obs;
  RxString wakeTimeString = "".obs;

  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;

  RxDouble todaySleepDuration = 0.0.obs; // Durasi hari ini

  // Daftar riwayat: setiap item => { "date": DateTime, "sleep": DateTime, "wake": DateTime, "duration": double }
  RxList<Map<String, dynamic>> sleepHistory = <Map<String, dynamic>>[].obs;

  // Target wake time untuk rekomendasi (nullable)
  Rx<TimeOfDay?> targetWakeTime = Rx<TimeOfDay?>(null);

  // Pilih jam tidur
  Future<void> pickSleepTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: sleepTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      sleepTime = picked;
      sleepTimeString.value = picked.format(context);
      _updateDurationWithoutSaving(context);
    }
  }

  // Pilih jam bangun
  Future<void> pickWakeTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: wakeTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      wakeTime = picked;
      wakeTimeString.value = picked.format(context);
      _updateDurationWithoutSaving(context);
    }
  }

  // Hitung durasi berdasarkan sleepTime & wakeTime, tapi *belum* menyimpan riwayat
  void _updateDurationWithoutSaving(BuildContext context) {
    if (sleepTime == null || wakeTime == null) return;

    DateTime now = DateTime.now();
    DateTime start = DateTime(
      now.year,
      now.month,
      now.day,
      sleepTime!.hour,
      sleepTime!.minute,
    );

    DateTime end = DateTime(
      now.year,
      now.month,
      now.day,
      wakeTime!.hour,
      wakeTime!.minute,
    );

    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    double duration = end.difference(start).inMinutes / 60.0;
    todaySleepDuration.value = double.parse(duration.toStringAsFixed(2));

    // Update qualityScore provisional (simple logic)
    qualityScore.value = (duration >= 8) ? 100 : (duration / 8 * 100).toInt();
  }

  // Simpan ke riwayat (gunakan sleepTime & wakeTime saat ini)
  void saveHistory() {
    if (sleepTime == null || wakeTime == null) return;

    DateTime now = DateTime.now();
    DateTime start = DateTime(
        now.year, now.month, now.day, sleepTime!.hour, sleepTime!.minute);
    DateTime end = DateTime(
        now.year, now.month, now.day, wakeTime!.hour, wakeTime!.minute);
    if (end.isBefore(start)) end = end.add(const Duration(days: 1));

    double duration = end.difference(start).inMinutes / 60.0;
    duration = double.parse(duration.toStringAsFixed(2));

    sleepHistory.add({
      "date": DateTime(now.year, now.month, now.day),
      "sleep": start,
      "wake": end,
      "duration": duration,
    });

    _recalculateTotals();
    // reset today's selections (optional)
    // sleepTime = null; wakeTime = null; sleepTimeString.value = ""; wakeTimeString.value = "";
  }

  // Hapus riwayat
  void removeHistory(int index) {
    if (index < 0 || index >= sleepHistory.length) return;
    sleepHistory.removeAt(index);
    _recalculateTotals();
  }

  // Recalculate totals (totalSleepHours as sum of durations) and qualityScore averaged
  void _recalculateTotals() {
    double sum = 0;
    for (var it in sleepHistory) {
      sum += (it["duration"] as double);
    }
    totalSleepHours.value = double.parse(sum.toStringAsFixed(2));

    // simple overall quality metric: average percent of 8 hours
    if (sleepHistory.isEmpty) {
      qualityScore.value = 0;
    } else {
      double avg = sum / sleepHistory.length;
      qualityScore.value = (avg >= 8) ? 100 : (avg / 8 * 100).toInt();
    }
  }

  // ----------------------------
  // Fitur: Rekomendasi jam tidur
  // ----------------------------
  // Siklus tidur 90 menit, plus 15 menit rata-rata untuk tertidur.
  // Kita rekomendasikan 3 opsi: 6, 5, 4 siklus (9, 7.5, 6 jam).
  List<String> getRecommendedBedtimes(
      BuildContext context, TimeOfDay targetWake) {
    // convert targetWake to DateTime (today or tomorrow depending)
    final now = DateTime.now();
    DateTime wakeDT = DateTime(
        now.year, now.month, now.day, targetWake.hour, targetWake.minute);

    // if wakeDT is before now (user may plan next day) we still use today's date but we always compute times by subtracting durations
    // Use cycles = 6,5,4
    final cycles = [6, 5, 4];
    List<String> results = [];

    for (var c in cycles) {
      int minutes = c * 90 + 15; // cycles * 90 + 15 minutes to fall asleep
      DateTime bed = wakeDT.subtract(Duration(minutes: minutes));
      results.add(_formatTimeOfDayFromDateTime(context, bed));
    }
    return results;
  }

  // Set target wake time (for UI)
  void setTargetWake(TimeOfDay t) {
    targetWakeTime.value = t;
  }

  // ----------------------------
  // Statistik Bulanan (30 hari terakhir)
  // ----------------------------
  // Filter sleepHistory to last 30 days and return summary
  Map<String, dynamic> getMonthlyStats() {
    DateTime now = DateTime.now();
    DateTime from = now.subtract(const Duration(days: 30));

    List<Map<String, dynamic>> items = sleepHistory.where((it) {
      DateTime d = it["date"] as DateTime;
      return !d.isBefore(DateTime(from.year, from.month, from.day));
    }).toList();

    if (items.isEmpty) {
      return {
        "averageDuration": 0.0,
        "earliestSleep": null,
        "latestSleep": null,
        "items": <Map<String, dynamic>>[],
      };
    }

    double sum = 0;
    DateTime? earliest;
    DateTime? latest;

    for (var it in items) {
      double dur = it["duration"];
      sum += dur;
      DateTime sleepDT = it["sleep"] as DateTime;
      if (earliest == null || sleepDT.isBefore(earliest)) earliest = sleepDT;
      if (latest == null || sleepDT.isAfter(latest)) latest = sleepDT;
    }

    double avg = double.parse((sum / items.length).toStringAsFixed(2));

    return {
      "averageDuration": avg,
      "earliestSleep": earliest,
      "latestSleep": latest,
      "items": items,
    };
  }

  // ----------------------------
  // Helper formatting
  // ----------------------------
  String _formatTimeOfDayFromDateTime(BuildContext context, DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  String formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  String formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  // Saran singkat lama (tetap sediakan, tapi UI utama memakai rekomendasi spesifik)
  String getSleepAdvice(double duration) {
    if (duration <= 0) return "Belum ada data tidur hari ini.";
    if (duration < 6) {
      return "Anda kurang tidur, usahakan tidur lebih awal.";
    } else if (duration <= 8) {
      return "Tidur Anda sudah cukup, pertahankan ya!";
    } else {
      return "Anda tidur terlalu lama, coba lebih teratur.";
    }
  }
}
