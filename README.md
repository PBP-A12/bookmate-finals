> Proyek ini dibuat untuk memenuhi tugas Proyek Akhir Semester (PAS)
> pada mata kuliah Pemrograman Berbasis Platform (CSGE602022) yang
> diselenggarakan oleh Fakultas Ilmu Komputer, Universitas Indonesia
> pada Semester Gasal, Tahun Ajaran 2023/2024.

# Kelompok A12 👨‍💻👩‍💻
- Clarence Grady (2206081774)
- Ester Gracia  (2206041991)
- Muhammad Azmy Arya Rizaldi Mintaraga (2206081704)
- Reyhan Wiyasa Puspanegara (2206081925)
- Vinka Alrezky As (2206820200)

# BookMate
[![Staging](https://github.com/PBP-A12/bookmate-finals/actions/workflows/staging.yml/badge.svg)](https://github.com/PBP-A12/bookmate-finals/actions/workflows/staging.yml)
[![Pre-Release](https://github.com/PBP-A12/bookmate-finals/actions/workflows/pre-release.yml/badge.svg)](https://github.com/PBP-A12/bookmate-finals/actions/workflows/pre-release.yml)
[![Release](https://github.com/PBP-A12/bookmate-finals/actions/workflows/release.yml/badge.svg)](https://github.com/PBP-A12/bookmate-finals/actions/workflows/release.yml)

## 💡 Cerita dan Manfaat Aplikasi
 BookMate adalah platform yang menghubungkan pecinta buku. Tujuannya adalah memfasilitasi koneksi dan pengalaman berbagi antar pembaca dengan minat buku yang serupa. Di era digital ini, banyak orang merasa kesulitan menemukan teman dengan minat buku yang serupa. Oleh karena itu, BookMate menciptakan wadah yang memudahkan pecinta buku untuk terhubung, berinteraksi, dan memperdalam minat mereka dalam dunia literasi.

## 🔍 Daftar Modul
### 1. Authentication (Ester)
Modul ini berisi pengaturan autentikasi pengguna, baik _sign up_ maupun _sign in_. Ketika pengguna _sign up_, pengguna perlu memasukkan data-data pribadi seperti _username_ dan _password_. Selain itu, pengguna diminta memilih interest mereka (genre buku). Setelah terautentikasi, pengguna akan diarahkan ke _homepage_.   
### 2. Homepage (Ester)
Modul ini berisi halaman utama ketika user membuka aplikasi BookMate. Bagi pengguna yang belum _login_, halaman utamanya berupa _landing page_ yang akan mengarahkan user tersebut untuk _login_. Sementara itu, bagi user yang sudah _login_, halaman utama akan berisi list rekomendasi buku (berdasarkan _interest_) serta _search bar_ untuk mencari buku. User tersebut bisa memilih salah satu buku untuk pergi ke _dashboard_ buku tersebut. Selain list rekomendasi buku, akan ada list pengguna yang sudah di-_match_ dengan pengguna sekarang. 
### 3. Dashboard Profile (Azmy)
Modul ini akan menampilkan profil, baik dirinya sendiri maupun profil pengguna lain. Profil berisi data-data pribadi yang tidak bersifat rahasia, _interest_, dan buku yang sudah pernah diulas. Pengguna bisa mengedit profilnya sendiri. Pengguna juga bisa melihat profil pengguna lain dalam aplikasi, supaya membantu pengguna untuk berinteraksi dan menjelajahi minat bersama. 
### 4. Matching (Vinka)
Modul ini berisi rekomendasi pengguna lain yang cocok dengan pengguna berdasarkan  buku yang sudah ia _review_. Pengguna bisa memilih untuk menerima rekomendasi (sehingga di-_match_) maupun tidak. 
### 5. Dashboard Buku (Reyhan)
Modul ini berisi informasi tentang suatu buku, seperti _cover_, judul, deskripsi, dan lain-lain, serta terdapat pilihan untuk memberikan _review_ buku. 
### 6. Request Buku (Clarence)
Modul ini berisi form untuk _request_ menambahkan buku ke database. Form ini akan menampilkan juga list buku yang sudah pernah di-_request_ user tersebut. 
### Desain (Azmy)

## Sumber Dataset Katalog Buku
Kami menggunakan dataset katalog yang bersumber di link [berikut](https://drive.google.com/file/d/17jiAwHx_68zUrolbTl75IoLRFK_JLYrx/view)

##  Role Pengguna Aplikasi
- ### Role admin
    Role ini diakses melalui `Django Admin Interface`. Admin dapat melihat dan mengatur seluruh database seperti list user, list buku, dan lain-lain. 
- ### Role guest user
    Role ini tidak dapat mengakses fitur apapun, akan diberikan arahan untuk _login_. 
- ### Role logged in user
    Role ini dapat mengakses seluruh fitur BookMate seperti melihat _review_ orang lain, _matching_ dengan orang lain, edit profile user, dan lain-lain. 

## 🌐 Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester
1. Integrasi aplikasi mobile dan web service dapat dilakukan dengan cara melakukan pengambilan data berformat `JSON` atau `Javascript Object Notation` di aplikasi mobile pada web service dengan menggunakan url untuk deploy Proyek Tengah Semester.
2. Proses _fetch_ dapat dilakukan dengan menggunakan `Uri.parse` di dalam file Dart, lalu mengambilnya menggunakan get dengan tipe `application/json`. 
3. Selanjutnya, data yang telah diambil tadi dapat di-_decode_ menggunakan `jsonDecode()` yang nantinya akan di-_convert_ melalui model yang telah dibuat dan ditampilkan secara asinkronus menggunakan widget `FutureBuilder`
4. Data - data `JSON` tadi dapat digunakan secara CRUD pada kedua media secara asinkronus

## 📃 Berita Acara
Tautan berita acara dapat diakses [di sini](https://1drv.ms/x/s!AjrL352WxT7K00bPGNhQ-V5CHek-?e=NiacUk) 

## 🚀 Deployment Aplikasi
- Deployment Web-App dapat diakses [di sini](https://bookmate-a12-tk.pbp.cs.ui.ac.id/)
- GitHub Release: APK BookMate akan tersedia [di sini]()
- Platform Cloud: Kami akan menggunakan [Microsoft App Center]() untuk distribusi dan pengujian


# Panduan Penggunaan (Dev Only)


*© Kelompok A12, Fakultas Ilmu Komputer, Universitas Indonesia - 2023/2024*
