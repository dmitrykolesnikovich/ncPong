if(NCPONG_PREPARE_ANDROID)
	set(ARCHITECTURES armeabi-v7a)
	foreach(ARCHITECTURE ${ARCHITECTURES})
		set(NCPONG_APP_ABI "${NCPONG_APP_ABI} ${ARCHITECTURE}")
	endforeach()
	set(NCPONG_APP_PLATFORM android-13)
	if(CMAKE_BUILD_TYPE STREQUAL "Release")
		set(NCPONG_APP_OPTIM release)
	else()
		set(NCPONG_APP_OPTIM debug)
	endif()

	set(APPLICATION_MK_IN ${CMAKE_SOURCE_DIR}/android/src/main/jni/Application.mk.in)
	set(APPLICATION_MK ${CMAKE_BINARY_DIR}/android/src/main/jni/Application.mk)
	configure_file(${APPLICATION_MK_IN} ${APPLICATION_MK} @ONLY)

	set(NCPONG_INCLUDE_DIR ${CMAKE_SOURCE_DIR})
	set(NCPONG_SRC_DIR ${CMAKE_SOURCE_DIR})
	set(ANDROID_MK_IN ${CMAKE_SOURCE_DIR}/android/src/main/jni/Android.mk.in)
	set(ANDROID_MK ${CMAKE_BINARY_DIR}/android/src/main/jni/Android.mk)
	configure_file(${ANDROID_MK_IN} ${ANDROID_MK} @ONLY)

	set(NCPONG_COMPILESDK_VERSION 23)
	set(NCPONG_MINSDK_VERSION 13)
	set(NCPONG_TARGETSDK_VERSION 23)
	set(BUILD_GRADLE_IN ${CMAKE_SOURCE_DIR}/android/build.gradle.in)
	set(BUILD_GRADLE ${CMAKE_BINARY_DIR}/android/build.gradle)
	configure_file(${BUILD_GRADLE_IN} ${BUILD_GRADLE} @ONLY)

	file(COPY android/gradle.properties DESTINATION android)
	file(COPY android/src/main/AndroidManifest.xml DESTINATION android/src/main)
	file(COPY android/src/main/java/io/github/ncine/ncpong/LoadLibraries.java DESTINATION android/src/main/java/io/github/ncine/ncpong)
	file(COPY android/src/main/java/io/github/ncine/ncpong/LoadLibrariesTV.java DESTINATION android/src/main/java/io/github/ncine/ncpong)
	file(COPY ${NCINE_ANDROID_DIR}/src/main/jni/main.cpp DESTINATION android/src/main/jni)
	file(COPY android/src/main/res/values/strings.xml DESTINATION android/src/main/res/values)
	file(COPY ${NCPONG_DATA_DIR}/icons/icon48.png DESTINATION android/src/main/res/mipmap-mdpi)
	file(RENAME ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-mdpi/icon48.png ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-mdpi/ic_launcher.png)
	file(COPY ${NCPONG_DATA_DIR}/icons/icon72.png DESTINATION android/src/main/res/mipmap-hdpi)
	file(RENAME ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-hdpi/icon72.png ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-hdpi/ic_launcher.png)
	file(COPY ${NCPONG_DATA_DIR}/icons/icon96.png DESTINATION android/src/main/res/mipmap-xhdpi)
	file(RENAME ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-xhdpi/icon96.png ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-xhdpi/ic_launcher.png)
	file(COPY ${NCPONG_DATA_DIR}/icons/icon144.png DESTINATION android/src/main/res/mipmap-xxhdpi)
	file(RENAME ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-xxhdpi/icon144.png ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-xxhdpi/ic_launcher.png)
	file(COPY ${NCPONG_DATA_DIR}/icons/icon192.png DESTINATION android/src/main/res/mipmap-xxxhdpi)
	file(RENAME ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-xxxhdpi/icon192.png ${CMAKE_BINARY_DIR}/android/src/main/res/mipmap-xxxhdpi/ic_launcher.png)

	file(COPY ${NCPONG_DATA_DIR}/data/DroidSans32_256.fnt ${NCPONG_DATA_DIR}/data/out.wav ${NCPONG_DATA_DIR}/data/tick.wav DESTINATION android/src/main/assets/)
	file(COPY ${NCPONG_DATA_DIR}/android/DroidSans32_256.webp DESTINATION android/src/main/assets/)
	file(COPY ${NCPONG_DATA_DIR}/android/sticks_256.webp DESTINATION android/src/main/assets/)

	if(NCINE_INSTALL_DIR OR NCINE_SHARE_DIR)
		file(COPY ${NCINE_ANDROID_DIR}/src/main/jni/openal DESTINATION android/src/main/jni/)
		file(COPY ${NCINE_ANDROID_DIR}/src/main/jni/ncine DESTINATION android/src/main/jni/)
	else()
		foreach(ARCHITECTURE ${ARCHITECTURES})
			file(COPY ${NCINE_ANDROID_DIR}/src/main/jni/openal/${ARCHITECTURE}/libopenal.so DESTINATION android/src/main/jni/openal/${ARCHITECTURE})
			file(COPY ${NCINE_ANDROID_DIR}/src/main/libs/${ARCHITECTURE}/libncine.so DESTINATION android/src/main/jni/ncine/${ARCHITECTURE})
		endforeach()
		file(COPY ${NCINE_INCLUDE_DIR} DESTINATION android/src/main/jni/ncine)
	endif()
endif()


