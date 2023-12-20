[![Build status](https://build.appcenter.ms/v0.1/apps/659c6b85-39b2-42e4-80d8-3e641654113a/branches/main/badge)](https://appcenter.ms)

C08 Public page: [link](https://install.appcenter.ms/users/fikrirmdhna/apps/read-and-brew-mob/distribution_groups/c08)
# Read & Brew 📚☕️

## 👥 Nama Anggota Kelompok C-08 👥
* [Muhammad Mariozulfandy](https://github.com/riozulfandy) - 2206041404
* [Patrick Samuel Evans Simanjuntak](https://github.com/patrickSevans123) - 2206028251
* [Fikri Dhiya Ramadhana](https://github.com/fikrirmdhna) - 2206819533
* [Alexander Audric Johansyah](https://github.com/audricjohansyah) - 2206815466
* [Bulan Athaillah Permata Wijaya](https://github.com/bulanath) - 2206032135

## ⏪ Latar Belakang & Deskripsi Aplikasi ⏪
Berdasarkan studi tahun 2020, UNESCO menyatakan bahwa minat baca masyarakat Indonesia berada di angka yang sangat memprihatinkan, yakni hanya sebesar 0,001%. Dari data tersebut berarti bahwa di antara 1.000 masyarakat Indonesia, hanya ada satu orang yang rajin membaca. Selanjutnya, hasil data Asesmen Nasional (AN) tahun 2021 juga menunjukkan bahwa Indonesia mengalami darurat literasi karena 1 dari 2 peserta didik masih belum mencapai kompetensi minimum literasi.

Sebagai salah satu cara untuk mengatasi masalah di atas, kami memutuskan untuk membuat aplikasi **Read & Brew**. **Read & Brew** merupakan sebuah aplikasi yang memadukan kegemaran akan buku dengan kenyamanan sebuah kafe. Kami memiilih kafe sebagai sarana untuk meningkatkan tingkat literasi karena adanya peningkatan yang signifikan terkait dengan tingkat pengunjung kafe di kalangan anak muda. Kami memiliki harapan bahwa kafe tidak hanya bisa menjadi tempat untuk bersantai, tetapi juga menjadi sarana untuk meningkatkan literasi dari kalangan muda yang mayoritasnya masih memiliki tingkat literasi yang rendah.

## 💡 Daftar Modul Aplikasi 💡
### 1. Book List (Muhammad Mariozulfandy)
Berisi daftar buku-buku yang diambil dari dataset. Setiap data buku pada dataset yang digunakan akan ditampilkan beserta rating yang diperoleh pada modul Forum Review. Daftar buku-buku juga akan dapat dibagi berdasarkan kategori dan terdapat fitur search bar untuk mencari buku tertentu.
#### Peran Role Pengguna
| Member (Login)  | Employee  | Guest |
| ------------- | ------------- | ------------- |
| Dapat melihat daftar buku-buku beserta ratingnya.  | Dapat menambahkan buku baru.  | Dapat melihat daftar buku-buku tapi tidak dapat melihat rating yang telah diberikan pada buku tersebut.  |

### 2. Book Tracker (Bulan Athaillah Permata Wijaya)
Buku yang sedang dipinjam dapat di-_track progressnya_ dengan menandai sudah sejauh mana buku dibaca.
#### Peran Role Pengguna
| Member (Login)  | Guest |
| ------------- | ------------- |
| Dapat melakukan _tracking progress_ buku bacaan yang dipinjam dan menghapus buku yang sudah di _track_. | Dapat melakukan _tracking progress_ disaat berkunjung saja dan buku akan bertahan selama 48 jam setelah _tracking_ sebelum akhirnya dihapus. |

### 3. Forum Review (Fikri Dhiya Ramadhana)
Pengguna dapat me-review buku yang sudah dipinjam dan membagikan pengalaman saat menggunakan aplikasi Read&Brew. Digunakan sistem rating untuk setiap pengalaman user. 
#### Peran Role Pengguna
| Member (Login)  | Guest |
| ------------- | ------------- |
| Member dapat menulis review dari buku yang dipinjam dan menceritakan pengalaman user, lalu review akan di simpan ke dalam sistem. | User hanya bisa mengirim feedback secara anonim, jika ingin menulis review dan membagikan pengalamannya maka akan di-direct ke sign up page. |

### 4. Order & Borrow (Alexander Audric Johansyah)
Pengguna dapat memesan berbagai jenis makanan dan minuman yang tersedia di menu cafe Read & Brew. Setelah pengguna memesan makanan dan minuman, pengguna dapat meminjam buku yang tersedia pada katalog buku.

| Member (Login)  | Employee | Guest |
| ------------- | ------------- | ------------- |
| Member dapat memesan makanan dan meminjam buku | Employee dapat memeriksa *inventory* dalam cafe | Guest hanya dapat memesan makanan

### 5. Book Request (Patrick Samuel Evans Simanjuntak)
Pengguna dapat meminta pengelola kafe untuk menambahkan buku-buku yang dirasa menarik dan dibutuhkan oleh pengguna. 
| Member (Login)  | Employee | Guest |
| ------------- | ------------- | ------------- |
| Member membuat *request* buku dan menyukai *request* buku| Employee dapat menyetujui *request* buku | Guest tidak bisa mengakses halaman *book request*.

## 👱‍♂️ Role Pengguna Aplikasi 👩
Karena aplikasi yang dibuat adalah aplikasi Cafe Library, terdapat tiga role yang dapat dibuat pada penggunaan aplikasi ini.
### 1. Seluruh Pelanggan Cafe (Guest)
Guest adalah role pengguna aplikasi yang tidak melakukan register dan login ke aplikasi. Guest dapat memperoleh akses ke beberapa fitur aplikasi secara terbatas.
### 2. Pelanggan Cafe yang Mendaftar pada Aplikasi (Member)
Member adalah role pengguna aplikasi yang melakukan register sebagai member dan login ke aplikasi. Member dapat memperoleh akses ke seluruh fitur aplikasi dan memiliki beberapa keuntungan dibandingkan Guest.
### 3. Pengelola Cafe (Employee)
Employee adalah role pengguna aplikasi yang melakukan register sebagai employee dan login ke aplikasi. Employee dapat memperoleh akses ke seluruh fitur aplikasi seperti Member. Namun, Employee berperan sebagai produsen yang mengatur data pada aplikasi sementara Member sebagai konsumen.

## 🔗 Alur Integrasi dengan Aplikasi Web 🔗
- Pada aplikasi website, membuat beberapa fungsi baru untuk menerima request dan mengirimkan respon ke aplikasi mobile.
- Pada aplikasi mobile, melakukan request ke url fungsi tersebut.
- Request yang dikirim dapat berupa request untuk memperoleh data atau mengirimkan data.
- Fungsi tersebut memberikan respon yang disesuaikan dengan kebutuhan. Respon dapat berupa data ataupun status berhasil/gagal.
- Jika respon berupa status, dapat menyatakan proses yang dilakukan di mobile app sudah terintegrasi dengan web app. Sementara jika respon berupa data, data tersebut dapat ditampilkan/dioperasikan pada mobile app.

## 🗞️ Tautan Berita Acara 🗞️
Tautan berita acara pengerjaan TK PAS dapat diakses di [sini](https://docs.google.com/spreadsheets/d/1o5-FuryeDXj9a6EmaVzszS1mZXWoRaus/edit#gid=427391982).

## 📱 Wireframe 📱
Wireframe rancangan aplikasi dapat diakses di [sini](https://www.figma.com/file/gWach5uBF7S11oFRRGDjxO/read-and-brew?type=design&node-id=110%3A706&mode=design&t=SpDfbbQon1C8exmy-1).