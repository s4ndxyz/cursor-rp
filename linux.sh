#!/bin/bash

# 定义语言变量，默认为中文
LANG_CODE="${LANG_CODE:-zh}"

# 定义多语言消息
if [ "$LANG_CODE" == "en" ]; then
  MSG_ERROR_NOT_FOUND="Error: Cursor AppImage not found"
  MSG_ERROR_INVALID_MODE="Error: Invalid mode. Use 'patch' or 'restore'."
  MSG_PATCHING="Patching Cursor AppImage..."
  MSG_RESTORING="Restoring Cursor AppImage..."
  MSG_UNPACKING="Unpacking AppImage..."
  MSG_UNPACKED_TO="AppImage unpacked ->"
  MSG_PATCH_WITH_MODIFIER="Patch with modifier"
  MSG_PATCHING_WITH_MODIFIER="Patching with modifier..."
  MSG_ERROR_MODIFIER_FAILED="Error: modifier failed"
  MSG_REPACKING="Repacking AppImage..."
  MSG_REPACK_FAILED="Failed to repack AppImage"
  MSG_REPACK_SUCCESS="AppImage repacked, overwrite"
  MSG_REMOVING_TEMP_DIR="Removed temporary directory"
  MSG_FOUND_APPIMAGE="Found AppImage:"
  MSG_COPYING_APPIMAGE="Copying AppImage to current directory..."
  MSG_FAILED_UNPACK="Failed to unpack AppImage"
  MSG_APPIMAGETOOL_NOT_FOUND="appimagetool not found"
  MSG_DOWNLOAD_PROMPT="Download appimagetool? (Y/n):"
  MSG_DOWNLOADING="Downloading appimagetool..."
  MSG_DOWNLOAD_FAILED="Download failed. You can manually download and save it to"
  MSG_DOWNLOAD_LINK="Link:"
  MSG_APPIMAGETOOL_DOWNLOADED="Appimagetool downloaded"
  MSG_MANUAL_DOWNLOAD="Please download appimagetool and put it to"
  MSG_TO_CONTINUE="to continue"
  MSG_WGET_CURL_NOT_FOUND="Error: Neither wget nor curl is installed. Please install one of them first."
  MSG_RESTORING_COMPLETE="Restoring complete!"
  MSG_PATCHING_COMPLETE="Patching complete!"
else
  MSG_ERROR_NOT_FOUND="错误：未找到 Cursor AppImage"
  MSG_ERROR_INVALID_MODE="错误：无效的模式。使用 'patch' 或 'restore'。"
  MSG_PATCHING="正在修补 Cursor AppImage..."
  MSG_RESTORING="正在恢复 Cursor AppImage..."
  MSG_UNPACKING="正在解压 AppImage..."
  MSG_UNPACKED_TO="AppImage 已解压 ->"
  MSG_PATCH_WITH_MODIFIER="使用 modifier 修补"
  MSG_PATCHING_WITH_MODIFIER="正在使用 modifier 修补..."
  MSG_ERROR_MODIFIER_FAILED="错误：modifier 执行失败"
  MSG_REPACKING="正在重新打包 AppImage..."
  MSG_REPACK_FAILED="重新打包 AppImage 失败"
  MSG_REPACK_SUCCESS="AppImage 已重新打包，覆盖"
  MSG_REMOVING_TEMP_DIR="已移除临时目录"
  MSG_FOUND_APPIMAGE="找到 AppImage："
  MSG_COPYING_APPIMAGE="正在复制 AppImage 到当前目录..."
  MSG_FAILED_UNPACK="解压 AppImage 失败"
  MSG_APPIMAGETOOL_NOT_FOUND="未找到 appimagetool"
  MSG_DOWNLOAD_PROMPT="下载 appimagetool？(Y/n)："
  MSG_DOWNLOADING="正在下载 appimagetool..."
  MSG_DOWNLOAD_FAILED="下载失败。您可以手动下载并保存到"
  MSG_DOWNLOAD_LINK="链接："
  MSG_APPIMAGETOOL_DOWNLOADED="appimagetool 已下载"
  MSG_MANUAL_DOWNLOAD="请下载 appimagetool 并将其放置到"
  MSG_TO_CONTINUE="以继续"
  MSG_WGET_CURL_NOT_FOUND="错误：未安装 wget 或 curl。请先安装其中一个。"
  MSG_RESTORING_COMPLETE="恢复完成！"
  MSG_PATCHING_COMPLETE="修补完成！"
fi

# 定义模式（patch 或 restore）
MODE="$1"

# 检查模式是否有效
if [ "$MODE" != "patch" ] && [ "$MODE" != "restore" ]; then
  echo "$MSG_ERROR_INVALID_MODE"
  exit 1
fi

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 定义 modifier 路径
MODIFIER_PATH="$SCRIPT_DIR/modifier"
# 检查 modifier 是否存在
if [ ! -f "$MODIFIER_PATH" ]; then
  echo "$MSG_ERROR_MODIFIER_NOT_FOUND $MODIFIER_PATH"
  exit 1
fi

# 定义appimage路径的函数
find_appimage() {
  local search_paths=(
    "/usr/local/bin"
    "/opt"
    "$HOME/Applications"
    "$HOME/.local/bin"
    "$HOME/Downloads"
    "$HOME/Desktop"
    "$HOME"
    "."
  )

  # 添加 $PATH 中的路径
  IFS=':' read -r -a path_dirs <<< "$PATH"
  for dir in "${path_dirs[@]}"; do
    search_paths+=("$dir")
  done

  for dir in "${search_paths[@]}"; do
    if [ ! -d "$dir" ]; then
      continue
    fi

    find "$dir" -maxdepth 1 -type f -iname "cursor*.AppImage" -print -quit 2> /dev/null
  done
}

# 下载文件的函数，支持 wget 和 curl
download_file() {
  local url="$1"
  local output_file="$2"

  if command -v wget &> /dev/null; then
    wget "$url" -O "$output_file"
    return $?
  elif command -v curl &> /dev/null; then
    curl -L "$url" -o "$output_file"
    return $?
  else
    echo "$MSG_WGET_CURL_NOT_FOUND"
    return 1
  fi
}

# 处理 AppImage 的函数
process_appimage() {
  local mode="$1"
  local message=""

  if [ "$mode" == "patch" ]; then
    message="$MSG_PATCHING"
  else
    message="$MSG_RESTORING"
  fi

  echo "$message"

  # 找到 AppImage 文件
  APPIMAGE_PATH=$(find_appimage)

  # 检查是否找到 AppImage 文件
  if [ -z "$APPIMAGE_PATH" ]; then
    echo "$MSG_ERROR_NOT_FOUND"
    exit 1
  fi

  echo "$MSG_FOUND_APPIMAGE $APPIMAGE_PATH"

  # 复制 AppImage 到当前目录（如果不在当前目录下）
  if [ "$(dirname "$APPIMAGE_PATH")" != "$SCRIPT_DIR" ]; then
    echo "$MSG_COPYING_APPIMAGE"
    cp -f "$APPIMAGE_PATH" "$SCRIPT_DIR"
    APPIMAGE_PATH="$SCRIPT_DIR/$(basename "$APPIMAGE_PATH")"
  fi

  # 添加可执行权限
  chmod +x "$APPIMAGE_PATH"

  # 解压 AppImage
  echo "$MSG_UNPACKING"
  "$APPIMAGE_PATH" --appimage-extract > /dev/null 2>&1

  # 检查是否解压成功
  if [ $? -ne 0 ]; then
    echo "$MSG_FAILED_UNPACK"
    exit 1
  fi

  echo "$MSG_UNPACKED_TO squashfs-root"

  # 使用 modifier 修补
  echo "$MSG_PATCHING_WITH_MODIFIER"
  "$MODIFIER_PATH" --cursor-path "squashfs-root/resources/app" --port 2999 --suffix .local local

  # 检查 modifier 是否成功执行
  if [ $? -ne 0 ]; then
    echo "$MSG_ERROR_MODIFIER_FAILED"
    exit 1
  fi

  # 重新打包
  # 定义 appimagetool 路径和下载过程中的临时文件名
  APPIMAGETOOL_PATH="$SCRIPT_DIR/appimagetool"
  APPIMAGETOOL_DOWNLOADING="$SCRIPT_DIR/appimagetool_downloading"

  # 如果 appimagetool 下载过程中的临时文件已存在，就删除它
  if [ -f "$APPIMAGETOOL_DOWNLOADING" ]; then
      rm -f "$APPIMAGETOOL_DOWNLOADING"
  fi

  # 如果 appimagetool 不存在，就尝试下载它
  if [ ! -f "$APPIMAGETOOL_PATH" ]; then
      echo "$MSG_APPIMAGETOOL_NOT_FOUND"
      read -p "$MSG_DOWNLOAD_PROMPT " -r DOWNLOAD
      DOWNLOAD=${DOWNLOAD,,} # 转换为小写

      if [[ ! "$DOWNLOAD" =~ ^(n|no)$ ]]; then
          echo "$MSG_DOWNLOADING"
          download_file "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" "$APPIMAGETOOL_DOWNLOADING"

          # 检查下载是否成功
          if [ $? -ne 0 ]; then
              echo "$MSG_DOWNLOAD_FAILED $APPIMAGETOOL_PATH"
              echo "$MSG_DOWNLOAD_LINK https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
              rm -f "$APPIMAGETOOL_DOWNLOADING"
              exit 1
          fi

          chmod +x "$APPIMAGETOOL_DOWNLOADING"
          mv "$APPIMAGETOOL_DOWNLOADING" "$APPIMAGETOOL_PATH"
          echo "$MSG_APPIMAGETOOL_DOWNLOADED"
      else
          echo "$MSG_MANUAL_DOWNLOAD $APPIMAGETOOL_PATH $MSG_TO_CONTINUE"
          echo "$MSG_DOWNLOAD_LINK https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
          exit 1
      fi
  fi

  echo "$MSG_REPACKING"
  "$APPIMAGETOOL_PATH" squashfs-root "$APPIMAGE_PATH"

  # 检查是否重新打包成功
  if [ $? -ne 0 ]; then
      echo "$MSG_REPACK_FAILED"
      exit 1
  fi

  echo "$MSG_REPACK_SUCCESS $APPIMAGE_PATH"

  # 删除解压后的临时目录
  rm -rf squashfs-root
  echo "$MSG_REMOVING_TEMP_DIR squashfs-root"

  if [ "$mode" == "patch" ]; then
    echo "$MSG_PATCHING_COMPLETE"
  else
    echo "$MSG_RESTORING_COMPLETE"
  fi
}

# 根据模式处理 AppImage
process_appimage "$MODE"

exit 0