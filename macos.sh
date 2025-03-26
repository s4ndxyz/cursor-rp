#!/bin/bash

# 定义语言变量，默认为中文
LANG_CODE="${LANG_CODE:-zh}"

# 定义多语言消息
if [ "$LANG_CODE" == "en" ]; then
  MSG_BASE_PATH="Define base path"
  MSG_CHECK_CURSOR="Check if Cursor.app exists"
  MSG_ERROR_NOT_FOUND="Error: Cursor.app not found at"
  MSG_DEFINE_MODE="Define mode (patch or restore)"
  MSG_CHECK_MODE="Check if mode is valid"
  MSG_ERROR_INVALID_MODE="Error: Invalid mode. Use 'patch' or 'restore'."
  MSG_DEFINE_TMP="Define temporary path"
  MSG_GET_SCRIPT_DIR="Get script directory"
  MSG_DEFINE_MODIFIER="Define modifier path"
  MSG_CHECK_MODIFIER="Check if modifier exists"
  MSG_ERROR_MODIFIER_NOT_FOUND="Error: modifier not found at"
  MSG_PATCHING="Patching Cursor.app..."
  MSG_REMOVE_TMP="Remove .tmp if it exists"
  MSG_REMOVING_EXISTING="Removing existing"
  MSG_COPY_TO_TMP="Copy to .tmp"
  MSG_COPYING_TO="Copying to"
  MSG_REMOVE_SIGNATURE="Remove signature"
  MSG_REMOVING_SIGNATURE="Removing signature..."
  MSG_PATCH_WITH_MODIFIER="Patch with modifier"
  MSG_PATCHING_WITH_MODIFIER="Patching with modifier..."
  MSG_CHECK_MODIFIER_SUCCESS="Check if modifier executed successfully"
  MSG_ERROR_MODIFIER_FAILED="Error: modifier failed"
  MSG_SIGN="Sign"
  MSG_SIGNING="Signing..."
  MSG_PATCHING_COMPLETE="Patching complete!"
  MSG_RESTORING="Restoring Cursor.app..."
  MSG_DELETE_ORIGINAL="Delete original App Bundle"
  MSG_REMOVING_ORIGINAL="Removing original app..."
  MSG_MOVE_TMP="Move .tmp to original position"
  MSG_MOVING_TO_ORIGINAL="Moving to original position"
  MSG_RESTORING_COMPLETE="Restoring complete!"
else
  MSG_BASE_PATH="定义基础路径"
  MSG_CHECK_CURSOR="检查 Cursor.app 是否存在"
  MSG_ERROR_NOT_FOUND="错误：未找到 Cursor.app 在"
  MSG_DEFINE_MODE="定义模式（patch 或 restore）"
  MSG_CHECK_MODE="检查模式是否有效"
  MSG_ERROR_INVALID_MODE="错误：无效的模式。使用 'patch' 或 'restore'。"
  MSG_DEFINE_TMP="定义临时路径"
  MSG_GET_SCRIPT_DIR="获取脚本所在目录"
  MSG_DEFINE_MODIFIER="定义 modifier 路径"
  MSG_CHECK_MODIFIER="检查 modifier 是否存在"
  MSG_ERROR_MODIFIER_NOT_FOUND="错误：未找到 modifier 在"
  MSG_PATCHING="正在修补 Cursor.app..."
  MSG_REMOVE_TMP="如果存在 .tmp 就移除"
  MSG_REMOVING_EXISTING="正在移除已存在的"
  MSG_COPY_TO_TMP="复制到 .tmp"
  MSG_COPYING_TO="正在复制到"
  MSG_REMOVE_SIGNATURE="移除签名"
  MSG_REMOVING_SIGNATURE="正在移除签名..."
  MSG_PATCH_WITH_MODIFIER="使用 modifier 修补"
  MSG_PATCHING_WITH_MODIFIER="正在使用 modifier 修补..."
  MSG_CHECK_MODIFIER_SUCCESS="检查 modifier 是否成功执行"
  MSG_ERROR_MODIFIER_FAILED="错误：modifier 执行失败"
  MSG_SIGN="签名"
  MSG_SIGNING="正在签名..."
  MSG_PATCHING_COMPLETE="修补完成！"
  MSG_RESTORING="正在恢复 Cursor.app..."
  MSG_DELETE_ORIGINAL="删除原 App Bundle"
  MSG_REMOVING_ORIGINAL="正在移除原始应用..."
  MSG_MOVE_TMP="移动 .tmp 到原位置"
  MSG_MOVING_TO_ORIGINAL="正在移动到原始位置"
  MSG_RESTORING_COMPLETE="恢复完成！"
fi

# 定义基础路径
BASE_PATH="/Applications/Cursor.app"

# 检查 Cursor.app 是否存在
if [ ! -d "$BASE_PATH" ]; then
  echo "$MSG_ERROR_NOT_FOUND $BASE_PATH"
  exit 1
fi

# 定义模式（patch 或 restore）
MODE="$1"

# 检查模式是否有效
if [ "$MODE" != "patch" ] && [ "$MODE" != "restore" ]; then
  echo "$MSG_ERROR_INVALID_MODE"
  exit 1
fi

# 定义临时路径
TMP_PATH="$BASE_PATH.tmp"

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 定义 modifier 路径
MODIFIER_PATH="$SCRIPT_DIR/modifier"

# 检查 modifier 是否存在
if [ ! -f "$MODIFIER_PATH" ]; then
  echo "$MSG_ERROR_MODIFIER_NOT_FOUND $MODIFIER_PATH"
  exit 1
fi

if [ "$MODE" == "patch" ]; then
  echo "$MSG_PATCHING"

  # 如果存在 .tmp 就移除
  if [ -d "$TMP_PATH" ]; then
    echo "$MSG_REMOVING_EXISTING $TMP_PATH..."
    rm -rf "$TMP_PATH"
  fi

  # 复制到 .tmp
  echo "$MSG_COPYING_TO $TMP_PATH..."
  cp -a "$BASE_PATH" "$TMP_PATH"

  # 移除签名
  echo "$MSG_REMOVING_SIGNATURE"
  codesign --remove-signature "$TMP_PATH"

  # 使用 modifier 修补
  echo "$MSG_PATCHING_WITH_MODIFIER"
  "$MODIFIER_PATH" --cursor-path "$TMP_PATH/Contents/Resources/app" --port 2999 --suffix .local local

  # 检查 modifier 是否成功执行
  if [ $? -ne 0 ]; then
    echo "$MSG_ERROR_MODIFIER_FAILED"
    exit 1
  fi

  # 签名
  echo "$MSG_SIGNING"
  codesign --force --deep --sign - "$TMP_PATH"

  echo "$MSG_PATCHING_COMPLETE"

elif [ "$MODE" == "restore" ]; then
  echo "$MSG_RESTORING"

  # 删除原 App Bundle
  if [ -d "$BASE_PATH" ]; then
    echo "$MSG_REMOVING_ORIGINAL"
    rm -rf "$BASE_PATH"
  fi
  # 移动 .tmp 到原位置
  echo "$MSG_MOVING_TO_ORIGINAL"
  mv "$TMP_PATH" "$BASE_PATH"

  echo "$MSG_RESTORING_COMPLETE"
fi

exit 0