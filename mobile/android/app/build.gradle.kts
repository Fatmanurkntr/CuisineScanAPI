// === İŞTE EKSİK OLAN VE TÜM SORUNU ÇÖZECEK SATIR ===
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun localProperties(): Properties {
    val properties = Properties()
    val localPropertiesFile = project.rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { properties.load(it) }
    }
    return properties
}

val flutterVersionCode = localProperties().getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties().getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.example.cuisinescan_final"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    aaptOptions {
        noCompress.add(".tflite")
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.example.cuisinescan_final"
        minSdk = 26
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {}