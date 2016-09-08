set(RUNTIME_INSTALL_DESTINATION bin)
set(LIBRARY_INSTALL_DESTINATION lib)

if(MSVC OR APPLE)
	set(README_INSTALL_DESTINATION .)
	set(DATA_INSTALL_DESTINATION data)
	set(SHADERS_INSTALL_DESTINATION data/shaders)
else()
	set(README_INSTALL_DESTINATION share/ncpong)
	set(DATA_INSTALL_DESTINATION share/ncpong/data)
	set(SHADERS_INSTALL_DESTINATION share/ncpong/shaders)
endif()

set(CPACK_PACKAGE_NAME "ncPong")
set(CPACK_PACKAGE_VENDOR "")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "An example game made with the nCine")
set(CPACK_PACKAGE_CONTACT "encelo@gmail.com")
set(CPACK_PACKAGE_VERSION ${NCPONG_VERSION})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "ncPong")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")
if(MSVC)
	set(CPACK_GENERATOR NSIS ZIP)
	set(CPACK_NSIS_MUI_ICON "${NCPONG_DATA_DIR}/icons/ncPong.ico")
	set(CPACK_NSIS_COMPRESSOR "/SOLID lzma")
elseif(APPLE)
	set(CPACK_GENERATOR "Bundle")
	set(CPACK_BUNDLE_NAME ncPong)
	set(FRAMEWORKS_INSTALL_DESTINATION ../Frameworks)

	configure_file(${CMAKE_SOURCE_DIR}/Info.plist.in ${CMAKE_BINARY_DIR}/Info.plist @ONLY)
	set(CPACK_BUNDLE_PLIST ${CMAKE_BINARY_DIR}/Info.plist)

	file(RELATIVE_PATH RELPATH_TO_BIN ${CMAKE_INSTALL_PREFIX}/MacOS ${CMAKE_INSTALL_PREFIX}/Resources/${RUNTIME_INSTALL_DESTINATION})
	file(WRITE ${CMAKE_BINARY_DIR}/bundle_executable "#!/usr/bin/env sh\ncd \"$(dirname \"$0\")\" \ncd ${RELPATH_TO_BIN} && ./pong")
	install(FILES ${CMAKE_BINARY_DIR}/bundle_executable DESTINATION ../MacOS/ RENAME ${CPACK_BUNDLE_NAME}
		PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE COMPONENT tests)

	add_custom_command(
		OUTPUT ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NCPONG_DATA_DIR}/icons/icon1024.png ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_512x512@2x.png
		COMMAND sips -z 512 512 ${NCPONG_DATA_DIR}/icons/icon1024.png --out ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_512x512.png
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_512x512.png ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_256x256@2x.png
		COMMAND sips -z 256 256 ${NCPONG_DATA_DIR}/icons/icon1024.png --out ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_256x256.png
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_256x256.png ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_128x128@2x.png
		COMMAND sips -z 128 128 ${NCPONG_DATA_DIR}/icons/icon1024.png --out ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_128x128.png
		COMMAND sips -z 64 64 ${NCPONG_DATA_DIR}/icons/icon1024.png --out ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_32x32@2x.png
		COMMAND sips -z 32 32 ${NCPONG_DATA_DIR}/icons/icon1024.png --out ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_32x32.png
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_32x32.png ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_16x16@2x.png
		COMMAND sips -z 16 16 ${NCPONG_DATA_DIR}/icons/icon1024.png --out ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset/icon_16x16.png
		COMMAND iconutil --convert icns --output ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.icns ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset)
	add_custom_target(iconutil_convert ALL DEPENDS ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.iconset)
	set(CPACK_BUNDLE_ICON ${CMAKE_BINARY_DIR}/${CPACK_BUNDLE_NAME}.icns)
endif()
include(CPack)
