plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.saa.rescuea_miniapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.saa.rescuea_miniapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// Workaround: AMap 3DMap and Location SDKs share common utility classes
// that cause "Duplicate class" errors during AGP transform.
// We keep only the 3DMap SDK and use it as the single implementation,
// relying on its bundled duplicate classes.
dependencies {
    implementation("com.amap.api:3dmap:10.0.600") {
        // Exclude location SDK to avoid duplicate class conflicts;
        // the location classes needed by amap_flutter_location are
        // provided by the plugin's compileOnly + location SDK AAR
    }
}
