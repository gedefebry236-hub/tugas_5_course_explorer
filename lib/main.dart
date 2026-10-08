import 'package:flutter/material.dart';

const String studentName = 'Febrian';
const String studentId = '2415051009'; // NIM kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DebuggingChallengePage(),
    );
  }
}

class DebuggingChallengePage extends StatefulWidget {
  const DebuggingChallengePage({super.key});

  @override
  State<DebuggingChallengePage> createState() => _DebuggingChallengePageState();
}

class _DebuggingChallengePageState extends State<DebuggingChallengePage> {
  // Flag untuk mencegah navigasi ganda (Kasus D)
  bool _isNavigating = false;

  void _navigateToDetail() async {
    if (_isNavigating) return; // Mencegah klik ganda jika sedang dalam proses navigasi

    setState(() => _isNavigating = true);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Detail Page')),
          body: Center(
            child: Text('$studentId - $studentName\nHalaman Detail', textAlign: TextAlign.center),
          ),
        ),
      ),
    );

    setState(() => _isNavigating = false); // Reset status setelah kembali
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16: Debugging Challenge')),
      // Kasus C: Menggunakan SingleChildScrollView agar tidak overflow saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$studentId - $studentName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 10),

            // --- KASUS A: Solusi RenderFlex Overflow pada Row ---
            const Text('Kasus A: Text Panjang dalam Row (Fixed dengan Expanded)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 8),
                // Pembungkus Expanded memaksa teks menyesuaikan sisa ruang Row
                Expanded(
                  child: Text(
                    '$studentId - $studentName - Teks sangat panjang yang tidak akan mengalami overflow karena sudah dibungkus Expanded.',
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- KASUS B: Solusi Unbounded Height pada ListView di dalam Column ---
            const Text('Kasus B: ListView dalam Column (Fixed dengan shrinkWrap & physics)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true, // Membatasi tinggi ListView sesuai jumlah item
              physics: const NeverScrollableScrollPhysics(), // Mematikan scroll internal ListView
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Item ListView ${index + 1}'),
                    subtitle: const Text('Berhasil dirender tanpa error unbounded height'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // --- KASUS D: Mencegah Navigasi Ganda ---
            const Text('Kasus D: Mencegah Navigasi Ganda (Double Push)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isNavigating ? null : _navigateToDetail, // Disabled jika _isNavigating true
              child: Text(_isNavigating ? 'Memproses...' : 'Buka Detail (Aman dari Double Click)'),
            ),
            const SizedBox(height: 40),

            // --- KASUS C: Form Dekat Bagian Bawah Layar ---
            const Text('Kasus C: Form di Bawah Layar (Uji Keyboard Overflow)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Klik di sini untuk menguji keyboard',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}