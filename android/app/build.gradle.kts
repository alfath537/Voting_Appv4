plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Firebase
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.voting_app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.voting_app"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        // Untuk project yang menggunakan banyak metode di DEX
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("debug") // ganti ke release signing nanti
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    lint {
        abortOnError = false
    }
}

flutter {
    source = "../.."
}
