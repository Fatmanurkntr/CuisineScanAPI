import json
import os

def combine_food_data():
    print("Veri birleştirme script'i başlatıldı...")
    
    # Dosya yolları
    tech_data_path = 'assets/data/technical_data.json'
    tags_data_path = 'assets/data/tags_data.json'
    lang_tr_path = 'assets/lang/tr.json'
    lang_en_path = 'assets/lang/en.json'
    output_path = 'assets/data/food_data.json'

    try:
        # Tüm kaynak dosyaları oku
        with open(tech_data_path, 'r', encoding='utf-8') as f:
            tech_data = json.load(f)['food_data']
        with open(tags_data_path, 'r', encoding='utf-8') as f:
            tags_data = json.load(f)
        with open(lang_tr_path, 'r', encoding='utf-8') as f:
            lang_tr_data = json.load(f)['food_details']
        with open(lang_en_path, 'r', encoding='utf-8') as f:
            lang_en_data = json.load(f)['food_details']
        print("Tüm kaynak dosyalar başarıyla okundu.")
    except Exception as e:
        print(f"HATA: Dosyalar okunurken bir sorun oluştu! -> {e}")
        return

    # Çıktı için ana yapı
    final_data = {"tr": {}, "en": {}}

    # Türkçe verileri birleştir
    for food_id, details in lang_tr_data.items():
        # Flutter'a uygun hale getirilmiş yeni obje
        final_item = {
            "displayName": details.get("display_name", ""),
            "description": details.get("description", ""),
            "history": details.get("history", ""),
            "mainIngredients": details.get("main_ingredients", []),
            "tags": tags_data.get(food_id, []), # Etiketleri ekle
            "nutritionInfo": tech_data.get(food_id, {}) # Besin değerlerini ekle
        }
        final_data["tr"][food_id] = final_item

    # İngilizce verileri birleştir
    for food_id, details in lang_en_data.items():
        final_item = {
            "displayName": details.get("display_name", ""),
            "description": details.get("description", ""),
            "history": details.get("history", ""),
            "mainIngredients": details.get("main_ingredients", []),
            "tags": tags_data.get(food_id, []), # Etiketleri ekle (İngilizce etiket dosyası da yapılabilir)
            "nutritionInfo": tech_data.get(food_id, {}) # Besin değerleri ekle
        }
        final_data["en"][food_id] = final_item
        
    # Birleşik veriyi yeni dosyaya yaz
    try:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(final_data, f, ensure_ascii=False, indent=2)
        print(f"BAŞARILI! '{output_path}' dosyası oluşturuldu/güncellendi.")
    except Exception as e:
        print(f"HATA: Çıktı dosyası yazılırken bir sorun oluştu! -> {e}")

# Script'i çalıştır
if __name__ == "__main__":
    combine_food_data()