# Nemo Compress PDF

Nemo Compress PDF adalah extension sederhana untuk **Nemo File Manager** di Linux Mint yang menambahkan menu klik kanan **Compress PDF** pada file PDF.

Extension ini menggunakan **Ghostscript** untuk mengompres file PDF dan secara otomatis membuat file baru tanpa menimpa file asli.

## Fitur

- Menu klik kanan langsung di Nemo File Manager
- Hanya muncul saat memilih file PDF
- Tidak menimpa file asli
- Hasil kompres otomatis diberi nama `_compress`
- Jika nama hasil sudah ada, otomatis dibuat `_compress_1`, `_compress_2`, dan seterusnya
- Menampilkan notifikasi setelah proses selesai
- Menampilkan ukuran file sebelum dan sesudah kompres
- Menampilkan persentase penghematan ukuran file
- Menggunakan full path file langsung dari Nemo
- Tidak perlu mencari file dengan `find`
- Tidak bergantung pada username pengguna

## Contoh

File asli:

```text
dokumen.pdf
```

Setelah memilih:

```text
Klik kanan → Compress PDF
```

Hasil:

```text
dokumen.pdf
dokumen_compress.pdf
```

Jika dijalankan lagi:

```text
dokumen_compress_1.pdf
dokumen_compress_2.pdf
```

## Instalasi dari paket .deb

Buka Terminal pada folder tempat file `.deb` berada, lalu jalankan:

```bash
sudo apt install ./nemo-compress-pdf_1.0.0_all.deb
```

Setelah instalasi selesai, restart Nemo:

```bash
nemo --quit
```

Kemudian buka kembali Nemo File Manager.

## Cara Menggunakan

1. Buka Nemo File Manager.
2. Pilih satu file PDF.
3. Klik kanan pada file tersebut.
4. Pilih **Compress PDF**.
5. Tunggu sampai muncul notifikasi bahwa proses selesai.

File hasil kompres akan dibuat di folder yang sama dengan file asli.

## Uninstall

Untuk menghapus Nemo Compress PDF:

```bash
sudo apt remove nemo-compress-pdf
```

Kemudian restart Nemo:

```bash
nemo --quit
```

## Dependensi

Paket membutuhkan beberapa komponen berikut:

- Nemo File Manager
- Python 3
- python3-nemo
- gir1.2-nemo-3.0
- Ghostscript
- notify-send / libnotify-bin

Jika menggunakan paket `.deb`, dependensi akan ditangani oleh APT.

## Cara Kerja

Extension mengambil full path file langsung dari API Nemo:

```text
Nemo
  ↓
Full path file PDF
  ↓
Ghostscript
  ↓
File hasil _compress.pdf
```

Contoh:

```text
/home/user/Documents/invoice.pdf
```

akan menghasilkan:

```text
/home/user/Documents/invoice_compress.pdf
```

## Kualitas Kompresi

Versi ini menggunakan preset Ghostscript:

```text
/ebook
```

Preset ini memberikan keseimbangan yang cukup baik antara ukuran file dan kualitas dokumen untuk penggunaan sehari-hari.

## Lokasi Extension

Jika dipasang melalui paket `.deb`, extension dipasang secara system-wide di:

```text
/usr/share/nemo-python/extensions/
```

Dengan metode ini extension dapat digunakan oleh user Linux yang menggunakan Nemo tanpa perlu menulis username secara manual di konfigurasi.

## Troubleshooting

### Menu Compress PDF tidak muncul

Restart Nemo:

```bash
nemo --quit
```

Lalu buka kembali Nemo.

Pastikan paket Nemo Python tersedia:

```bash
dpkg -l | grep python3-nemo
```

### Ghostscript tidak ditemukan

Cek dengan:

```bash
gs --version
```

Jika belum tersedia:

```bash
sudo apt install ghostscript
```

### Extension tidak berjalan

Jalankan Nemo dari Terminal untuk melihat pesan error:

```bash
nemo --quit
nemo
```

Kemudian coba klik kanan file PDF dan jalankan **Compress PDF**.

## Kompatibilitas

Ditujukan terutama untuk:

- Linux Mint
- Nemo File Manager
- Distribusi Linux lain yang menggunakan Nemo dan mendukung Nemo Python Extension

## Versi

```text
1.0.0
```

## Lisensi

Bebas digunakan dan dimodifikasi untuk kebutuhan pribadi maupun internal.

## Catatan

File PDF asli tidak dihapus atau ditimpa. Hasil kompres selalu dibuat sebagai file baru pada folder yang sama.
