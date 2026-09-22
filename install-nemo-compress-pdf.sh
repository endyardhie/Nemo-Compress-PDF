#!/bin/bash
set -e

sudo apt update
sudo apt install -y nemo python3-nemo gir1.2-nemo-3.0 ghostscript libnotify-bin python3-gi
mkdir -p "$HOME/.local/share/nemo-python/extensions"
rm -f "$HOME/.local/share/nemo/actions/compress-pdf.nemo_action"
cat > "$HOME/.local/share/nemo-python/extensions/compress_pdf.py" <<'PY'
#!/usr/bin/python3
import os
import subprocess
from gi.repository import GObject, Nemo

class CompressPDFExtension(GObject.GObject, Nemo.MenuProvider):
    def get_file_items(self, *args):
        files = args[-1] if args else []
        if not files or len(files) != 1:
            return []
        f = files[0]
        try:
            if f.get_uri_scheme() != "file":
                return []
        except Exception:
            return []
        path = f.get_location().get_path()
        if not path or not path.lower().endswith(".pdf"):
            return []
        item = Nemo.MenuItem(name="CompressPDF::Compress", label="Compress PDF", tip="Compress PDF dan buat salinan _compress", icon="document-save")
        item.connect("activate", self.compress_pdf, path)
        return [item]

    def compress_pdf(self, menu, input_path):
        directory = os.path.dirname(input_path)
        filename = os.path.basename(input_path)
        name, _ = os.path.splitext(filename)
        output = os.path.join(directory, f"{name}_compress.pdf")
        i = 1
        while os.path.exists(output):
            output = os.path.join(directory, f"{name}_compress_{i}.pdf")
            i += 1
        try:
            r = subprocess.run(["gs","-sDEVICE=pdfwrite","-dCompatibilityLevel=1.4","-dPDFSETTINGS=/ebook","-dNOPAUSE","-dQUIET","-dBATCH",f"-sOutputFile={output}",input_path], check=False)
            if r.returncode == 0 and os.path.isfile(output) and os.path.getsize(output) > 0:
                old = os.path.getsize(input_path); new = os.path.getsize(output)
                old_mb = old/1048576; new_mb = new/1048576
                reduction = (1-new/old)*100 if old else 0
                detail = f"{old_mb:.2f} MB → {new_mb:.2f} MB\n" + (f"Hemat {reduction:.0f}%" if reduction >= 0 else f"Ukuran bertambah {abs(reduction):.0f}%")
                subprocess.Popen(["notify-send","PDF berhasil dikompres",f"{os.path.basename(output)}\n{detail}"])
            else:
                if os.path.exists(output): os.remove(output)
                subprocess.Popen(["notify-send","Compress PDF gagal",filename])
        except Exception as e:
            if os.path.exists(output): os.remove(output)
            subprocess.Popen(["notify-send","Compress PDF gagal",str(e)])
PY
chmod +x "$HOME/.local/share/nemo-python/extensions/compress_pdf.py"
nemo --quit 2>/dev/null || true
printf '\nSelesai. Buka Nemo kembali lalu klik kanan file PDF -> Compress PDF\n'
