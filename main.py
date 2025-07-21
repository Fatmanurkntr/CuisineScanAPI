# main.py (i18n Final Versiyonu - Sadeleştirilmiş)

from fastapi import FastAPI, File, UploadFile, Query
from fastapi.middleware.cors import CORSMiddleware
from tensorflow.keras.models import load_model
from PIL import Image
import numpy as np
import io

# Sadece ham veriyi ve sınıf listelerini import ediyoruz
from data import FOOD_DATA, CLASS_NAMES_TR, CLASS_NAMES_FRUIT_VEG

app = FastAPI(title="CuisineScan API")

# CORS middleware'i
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_credentials=True, 
    allow_methods=["*"], allow_headers=["*"]
)

# --- MODELLERİ YÜKLEME ---
TURKISH_FOOD_MODEL_PATH = 'CuisineScan_Phase2_FineTuned.keras'
FRUIT_VEG_MODEL_PATH = 'fruit_veg_best_model.keras'
try:
    turkish_food_model = load_model(TURKISH_FOOD_MODEL_PATH)
    fruit_veg_model = load_model(FRUIT_VEG_MODEL_PATH)
    print("✅ Modeller başarıyla yüklendi!")
except Exception as e:
    print(f"❌ HATA: Modeller yüklenemedi: {e}")
    turkish_food_model = None; fruit_veg_model = None

# Türkçe'den İngilizce'ye çeviri haritası (ortak anahtar sistemi için)
TRANSLATION_MAP = {
    "elma": "apple", "domates": "tomato", "muz": "banana", "portakal": "orange",
    "armut": "pear", "mango": "mango", "kivi": "kiwi", "karpuz": "watermelon",
    "salatalik": "cucumber", "karnabahar": "cauliflower", "havuc": "carrot",
    "patates-kizartmasi": "potato" # patates-kizartmasi'nı genel 'potato' anahtarına bağlayabiliriz
}

def preprocess_image(image_bytes: bytes, target_size: tuple = (224, 224)):
    try:
        img = Image.open(io.BytesIO(image_bytes))
        if img.mode != "RGB": img = img.convert("RGB")
        img = img.resize(target_size)
        return np.expand_dims(np.array(img), axis=0)
    except Exception as e:
        print(f"HATA: Resim işlenemedi: {e}"); return None

CONFIDENCE_THRESHOLD = 0.70

@app.post("/predict")
async def predict(
    model_type: str = Query(..., enum=['turkish_food', 'fruit_veg']), 
    file: UploadFile = File(...)
):
    if model_type == 'turkish_food':
        model, class_names = turkish_food_model, CLASS_NAMES_TR
    else:
        model, class_names = fruit_veg_model, CLASS_NAMES_FRUIT_VEG

    if model is None: return {"error": "Model not loaded"}

    image_bytes = await file.read()
    processed_image = preprocess_image(image_bytes)
    if processed_image is None: return {"error": "Invalid image file"}
    
    prediction = model.predict(processed_image)
    confidence = float(np.max(prediction[0]))
    predicted_index = int(np.argmax(prediction[0]))
    predicted_class_name = class_names[predicted_index]

    if confidence < CONFIDENCE_THRESHOLD:
        return {"error": "Object not recognized", "confidence": confidence, "guess": predicted_class_name}

    # Anahtarı standart İngilizce forma çevirerek tekillik sağla
    lookup_key = TRANSLATION_MAP.get(predicted_class_name, predicted_class_name)
    
    # API artık sadece TAHMİNİ ve HAM VERİYİ döndürür.
    return {
        "prediction": lookup_key,
        "confidence": confidence,
        "data": FOOD_DATA.get(lookup_key) # data.py'dan sadece besin bilgisi vb.
    }

@app.get("/")
def get_root(): return {"message": "CuisineScan API is running!"}