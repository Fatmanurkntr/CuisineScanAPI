// script.js (Nihai Versiyon - Anında Çeviri Özellikli)

// --- GLOBAL DEĞİŞKENLER ---
const elements = {
    imageInput: document.getElementById('image-input'),
    predictButton: document.getElementById('predict-button'),
    loader: document.getElementById('loader'),
    resultsArea: document.getElementById('results-area'),
    resultsContent: document.getElementById('results-content'),
    imagePreviewContainer: document.getElementById('image-preview-container'),
    imagePreview: document.getElementById('image-preview'),
    portionControls: document.getElementById('portion-controls'),
    languageSelector: document.getElementById('language-selector')
};
let translations = {};
let selectedLanguage = 'tr'; // Varsayılan dil
let lastSuccessfulData = null; // Son başarılı API yanıtını saklamak için

// --- I18N (ÇOK DİLLİ) SİSTEMİ ---

// Dil dosyalarını yükleyen ve arayüzü ilk kez güncelleyen fonksiyon
async function initI18n() {
    try {
        const response = await fetch(`./locales/${selectedLanguage}.json`);
        if (!response.ok) { throw new Error('Network response was not ok'); }
        translations = await response.json();
        updateUI();
    } catch (error) {
        console.error("Dil dosyası yüklenemedi:", error);
    }
}

// Arayüzdeki tüm statik metinleri seçilen dile göre güncelleyen fonksiyon
function updateUI() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.dataset.i18n;
        if (translations[key]) {
            el.textContent = translations[key];
        }
    });
    document.documentElement.lang = selectedLanguage;
}

// Dil değiştirme butonlarına tıklama olayı
elements.languageSelector.addEventListener('click', async (e) => {
    if (e.target.tagName === 'BUTTON') {
        const lang = e.target.dataset.lang;
        if (lang !== selectedLanguage) {
            selectedLanguage = lang;
            document.querySelectorAll('.lang-btn').forEach(btn => btn.classList.remove('active'));
            e.target.classList.add('active');
            
            await initI18n(); // Yeni dil dosyasını yükle ve statik metinleri güncelle

            // Eğer daha önce gösterilmiş bir sonuç varsa, onu yeni dilde tekrar çizdir.
            if (lastSuccessfulData) {
                displayResults(lastSuccessfulData);
            }
        }
    }
});

// --- ANA İŞLEVSELLİK ---

// "TARA ve TANI" butonuna tıklama olayı
elements.predictButton.addEventListener('click', async () => {
    if (!elements.imageInput.files.length) { 
        alert(translations['alert_select_image'] || "Lütfen bir resim dosyası seçin!"); 
        return; 
    }
    const imageFile = elements.imageInput.files[0];
    const selectedModel = document.querySelector('input[name="modelType"]:checked').value;
    elements.resultsArea.style.display = 'none';
    elements.portionControls.style.display = 'none';
    elements.loader.style.display = 'block';

    const formData = new FormData();
    formData.append('file', imageFile);
    const apiUrl = `http://127.0.0.1:8000/predict`;

    try {
        const response = await fetch(`${apiUrl}?model_type=${selectedModel}`, { method: 'POST', body: formData });
        const data = await response.json();
        
        // Eğer tahmin başarılıysa, sonucu daha sonra kullanmak üzere sakla.
        if (!data.error) {
            lastSuccessfulData = data;
        } else {
            lastSuccessfulData = null; // Hata durumunda eski sonucu temizle
        }

        displayResults(data);
    } catch (error) {
        console.error("İstek hatası:", error);
        lastSuccessfulData = null; // Hata durumunda eski sonucu temizle
        displayResults({ error: "Network Error" });
    } finally {
        elements.loader.style.display = 'none';
    }
});

// Resim seçildiğinde önizleme gösterme
elements.imageInput.addEventListener('change', (event) => {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            elements.imagePreview.src = e.target.result;
            elements.imagePreviewContainer.style.display = 'block';
            elements.resultsArea.style.display = 'none';
            elements.portionControls.style.display = 'none';
            // Yeni resim seçildiğinde, eski sonucu hafızadan da temizle.
            lastSuccessfulData = null;
        };
        reader.readAsDataURL(file);
    }
});

// Sonuçları ekrana yazdırma fonksiyonu
function displayResults(apiData) {
    elements.resultsContent.innerHTML = '';
    elements.portionControls.innerHTML = '';
    elements.resultsArea.style.display = 'block';
    const T = translations;

    if (!apiData || apiData.error) {
        const errorKey = apiData && apiData.error === "Object not recognized" ? "error_unrecognized" : "details_not_found";
        let message = T[errorKey] || "Bir hata oluştu.";
        if(apiData && apiData.error === "Object not recognized") {
             message += ` (En yakın tahmin: '${apiData.guess}' %${(apiData.confidence * 100).toFixed(2)})`;
        }
        elements.resultsContent.innerHTML = `<div class="result-card" style="border-color: #cf6679;"><h3 style="color: #cf6679;">${T.results_title}</h3><p>${message}</p></div>`;
        return;
    }

    const foodKey = apiData.prediction;
    const foodDetails = T.food_details[foodKey];
    const foodData = apiData.data;

    if (!foodDetails || !foodData || !foodData.nutrition_info) {
        elements.resultsContent.innerHTML = `<div class="result-card"><h3>${T.prediction}: ${foodKey}</h3><p>${T.details_not_found}</p></div>`;
        return;
    }

    const nutrition = foodData.nutrition_info;
    const caloriesPer100g = nutrition.calories_per_100g;
    const defaultWeight = nutrition.default_serving_size_g;
    const defaultCalories = (caloriesPer100g / 100) * defaultWeight;

    elements.resultsContent.innerHTML = `
        <div class="result-card">
            <h3>${T.prediction}: ${foodDetails.display_name}</h3>
            <p><strong>${T.confidence}:</strong> <span class="confidence">${(apiData.confidence * 100).toFixed(2)}%</span></p>
        </div>
        <div class="result-card">
            <h4>📖 ${T.information}</h4>
            <p><strong>${T.description}:</strong> ${foodDetails.description}</p>
            <p><strong>${T.history}:</strong> ${foodDetails.history}</p>
            <p><strong>${T.ingredients}:</strong> ${foodDetails.main_ingredients.join(', ')}</p>
        </div>
        <div class="result-card">
            <h4>📊 ${T.nutrition}</h4>
            <p><em>(<span id="serving-description">${foodDetails.serving_size_description}</span> ${T.for_serving})</em></p>
            <p><strong>${T.estimated_calories}:</strong> <span class="calories" id="calorie-display">~${Math.round(defaultCalories)} kcal</span></p>
            <p><strong>${T.vitamins_minerals}:</strong> ${nutrition.vitamins_minerals || T.not_specified}</p>
        </div>
    `;

    elements.portionControls.style.display = 'block';
    elements.portionControls.innerHTML = `
        <h4>${T.adjust_portion}:</h4>
        <button class="portion-btn" data-multiplier="0.75">${T.small}</button>
        <button class="portion-btn active" data-multiplier="1.0">${T.standard}</button>
        <button class="portion-btn" data-multiplier="1.5">${T.large}</button>
    `;

    document.querySelectorAll('.portion-btn').forEach(button => {
        button.addEventListener('click', (e) => {
            document.querySelectorAll('.portion-btn').forEach(btn => btn.classList.remove('active'));
            e.target.classList.add('active');
            const multiplier = parseFloat(e.target.dataset.multiplier);
            const newWeight = defaultWeight * multiplier;
            const newCalories = (caloriesPer100g / 100) * newWeight;
            document.getElementById('calorie-display').textContent = `~${Math.round(newCalories)} kcal`;
            document.getElementById('serving-description').textContent = `${T.approx} ${Math.round(newWeight)}g`;
        });
    });
}

// Sayfa ilk yüklendiğinde dil sistemini başlat
document.addEventListener('DOMContentLoaded', initI18n);