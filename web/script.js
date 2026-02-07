document.addEventListener('DOMContentLoaded', () => {

    console.log("DOM tamamen yüklendi. CuisineScan v3.6 (Nihai) script'i çalışıyor.");

    // --- GLOBAL DEĞİŞKENLER ---
    const elements = {
        imageInput: document.getElementById('image-input'),
        loader: document.getElementById('loader'),
        resultsArea: document.getElementById('results-area'),
        imagePreview: document.getElementById('image-preview'),
        languageSelectors: document.querySelectorAll('#language-selector-desktop, #language-selector-mobile'),
        uploadPrompt: document.getElementById('upload-prompt'),
        resultsPlaceholder: document.getElementById('results-placeholder'),
        uploadBox: document.querySelector('.upload-box'),
        scannerModalElement: document.getElementById('scannerModal'),
        mainNavElement: document.getElementById('mainNav')
    };

    let translations = {};
    let selectedLanguage = 'tr';
    let lastSuccessfulData = null;

    // --- I18N (ÇOK DİLLİ) SİSTEMİ ---
    async function initI18n() {
        try {
            const response = await fetch(`./locales/${selectedLanguage}.json`);
            if (!response.ok) { throw new Error(`HTTP error! status: ${response.status}`); }
            translations = await response.json();
            updateUI();
        } catch (error) {
            console.error("Dil dosyası yüklenemedi:", error);
        }
    }

    function updateUI() {
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.dataset.i18n;
            if (translations[key]) {
                el.textContent = translations[key];
            }
        });
        document.documentElement.lang = selectedLanguage;
        populateExploreSection();
        if (lastSuccessfulData) {
            displayResults(lastSuccessfulData);
        }
    }

    elements.languageSelectors.forEach(selector => {
        selector.addEventListener('click', async (e) => {
            if (e.target.tagName === 'BUTTON' && e.target.dataset.lang) {
                const lang = e.target.dataset.lang;
                if (lang !== selectedLanguage) {
                    selectedLanguage = lang;
                    elements.languageSelectors.forEach(sel => {
                        sel.querySelectorAll('.btn').forEach(btn => btn.classList.remove('active'));
                        sel.querySelector(`.btn[data-lang="${lang}"]`).classList.add('active');
                    });
                    await initI18n();
                }
            }
        });
    });

    // --- ANA İŞLEVSELLİK ---
    elements.imageInput.addEventListener('change', (event) => {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (e) => {
                elements.imagePreview.src = e.target.result;
                elements.imagePreview.classList.remove('d-none');
                elements.uploadPrompt.classList.add('d-none');
                elements.uploadBox.classList.add('has-image');
                resetPredictionState();
                createAndShowPredictButton();
            };
            reader.readAsDataURL(file);
        }
    });

    function createAndShowPredictButton() {
        const existingButton = document.getElementById('predict-button');
        if (existingButton) existingButton.remove();
        const predictButton = document.createElement('button');
        predictButton.id = 'predict-button';
        predictButton.className = 'btn btn-success w-100 fw-bold mt-3';
        predictButton.textContent = translations['button_scan'] || 'TARA ve TANI';
        elements.uploadBox.insertAdjacentElement('afterend', predictButton);
        predictButton.addEventListener('click', handlePrediction);
    }
    
    async function handlePrediction() {
        const predictButton = document.getElementById('predict-button');
        if (!elements.imageInput.files.length) { 
            alert(translations['alert_select_image'] || "Lütfen bir resim dosyası seçin!"); 
            return; 
        }
        
        const imageFile = elements.imageInput.files[0];
        const selectedModel = document.querySelector('input[name="modelType"]:checked').value;

        if (predictButton) predictButton.classList.add('d-none');
        elements.resultsPlaceholder.classList.add('d-none');
        elements.loader.classList.remove('d-none');
        elements.resultsArea.innerHTML = '';

        const formData = new FormData();
        formData.append('file', imageFile);
        const apiUrl = `http://127.0.0.1:8000/predict`;

        try {
            const response = await fetch(`${apiUrl}?model_type=${selectedModel}`, { method: 'POST', body: formData });
            if (!response.ok) { throw new Error(`Sunucu Hatası: ${response.status} ${response.statusText}`); }
            const data = await response.json();
            
            lastSuccessfulData = !data.error ? data : null;
            elements.loader.classList.add('d-none');
            displayResults(data);
        } catch (error) {
            console.error("İstek hatası:", error);
            lastSuccessfulData = null;
            elements.loader.classList.add('d-none');
            displayResults({ error: "Network Error", details: error.message });
        }
    }

    function resetPredictionState() {
        lastSuccessfulData = null;
        elements.resultsArea.innerHTML = '';
        elements.resultsPlaceholder.classList.remove('d-none');
        const oldButton = document.getElementById('predict-button');
        if (oldButton) oldButton.remove();
    }

    elements.scannerModalElement.addEventListener('hidden.bs.modal', () => {
        elements.imageInput.value = '';
        elements.imagePreview.classList.add('d-none');
        elements.uploadPrompt.classList.remove('d-none');
        elements.uploadBox.classList.remove('has-image');
        resetPredictionState();
    });

    // --- SONUÇLARI GÖSTERME ---
    function displayResults(apiData) {
        elements.resultsArea.innerHTML = '';
        const T = translations;

        if (!apiData || apiData.error) {
            let message = T[apiData?.error === "Object not recognized" ? "error_unrecognized" : "details_not_found"] || "Bir hata oluştu.";
            if (apiData?.guess) message += ` (${T.closest_prediction || 'En yakın tahmin'}: '${apiData.guess}' %${(apiData.confidence * 100).toFixed(1)})`;
            if (apiData?.details) message += `<br><small class="text-muted">${apiData.details}</small>`;
            elements.resultsArea.innerHTML = `<div class="alert alert-danger" role="alert"><strong>${T.error_title || 'Hata'}:</strong> ${message}</div>`;
            return;
        }

        const foodKey = apiData.prediction;
        const foodDetails = T.food_details?.[foodKey] || { display_name: foodKey };
        const foodData = apiData.data;

        if (!foodData?.nutrition_info) {
            elements.resultsArea.innerHTML = `<div class="alert alert-warning" role="alert"><strong>${T.prediction || 'Tahmin'}: ${foodDetails.display_name}</strong> - ${T.details_not_found || 'Detaylı bilgi bulunamadı.'}</div>`;
            return;
        }
        
        const nutrition = foodData.nutrition_info;
        const caloriesPer100g = nutrition.calories_per_100g;
        const defaultWeight = nutrition.default_serving_size_g;
        const defaultCalories = (caloriesPer100g / 100) * defaultWeight;

        const resultCardHTML = `
            <div class="card bg-transparent border-0 text-start">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h3 class="mb-0">${foodDetails.display_name || foodKey}</h3>
                    <span class="badge bg-primary rounded-pill fs-6">${T.confidence || 'Benzerlik'}: ${(apiData.confidence * 100).toFixed(1)}%</span>
                </div>
                <p class="card-text text-muted">${foodDetails.description || ''}</p>
                <ul class="list-group list-group-flush mt-3">
                    <li class="list-group-item bg-transparent"><strong>📖 ${T.history || 'Tarihçe'}:</strong> ${foodDetails.history || T.not_specified || 'Belirtilmemiş'}</li>
                    <li class="list-group-item bg-transparent"><strong>🥗 ${T.ingredients || 'İçindekiler'}:</strong> ${foodDetails.main_ingredients ? foodDetails.main_ingredients.join(', ') : T.not_specified || 'Belirtilmemiş'}</li>
                    <li class="list-group-item bg-transparent">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <strong>📊 ${T.nutrition || 'Besin Değeri'}</strong> 
                                <small class="text-muted">(${T.for_serving || 'porsiyon için'} <span id="serving-description">${foodDetails.serving_size_description || ''}</span>)</small>
                            </div>
                            <span class="badge bg-warning text-dark fs-5 rounded-pill" id="calorie-display">~${Math.round(defaultCalories)} kcal</span>
                        </div>
                        <div id="portion-controls" class="btn-group w-100 mt-3" role="group">
                            <button type="button" class="btn btn-outline-secondary" data-multiplier="0.75">${T.small || 'Küçük'}</button>
                            <button type="button" class="btn btn-outline-secondary active" data-multiplier="1.0">${T.standard || 'Normal'}</button>
                            <button type="button" class="btn btn-outline-secondary" data-multiplier="1.5">${T.large || 'Büyük'}</button>
                        </div>
                    </li>
                </ul>
            </div>
        `;
        elements.resultsArea.innerHTML = resultCardHTML;
        
        document.querySelectorAll('#portion-controls .btn').forEach(button => {
            button.addEventListener('click', (e) => {
                document.querySelectorAll('#portion-controls .btn').forEach(btn => btn.classList.remove('active'));
                e.currentTarget.classList.add('active');
                const multiplier = parseFloat(e.currentTarget.dataset.multiplier);
                const newCalories = (caloriesPer100g / 100) * (defaultWeight * multiplier);
                document.getElementById('calorie-display').textContent = `~${Math.round(newCalories)} kcal`;
                document.getElementById('serving-description').textContent = `${T.approx || '~'} ${Math.round(defaultWeight * multiplier)}g`;
            });
        });
    }

    // --- KEŞFET BÖLÜMÜNÜ DOLDURMA ---
    function populateExploreSection() {
        const exploreCardsContainer = document.getElementById('explore-cards');
        if (!exploreCardsContainer) return;
        const titleElement = document.querySelector('[data-i18n="explore_title"]');
        const subtitleElement = document.querySelector('[data-i18n="explore_subtitle"]');
        const exploreData = translations.explore_section;
        
        if (exploreData) {
            if (titleElement && exploreData.title) titleElement.textContent = exploreData.title;
            if (subtitleElement && exploreData.subtitle) subtitleElement.textContent = exploreData.subtitle;
            exploreCardsContainer.innerHTML = '';
            if (exploreData.foods) {
                exploreData.foods.forEach((food, index) => {
                    const cardHTML = `
                        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="${index * 100}">
                            <div class="card h-100">
                                <img src="${food.image}" class="card-img-top" alt="${food.name}">
                                <div class="card-body">
                                    <h5 class="card-title">${food.name}</h5>
                                    <p class="card-text text-muted">${food.description}</p>
                                </div>
                            </div>
                        </div>
                    `;
                    exploreCardsContainer.innerHTML += cardHTML;
                });
            }
        }
    }

    // --- MOBİL MENÜ LİNK KAYDIRMA DÜZELTMESİ (NİHAİ VERSİYON) ---
    if (elements.mainNavElement) {
        const mainNavCollapse = new bootstrap.Collapse(elements.mainNavElement, { toggle: false });
        // Sadece mobil menüdeki linkleri seç
        const mobileNavLinks = elements.mainNavElement.querySelectorAll('.header-bottom-nav-mobile a[href^="#"]');

        mobileNavLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                const href = link.getAttribute('href');
                if (href && href.startsWith('#')) {
                    const targetElement = document.querySelector(href);
                    if (targetElement) {
                        e.preventDefault();
                        
                        // Bootstrap'in "menü tamamen kapandı" olayını dinle
                        elements.mainNavElement.addEventListener('hidden.bs.collapse', () => {
                            targetElement.scrollIntoView({ behavior: 'smooth' });
                        }, { once: true });

                        // Menüyü kapatma komutunu ver
                        mainNavCollapse.hide();
                    }
                }
            });
        });
    }


    // --- HEADER KAYDIRMA EFEKTİ ---
    const siteHeader = document.querySelector('.site-header');
    if (siteHeader) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 10) {
                siteHeader.classList.add('scrolled');
            } else {
                siteHeader.classList.remove('scrolled');
            }
        });
    }

    // --- AOS KÜTÜPHANESİNİ BAŞLATMA ---
    AOS.init({
        duration: 800,
        once: true
    });

    // Sayfa ilk yüklendiğinde dil sistemini başlat
    initI18n();

});