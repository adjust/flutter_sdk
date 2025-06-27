plugins {
    id("com.android.application")
    id("kotlin-android")
    // the Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.adjust.examples"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.adjust.examples"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    lint {
        disable.add("InvalidPackage")
    }
}

flutter {
    source = "../.."
}

dependencies {
    // google Play Services for analytics
    implementation("com.google.android.gms:play-services-analytics:18.0.1")
    
    // install referrer for attribution
    implementation("com.android.installreferrer:installreferrer:2.2")
    
    // modern logging framework
    implementation("org.slf4j:slf4j-simple:2.0.9")
} 