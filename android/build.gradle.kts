plugins {
    id("com.android.application")
    kotlin("android")
}

android {
    namespace = "com.example.voting_app"

    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.voting_app"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        // Pakai NDK versi yang sudah terinstall
        ndkVersion = "29.0.14206865"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.10")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.9.0")
}
