import 'package:get/get.dart';

class EducationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  // "Informasi dalam aplikasi ini bertujuan sebagai panduan edukasi dan tidak dimaksudkan untuk menggantikan nasihat, diagnosis, atau penanganan medis profesional. Selalu konsultasikan semua pertanyaan mengenai kondisi kesehatan Anda dengan dokter, bidan, atau tenaga kesehatan terkualifikasi lainnya. Jangan pernah menunda mencari pertolongan medis karena informasi yang Anda baca di aplikasi ini."

  final List<Map<String, String>> educations = [
    {
      'title': 'Pemulihan Fisik',
      'subtitle': 'Memahami Tubuhmu: Perjalanan Pemulihan Pasca Melahirkan',
      'content': '''
Halo Bunda, selamat atas kelahiran buah hati tercinta! Tubuh Bunda telah melakukan pekerjaan yang luar biasa. Kini, saatnya memberikan waktu bagi tubuh untuk pulih. Memahami prosesnya akan membuat Bunda lebih tenang.

1. Mengenal Masa Nifas (Lokia)
Setelah melahirkan, Bunda akan mengeluarkan darah nifas (lokia). Ini adalah cara tubuh membersihkan sisa lapisan rahim. Jangan khawatir, ini normal dan warnanya akan berubah seiring waktu:
    - Hari 1-4: Merah terang, seperti menstruasi berat.
    - Hari 4-10: Merah muda atau kecoklatan, aliran lebih ringan.
    - Setelah 10 hari hingga 6 minggu: Kekuningan atau putih, dan semakin sedikit.

2. Perawatan Luka untuk Kenyamanan Bunda
Baik melahirkan normal maupun caesar, area luka butuh perhatian ekstra.
    - Jika Melahirkan Normal (Jahitan Perineum):
        1. Jaga area tersebut tetap bersih dan kering. Bilas dengan air hangat setiap habis buang air, lalu keringkan dengan menepuk-nepuk lembut.
        2. Kompres dingin (es dibalut handuk) selama 10-15 menit dapat membantu mengurangi bengkak.
        3. Hindari duduk terlalu lama pada permukaan yang keras.
    - Jika Melahirkan Caesar:
        1. Ikuti petunjuk dokter untuk merawat luka. Biasanya, luka cukup dibersihkan dengan air dan sabun lembut lalu dikeringkan.
        2. Kenakan pakaian yang longgar agar tidak menekan area bekas operasi.
        3. Hindari mengangkat beban berat selama minimal 6 minggu.

3. Dengar Sinyal Tubuhmu: Tanda Bahaya yang Perlu Diwaspadai
Kesehatan Bunda adalah prioritas. Segera hubungi dokter atau UGD jika mengalami salah satu dari gejala ini:
    - Pendarahan sangat hebat (memenuhi lebih dari satu pembalut dalam satu jam).
    - Demam di atas 38°C.
    - Nyeri, bengkak, atau keluar cairan berbau tidak sedap dari area luka (perineum atau caesar).
    - Sakit kepala parah yang tidak kunjung hilang atau disertai pandangan kabur.
    - Nyeri atau bengkak pada salah satu kaki.
    - Perasaan sedih yang luar biasa, keinginan menyakiti diri sendiri atau bayi.
      ''',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Nutrisi Pasca Melahirkan',
      'subtitle': 'Energi untuk Bunda: Panduan Nutrisi & Hidrasi',
      'content': '''
Merawat bayi butuh banyak energi. Makanan dan minuman yang Bunda konsumsi adalah bahan bakar untuk pemulihan diri dan produksi ASI.

1. Hidrasi Adalah Kunci
Bunda mungkin akan lebih sering merasa haus, terutama saat menyusui. Ini normal!
    - Target: Usahakan minum sekitar 2-3 liter air per hari.
    - Tips: Selalu siapkan botol minum di dekat tempat Bunda biasa menyusui atau beristirahat.

2. Piring Gizi Seimbang Bunda
Tidak perlu diet ketat, fokus saja pada makanan utuh yang kaya gizi.
    - Zat Besi untuk Energi: Bantu cegah anemia dan kelelahan. Dapatkan dari daging merah, hati ayam, bayam, brokoli, dan kacang-kacangan.
    - Protein untuk Pemulihan: Bantu perbaiki jaringan tubuh. Sumber terbaik ada pada telur, ikan, ayam, tahu, dan tempe.
    - Kalsium untuk Tulang: Penting untuk Bunda dan bayi. Konsumsi susu, keju, yogurt, dan sayuran hijau.

3. Makanan Pendukung ASI (ASI Booster Alami)
Banyak makanan dipercaya dapat membantu kelancaran produksi ASI. Cobalah masukkan dalam menu harian:
    - Sayuran hijau seperti daun katuk dan bayam.
    - Oatmeal atau havermut.
    - Bawang putih (dalam masakan).
    - Kacang-kacangan seperti almon.

Ingat, prinsip utama produksi ASI adalah supply and demand (makin sering disusui, makin banyak produksi).
      ''',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Kesehatan Mental & Emosional',
      'subtitle': 'Merawat Hati: Kesehatan Mental Bunda',
      'content': '''
Merasa campur aduk setelah melahirkan? Senang, cemas, lelah, terharu, semua jadi satu? Bunda tidak sendirian. Ini sangat wajar.

1. Apa Bedanya Baby Blues dan Depresi Pasca Melahirkan?
Penting untuk mengenali apa yang Bunda rasakan.
    - Baby Blues
        1. Gejala: Mood swing, mudah menangis, cemas, sensitif, sulit tidur.
        2. Kapan: Muncul beberapa hari setelah melahirkan dan biasanya hilang sendiri dalam 2 minggu.
        3. Apa yang harus dilakukan: Istirahat cukup, terima bantuan orang lain, dan bicarakan perasaan Bunda.
    - Depresi Pasca Melahirkan (PPD)
        1. Gejala: Gejala baby blues yang lebih parah, berlangsung lebih lama, merasa putus asa, tidak tertarik pada bayi, merasa tidak berharga, hingga muncul pikiran menyakiti diri atau bayi.
        2. Kapan: Bisa muncul kapan saja dalam setahun pertama setelah melahirkan dan tidak hilang tanpa bantuan.
        3. Apa yang harus dilakukan: Ini adalah kondisi medis. Segera cari bantuan profesional. Bicaralah pada pasangan dan hubungi psikolog atau psikiater. Ini bukan aib dan Bunda bisa pulih.

2. Langkah Kecil untuk Merasa Lebih Baik
    - Bicara: Jangan pendam perasaanmu. Ceritakan pada pasangan, sahabat, atau ibu lain.
    - Sinar Matahari: Usahakan keluar rumah sebentar di pagi hari. Sinar matahari bisa membantu memperbaiki mood.
    - Turunkan Ekspektasi: Rumah tidak harus selalu rapi. cucian bisa menunggu. Fokus pada Bunda dan bayi.
      ''',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Dasar-Dasar Menyusui',
      'subtitle': 'Dekapan Pertama: Panduan Praktis Menyusui',
      'content': '''
Menyusui adalah proses belajar bagi Bunda dan si kecil. Kesabaran dan informasi yang tepat adalah kuncinya.

1. Kunci Sukses: Pelekatan (Latch-on) yang Tepat
Pelekatan yang baik membuat menyusui nyaman dan efektif.
    - Posisikan bayi menghadap Bunda, perut bertemu perut.
    - Arahkan puting ke hidung bayi untuk memancingnya membuka mulut lebar.
    - Saat mulutnya terbuka lebar seperti menguap, masukkan puting dan sebagian besar areola (area gelap di sekitar puting) ke dalam mulutnya.
    - Tanda pelekatan baik: Dagu bayi menempel di payudara, mulut terbuka lebar, bibir bawah terlipat keluar, dan Bunda tidak merasa kesakitan (hanya sensasi tarikan).

2. Apakah ASI-ku Cukup?
Ini adalah kekhawatiran terbesar banyak ibu baru. Lihat tanda-tanda ini pada bayi:
    - Popok Basah: Minimal 6 kali dalam 24 jam setelah bayi berusia 5 hari.
    - Buang Air Besar: Rutin, dengan warna tinja berubah menjadi kuning setelah beberapa hari.
    - Kenaikan Berat Badan: Bayi tampak aktif, waspada, dan berat badannya naik secara konsisten setelah minggu pertama.

3. Mengatasi Tantangan Umum
    - Puting Lecet: Biasanya disebabkan oleh pelekatan yang kurang pas. Coba perbaiki posisi dan pelekatan. Oleskan sedikit ASI pada puting dan biarkan mengering.
    - Payudara Bengkak: Susui bayi sesering mungkin. Jika perlu, kompres hangat sebelum menyusui dan kompres dingin setelahnya untuk mengurangi nyeri.      
      ''',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Merawat Diri Sendiri',
      'subtitle': 'Menemukan Ritme Baru: Gaya Hidup & Perawatan Diri',
      'content': '''
Merawat diri bukanlah tindakan egois, melainkan sebuah keharusan. Bunda yang bahagia adalah awal dari keluarga yang bahagia.

1. Istirahat Adalah Prioritas Utama
Lupakan mitos harus kuat begadang. Bunda butuh istirahat untuk pulih.
    - "Tidur saat bayi tidur." Manfaatkan setiap kesempatan untuk memejamkan mata, bahkan jika hanya 15-20 menit.
    - Biarkan pekerjaan rumah tangga menunggu. Kesehatan Bunda lebih penting daripada piring yang bersih.

2. Berani Meminta dan Menerima Bantuan
Bunda tidak harus menjadi superwoman.
    - Jika ada yang menawarkan bantuan (misalnya, memasak, mencuci, atau sekadar menggendong bayi agar Bunda bisa mandi), terimalah.
    - Buat daftar tugas sederhana yang bisa dibantu oleh pasangan atau keluarga.

3. Membangun Ikatan (Bonding) dengan si Kecil
Bonding adalah tentang kualitas, bukan kuantitas.
    - Kontak Kulit-ke-Kulit: Letakkan bayi di dada Bunda. Ini menenangkan bayi dan Bunda, serta membantu produksi ASI.
    - Bicara dan Bernyanyi: Bayi sangat suka mendengar suara Bunda.
    - Pijat Bayi: Sentuhan lembut adalah bahasa cinta yang dimengerti bayi.
      ''',
      'image': 'assets/images/pilihprogram.png',
    },
  ];

  final selectedEducation = Rxn<Map<String, String>>();

  void onEducationTap(int index) {
    selectedEducation.value = educations[index];
    Get.toNamed('/education-detail');
  }
}
