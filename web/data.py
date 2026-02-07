

CLASS_NAMES_TR = [
    'adana-kebap', 'anne-koftesi', 'armut', 'avokado', 'ayran', 'baklava', 'beyaz-lahana-sarmasi', 'biber-dolma', 'brokoli', 'bruksel-lahanasi', 'bulgur-pilavi', 'cacik', 'canak-enginar', 'cay', 'cig-kofte', 'cilek', 'cipura', 'coban-salatasi', 'domates', 'domates-corbasi', 'dondurma', 'doner', 'ekmek', 'elma', 'erik', 'et-sote', 'hamsi-tava', 'haslanmis-yumurta', 'havuc', 'hunkar-begendi', 'icli-kofte', 'incir', 'iskender', 'ispanak-yemegi', 'kabak-mucver', 'kalburabasti', 'karnabahar', 'karniyarik', 'karpuz', 'kavun', 'kayisi', 'kazandibi', 'kemal-pasa-tatlisi', 'kiraz', 'kisir', 'kivi', 'kiymali-borek', 'kiymali-pide', 'kokorec', 'lahmacun', 'levrek', 'lokma', 'mango', 'manti', 'menemen', 'mercimek-corbasi', 'mercimek-koftesi', 'midye-dolma', 'midye-tava', 'mumbar-dolmasi', 'muz', 'nar', 'omlet', 'patates-kizartmasi', 'patates-puresi', 'patates-salatasi', 'patlican-kebabi', 'peynirli-borek', 'pilav', 'pirasa', 'portakal', 'sahlep', 'salatalik', 'salcali-makarna', 'sandvic', 'seftali', 'sehriye-corbasi', 'siyah-zeytin', 'su-boregi', 'sucuklu-yumurta', 'sulu-bamya-yemegi', 'sulu-barbunya-yemegi', 'sulu-bezelye-yemegi', 'sulu-kuru-fasulye-yemegi', 'sulu-mercimek-yemegi', 'sulu-nohut-yemegi', 'sulu-patates-yemegi', 'sutlac', 'tantuni', 'tarhana-corbasi', 'tas-kebabi', 'tavuk-sote', 'tulumba-tatlisi', 'turk-kahvesi', 'tursu', 'uzum', 'yaprak-sarma', 'yayla-corbasi', 'yesil-zeytin', 'yogurt', 'yogurtlu-makarna', 'zeytinyagli-fasulye'
]

CLASS_NAMES_FRUIT_VEG = [
    'apple', 'banana', 'beetroot', 'bell pepper', 'cabbage', 'capsicum', 'carrot', 'cauliflower', 'chilli pepper', 'corn', 'cucumber', 'eggplant', 'garlic', 'ginger', 'grapes', 'jalepeno', 'kiwi', 'lemon', 'lettuce', 'mango', 'onion', 'orange', 'paprika', 'pear', 'peas', 'pineapple', 'pomegranate', 'potato', 'raddish', 'soy beans', 'spinach', 'sweetcorn', 'sweetpotato', 'tomato', 'turnip', 'watermelon'
]


FOOD_DATA = {
    'adana-kebap': {'nutrition_info': {'calories_per_100g': 250, 'default_serving_size_g': 220}},
    'baklava': {'nutrition_info': {'calories_per_100g': 400, 'default_serving_size_g': 80}},
    'doner': {'nutrition_info': {'calories_per_100g': 220, 'default_serving_size_g': 250}},
    'iskender': {'nutrition_info': {'calories_per_100g': 160, 'default_serving_size_g': 450}},
    'manti': {'nutrition_info': {'calories_per_100g': 210, 'default_serving_size_g': 250}},
    'lahmacun': {'nutrition_info': {'calories_per_100g': 180, 'default_serving_size_g': 150}},
    'mercimek-corbasi': {'nutrition_info': {'calories_per_100g': 50, 'default_serving_size_g': 300}},
    'yaprak-sarma': {'nutrition_info': {'calories_per_100g': 140, 'default_serving_size_g': 150}},
    'sutlac': {'nutrition_info': {'calories_per_100g': 135, 'default_serving_size_g': 220}},
    'menemen': {'nutrition_info': {'calories_per_100g': 110, 'default_serving_size_g': 250}},
    'icli-kofte': {'nutrition_info': {'calories_per_100g': 215, 'default_serving_size_g': 180}},
    'kokorec': {'nutrition_info': {'calories_per_100g': 280, 'default_serving_size_g': 200}},
    'cig-kofte': {'nutrition_info': {'calories_per_100g': 170, 'default_serving_size_g': 180}},
    'su-boregi': {'nutrition_info': {'calories_per_100g': 290, 'default_serving_size_g': 150}},
    'tantuni': {'nutrition_info': {'calories_per_100g': 195, 'default_serving_size_g': 200}},
    'kazandibi': {'nutrition_info': {'calories_per_100g': 140, 'default_serving_size_g': 180}},
    'tulumba-tatlisi': {'nutrition_info': {'calories_per_100g': 330, 'default_serving_size_g': 120}},
    'karniyarik': {'nutrition_info': {'calories_per_100g': 180, 'default_serving_size_g': 250}},
    'hunkar-begendi': {'nutrition_info': {'calories_per_100g': 155, 'default_serving_size_g': 300}},
    'bulgur-pilavi': {'nutrition_info': {'calories_per_100g': 130, 'default_serving_size_g': 200}},
    'kisir': {'nutrition_info': {'calories_per_100g': 150, 'default_serving_size_g': 180}},
    'kunefe': {'nutrition_info': {'calories_per_100g': 350, 'default_serving_size_g': 200}},
    'pilav': {'nutrition_info': {'calories_per_100g': 145, 'default_serving_size_g': 200}},
    'cacik': {'nutrition_info': {'calories_per_100g': 45, 'default_serving_size_g': 250}},
    'kiymali-pide': {'nutrition_info': {'calories_per_100g': 240, 'default_serving_size_g': 280}},
    'salcali-makarna': {'nutrition_info': {'calories_per_100g': 140, 'default_serving_size_g': 250}},
    'tavuk-sote': {'nutrition_info': {'calories_per_100g': 130, 'default_serving_size_g': 280}},
    'coban-salatasi': {'nutrition_info': {'calories_per_100g': 35, 'default_serving_size_g': 250}},
    'tarhana-corbasi': {'nutrition_info': {'calories_per_100g': 45, 'default_serving_size_g': 300}},
    'sulu-kuru-fasulye-yemegi': {'nutrition_info': {'calories_per_100g': 125, 'default_serving_size_g': 300}},
    'peynirli-borek': {'nutrition_info': {'calories_per_100g': 275, 'default_serving_size_g': 150}},
    'dondurma': {'nutrition_info': {'calories_per_100g': 210, 'default_serving_size_g': 100}},
    'biber-dolma': {'nutrition_info': {'calories_per_100g': 115, 'default_serving_size_g': 200}},
    'omlet': {'nutrition_info': {'calories_per_100g': 154, 'default_serving_size_g': 120}},
    'turk-kahvesi': {'nutrition_info': {'calories_per_100g': 5, 'default_serving_size_g': 70}},
    'anne-koftesi': {'nutrition_info': {'calories_per_100g': 230, 'default_serving_size_g': 150}},
    'ayran': {'nutrition_info': {'calories_per_100g': 40, 'default_serving_size_g': 300}},
    'cay': {'nutrition_info': {'calories_per_100g': 1, 'default_serving_size_g': 100}},
    'kabak-mucver': {'nutrition_info': {'calories_per_100g': 170, 'default_serving_size_g': 150}},
    'karpuz': {'nutrition_info': {'calories_per_100g': 30, 'default_serving_size_g': 300}},
    'yayla-corbasi': {'nutrition_info': {'calories_per_100g': 65, 'default_serving_size_g': 300}},
    'zeytinyagli-fasulye': {'nutrition_info': {'calories_per_100g': 80, 'default_serving_size_g': 200}},
    'hamsi-tava': {'nutrition_info': {'calories_per_100g': 250, 'default_serving_size_g': 250}},
    'sucuklu-yumurta': {'nutrition_info': {'calories_per_100g': 300, 'default_serving_size_g': 150}},
    'ispanak-yemegi': {'nutrition_info': {'calories_per_100g': 70, 'default_serving_size_g': 300}},
    'midye-dolma': {'nutrition_info': {'calories_per_100g': 150, 'default_serving_size_g': 100}},
    'gözleme': {'nutrition_info': {'calories_per_100g': 260, 'default_serving_size_g': 250}}, 
    'simit': {'nutrition_info': {'calories_per_100g': 275, 'default_serving_size_g': 110}},
    'balik-ekmek': {'nutrition_info': {'calories_per_100g': 180, 'default_serving_size_g': 300}},
    
    # Meyve ve Sebzeler
    'apple': {'nutrition_info': {'calories_per_100g': 52, 'default_serving_size_g': 180, 'vitamins_minerals': 'Rich in Vitamin C, Potassium, and dietary fiber.'}},
    'banana': {'nutrition_info': {'calories_per_100g': 89, 'default_serving_size_g': 118, 'vitamins_minerals': 'Excellent source of Potassium and Vitamin B6. Good source of Vitamin C and Manganese.'}},
    'orange': {'nutrition_info': {'calories_per_100g': 47, 'default_serving_size_g': 150, 'vitamins_minerals': 'Exceptional source of Vitamin C. Also provides Potassium and Vitamin B1 (Thiamine).'}},
    'carrot': {'nutrition_info': {'calories_per_100g': 41, 'default_serving_size_g': 61, 'vitamins_minerals': 'Excellent source of Vitamin A (from beta-carotene), Biotin, and Vitamin K1.'}},
    'tomato': {'nutrition_info': {'calories_per_100g': 18, 'default_serving_size_g': 120, 'vitamins_minerals': 'Great source of Vitamin C and Lycopene, a powerful antioxidant.'}},
    'spinach': {'nutrition_info': {'calories_per_100g': 23, 'default_serving_size_g': 100, 'vitamins_minerals': 'Extremely rich in Vitamin K, Vitamin A, and Iron.'}},
    'cabbage': {'nutrition_info': {'calories_per_100g': 25, 'default_serving_size_g': 89, 'vitamins_minerals': 'Excellent source of Vitamin K and Vitamin C.'}},
    'capsicum': {'nutrition_info': {'calories_per_100g': 20, 'default_serving_size_g': 150, 'vitamins_minerals': 'One of the best sources of Vitamin C, especially the red variety.'}},
    'cauliflower': {'nutrition_info': {'calories_per_100g': 25, 'default_serving_size_g': 100, 'vitamins_minerals': 'Rich in Vitamin C and a good source of Vitamin K and Folate.'}},
    'chilli pepper': {'nutrition_info': {'calories_per_100g': 40, 'default_serving_size_g': 45, 'vitamins_minerals': 'Contains capsaicin, which has metabolism-boosting properties.'}},
    'lemon': {'nutrition_info': {'calories_per_100g': 29, 'default_serving_size_g': 58, 'vitamins_minerals': 'An excellent source of Vitamin C and antioxidants.'}},
    'onion': {'nutrition_info': {'calories_per_100g': 40, 'default_serving_size_g': 110, 'vitamins_minerals': 'Contains the antioxidant quercetin.'}},
    'potato': {'nutrition_info': {'calories_per_100g': 77, 'vitamins_minerals': 'A very good source of Potassium and Vitamin C.'}}
}