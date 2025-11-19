import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) {
        file.inputStream().use { load(it) }
    }
}

fun getWonderPushProperty(key: String, fallback: String): String =
    localProperties.getProperty(key)?.takeIf { it.isNotBlank() } ?: fallback

fun String.toBuildConfigString(): String = "\"${this.replace("\"", "\\\"")}\""

android {
    namespace = "com.example.koma_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.koma_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        val wonderPushClientId =
            getWonderPushProperty("wonderpush.clientId", "YOUR_WONDERPUSH_CLIENT_ID")
        val wonderPushClientSecret =
            getWonderPushProperty("wonderpush.clientSecret", "YOUR_WONDERPUSH_CLIENT_SECRET")
        val wonderPushSenderId =
            getWonderPushProperty("wonderpush.senderId", "YOUR_FIREBASE_SENDER_ID")

        buildConfigField("String", "WONDERPUSH_CLIENT_ID", wonderPushClientId.toBuildConfigString())
        buildConfigField(
            "String",
            "WONDERPUSH_CLIENT_SECRET",
            wonderPushClientSecret.toBuildConfigString(),
        )
        buildConfigField(
            "String",
            "WONDERPUSH_SENDER_ID",
            wonderPushSenderId.toBuildConfigString(),
        )
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
