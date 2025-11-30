# 🍽️ CuisineScan API: Yapay Zeka Destekli Yemek Tanıma Servisi

Bu depo, mobil ve web uygulamalarının kullanması için tasarlanmış, Görüntü İşleme tabanlı Yemek Tanıma Yapay Zeka Modelini servis eden yüksek performanslı bir arka uç API'sidir.

Bu proje, İstanbul Medeniyet Üniversitesi BİLTAM stajı sırasında geliştirilen uçtan uca yemek tanıma çözümünün omurgasını oluşturur.

## ✨ Temel Özellikler

* **Model Servis Etme:** Eğitilmiş Derin Öğrenme (Deep Learning) modelini HTTP istekleri üzerinden erişilebilir hale getirir.
* **Hızlı ve Ölçeklenebilir:** Python'ın modern ve asenkron web framework'ü olan **FastAPI** ile geliştirilmiştir.
* **Görüntü İşleme:** API'ye yüklenen görüntüleri modelin gerektirdiği formatta ön işleme tabi tutar.
* **JSON Çıktısı:** Tanımlanan yemeğin adını ve güven skorunu JSON formatında geri döndürür.

## 💻 Teknolojiler

* **Python:** Ana programlama dili.
* **FastAPI:** API servisi framework'ü.
* **Uvicorn/Gunicorn:** Asenkron sunucu uygulaması.
* **TensorFlow/Keras:** Model yükleme ve tahminleme işlemleri için (varsayılır).

## 🚀 Kullanım

1.  **Ortam Kurulumu:** Gerekli Python paketlerini kurun.
    ```bash
    pip install -r requirements.txt
    ```
2.  **Model Dosyası:** Eğitilmiş model dosyasını (`.h5` veya `.pb` formatında) projenin ilgili dizinine ekleyin.
3.  **Servisi Başlatma:** Uvicorn sunucusunu kullanarak API'yi başlatın.
    ```bash
    uvicorn main:app --reload
    ```
4.  **API Testi:** Tarayıcınızdan `/docs` veya `/redoc` adresine giderek FastAPI tarafından otomatik oluşturulan interaktif API dokümantasyonunu kullanabilirsiniz.
