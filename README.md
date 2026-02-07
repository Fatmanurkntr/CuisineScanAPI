# CuisineScan: End-to-End AI-Powered Food Recognition Assistant

<img width="1016" height="485" alt="Ekran görüntüsü 2026-02-07 180400" src="https://github.com/user-attachments/assets/0fc80887-7683-4775-987e-08cc2f9f55a9" />

<img width="1044" height="366" alt="Ekran görüntüsü 2026-02-07 180424" src="https://github.com/user-attachments/assets/629c1798-bea5-48a7-909d-036ae0154eab" />

> **"Know Your Food, Taste the World."**

**CuisineScan** is a comprehensive image processing project that instantly recognizes Turkish Cuisine dishes and various fruits/vegetables. It operates both as a Web API and an On-Device Mobile Application.

This project was developed within the scope of the **Istanbul Medeniyet University BİLTAM Summer Internship** and represents an end-to-end engineering effort covering model training, backend service development, and mobile optimization processes.

---

## Evolution of the Project: From Cloud to Edge

This project has undergone a two-stage engineering evolution:

1.  **Phase 1 (Web Prototype):** Initially designed as a Python (FastAPI) based REST API. Models were running on the server.
2.  **Phase 2 (Mobile & Edge AI):** To eliminate server costs and latency, the project was migrated to an **On-Device AI (Edge AI)** architecture. Models were converted to TensorFlow Lite format and embedded into Flutter. This allowed the application to work completely offline without an internet connection.

---

## AI and Model Performance

The project uses two different complementary models trained via **Transfer Learning**:

| Model                       | Architecture   | Dataset                   | Accuracy   |
| :-------------------------- | :------------- | :------------------------ | :--------- |
| **Turkish Cuisine Model**   | EfficientNetB0 | 102 Classes (46k+ Images) | **96.00%** |
| **Fruit & Vegetable Model** | EfficientNetB0 | 36 Classes (3.8k Images)  | **94.30%** |

- **Dual-Model Strategy:** To reduce resource consumption, two separate expert models were trained for "Dishes" and "Fruits/Vegetables". Only the relevant model is loaded into RAM based on the user's selection.
- **Optimization:** Models were optimized using `float32 -> int8` quantization techniques to run efficiently on mobile devices (.tflite).


---

## 1. Mobile Application (Flutter - Offline)

The main product that allows users to recognize food in milliseconds without needing the internet.

### Technologies

- **Framework:** Flutter (Dart)
- **AI Engine:** TensorFlow Lite (`tflite_flutter`)
- **State Management:** Provider
- **Camera:** `camera` package for real-time image streaming.

### Features

- **On-Device Inference:** Sends no photos to a server; all processing happens on the phone (Privacy & Speed).
- **Live Camera & Gallery:** Instant scanning or analysis from the gallery.
- **Smart Mode Switching:** Switch between Turkish Cuisine or Fruit/Vegetable modes.
- **Multi-Language Support:** Turkish and English interface options.

---

## 2. Web API & Prototype (Python - FastAPI)

The initial phase of the project where more powerful models run on a server.

### Technologies

- **Backend:** Python 3.9, FastAPI, Uvicorn
- **Deep Learning:** TensorFlow / Keras (H5 Models)
- **Image Processing:** Pillow (PIL), Numpy
- **Frontend:** HTML5, Bootstrap 5, Vanilla JS

### Features

- **RESTful API:** Takes an image via the `/predict` endpoint and returns a JSON prediction + confidence score.
- **Thresholding:** Filters out predictions with a confidence score below 70% as "Unidentified".

---

## Future Development Ideas (Roadmap)

- **Global Cuisine Expansion:** Thanks to the modular "Expert Models" structure, new cuisine modules (e.g., Italian, Asian, Mexican) can be trained and integrated as separate plugins without altering the core application logic.
- **Restaurant Integration (Google Maps):** Future updates will allow users to find the best local restaurants serving the identified dish based on their location.
- **Social Gastronomy Platform:** Transforming the app into a cultural hub where users can rate dishes, share discoveries, and contribute to the dataset.
- **Cloud Synchronization:** User favorites and history will be synced across devices via cloud authentication.

---

## Project Structure (Monorepo)

This repo is structured as a Monorepo containing both the mobile and web legs of the project:

```bash
CuisineScan_Project/
├── mobile/                  # FLUTTER APPLICATION (Final Product)
│   ├── assets/              # .tflite models are here (Works Offline)
│   ├── lib/                 # Dart source codes
│   └── pubspec.yaml
│
├── web/                     # WEB API PROTOTYPE (Python)
│   ├── main.py              # FastAPI server file
│   ├── data.py              # Food nutritional values database
│   ├── requirements.txt
│   └── *.keras              # (Note: Large models are located here)
└── README.md
```

---

## Installation

### A) Running the Mobile App (Recommended)

1.  Install the Flutter SDK.
2.  Navigate to the `mobile` directory:
    ```bash
    cd mobile
    flutter pub get
    flutter run
    ```
    _(Note: No extra setup needed as .tflite models are ready in the assets folder.)_

### B) Running the Web API

1.  Navigate to the `web` directory and install requirements:
    ```bash
    cd web
    pip install -r requirements.txt
    ```
2.  Start the server:
    ```bash
    uvicorn main:app --reload
    ```
3.  Go to `http://127.0.0.1:8000/docs` in your browser to test the API via Swagger UI.

---


