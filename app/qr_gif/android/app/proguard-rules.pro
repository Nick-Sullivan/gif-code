# Keep Kotlin Parcelize
-keep class kotlinx.parcelize.Parcelize
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep Giphy SDK classes
-keep class com.giphy.sdk.** { *; }
-dontwarn com.giphy.sdk.**

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Keep kotlinx.parcelize annotations
-keep class kotlinx.parcelize.** { *; }
-dontwarn kotlinx.parcelize.**