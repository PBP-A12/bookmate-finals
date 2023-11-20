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


# Nama Aplikasi: BookMate

## 💡 Cerita dan Manfaat Aplikasi
 BookMate adalah platform yang menghubungkan pecinta buku. Tujuannya adalah memfasilitasi koneksi dan pengalaman berbagi antar pembaca dengan minat buku yang serupa. Di era digital ini, banyak orang merasa kesulitan menemukan teman dengan minat buku yang serupa. Oleh karena itu, BookMate menciptakan wadah yang memudahkan pecinta buku untuk terhubung, berinteraksi, dan memperdalam minat mereka dalam dunia literasi.

## 🔍 Daftar Modul
### 1. Authentication (Ester)
Modul ini berisi pengaturan autentikasi pengguna, baik sign up maupun sign in. Ketika pengguna sign up, pengguna perlu memasukkan data-data pribadi seperti username dan password. Selain itu, pengguna diminta memilih interest mereka (genre buku). Setelah terautentikasi, pengguna akan diarahkan ke homepage.   
### 2. Homepage (Ester)
Modul ini berisi halaman utama ketika user mengunjungi website BookMate. Bagi pengguna yang belum login, halaman utamanya berupa landing page yang akan mengarahkan user tersebut untuk login. Sementara itu, bagi user yang sudah login, halaman utama akan berisi list rekomendasi buku (berdasarkan interest) serta search bar untuk mencari buku. User tersebut bisa memilih salah satu buku untuk pergi ke dashboard buku tersebut. Selain list rekomendasi buku, akan ada list pengguna yang sudah di-match dengan pengguna sekarang. 
### 3. Dashboard Profile (Azmy)
Modul ini akan menampilkan profil, baik dirinya sendiri maupun profil pengguna lain. Profil berisi data-data pribadi yang tidak bersifat rahasia, interest, dan buku yang sudah pernah diulas. Pengguna bisa mengedit profilnya sendiri. Pengguna juga bisa melihat profil pengguna lain dalam aplikasi, supaya membantu pengguna untuk berinteraksi dan menjelajahi minat bersama. 
### 4. Matching (Vinka)
Modul ini berisi rekomendasi pengguna lain yang cocok dengan pengguna berdasarkan  buku yang sudah ia review. Pengguna bisa memilih untuk menerima rekomendasi (sehingga di-match) maupun tidak. 
### 5. Dashboard Buku (Reyhan)
Modul ini berisi informasi tentang suatu buku, seperti cover, judul, deskripsi, dan lain-lain, serta terdapat pilihan untuk memberikan review buku. 
### 6. Request Buku (Clarence)
Modul ini berisi form untuk request menambahkan buku ke database. Form ini akan menampilkan juga list buku yang sudah pernah di-request user tersebut. 
### Desain (Azmy)

## Sumber Dataset Katalog Buku
Kami menggunakan dataset katalog yang bersumber di link [berikut](https://drive.google.com/file/d/17jiAwHx_68zUrolbTl75IoLRFK_JLYrx/view)

##  Role Pengguna Aplikasi
- ### Role admin
    - Role ini diakses melalui Django Admin Interface. Admin dapat melihat dan mengatur seluruh database seperti list user, list buku, dan lain-lain. 
- ### Role guest user
    Role ini tidak dapat mengakses fitur apapun, akan diberikan arahan untuk login. 
- ### Role logged in user
    Role ini dapat mengakses seluruh fitur BookMate seperti melihat review orang lain, matching dengan orang lain, edit profile user, dan lain-lain. 

# 📃 Berita Acara
Tautan berita acara dapat diakses [di sini](https://1drv.ms/x/s!AjrL352WxT7K00bPGNhQ-V5CHek-?e=NiacUk) 

# Panduan Penggunaan (Dev Only)
