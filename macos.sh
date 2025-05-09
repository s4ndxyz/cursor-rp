#!/bin/bash
# vim: set fileencoding=utf-8 :
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# 基本配置变量
BASE_PATH="/Applications/Cursor.app"
DEBUG=false
LANG_CODE=""
MODIFIER_EXTRA_PARAMS=""
MODE=""
PORT="3000"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
SKIP_HOSTS=false
SUFFIX=".local"
TMP_PATH="${BASE_PATH}.tmp"
BACKUP_PATH="${BASE_PATH}.bk"

# 检测系统语言，优先判断中文
detect_system_lang() {
  local lang_var=${LANGUAGE:-${LC_ALL:-${LC_MESSAGES:-$LANG}}}
  local lang_code=$(echo "${lang_var}" | cut -d'_' -f1 | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]')

  if [[ "${lang_code}" == zh* ]]; then
    echo "zh"
  else
    echo "en"
  fi
}

# 调试输出函数，仅在DEBUG模式下输出信息
debug_print() {
  if $DEBUG; then
    echo "[DEBUG] $1"
  fi
}

# 显示帮助信息
show_help() {
  if [ "${LANG_CODE}" = "zh" ]; then
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  -h, --help          显示帮助信息"
    echo "  -l, --lang CODE       设置语言 (zh/en)"
    echo "  -p, --port <PORT>       指定端口号 (默认: 3000)"
    echo "  -s, --suffix <SUFFIX>     指定后缀 (默认: .local)"
    echo "  --skip-hosts        跳过 modifier 的 hosts 文件操作"
    echo "  --debug           启用调试输出"
    echo ""
    echo "注意: 脚本会自动检测是否需要恢复或修补"
  else
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help          Show this message"
    echo "  -l, --lang CODE       Set language (zh/en)"
    echo "  -p, --port <PORT>       Specify port number (default: 3000)"
    echo "  -s, --suffix <SUFFIX>     Specify suffix (default: .local)"
    echo "  --skip-hosts        Skip modify hosts file pass to modifier"
    echo "  --debug           Enable debug output"
    echo ""
    echo "Note: Script will automatically detect whether to restore or patch"
  fi
}

# 显示当前配置信息
show_info() {
  if [ "${LANG_CODE}" = "zh" ]; then
    echo "当前配置:"
    echo "  语言(Lang): ${LANG_CODE}"
    echo "  应用路径: ${BASE_PATH}"
    echo "  端口: ${PORT}"
    echo "  后缀: ${SUFFIX}"
    echo "  跳过hosts修改: $([ "${SKIP_HOSTS}" = "true" ] && echo "是" || echo "否")"
    echo "  临时路径: ${TMP_PATH}"
    echo "  备份路径: ${BACKUP_PATH}"
    if $DEBUG; then
      echo "  调试模式: 启用"
    fi
  else
    echo "Current Configuration:"
    echo "  Language: ${LANG_CODE}"
    echo "  App Path: ${BASE_PATH}"
    echo "  Port: ${PORT}"
    echo "  Suffix: ${SUFFIX}"
    echo "  Skip Hosts Modification: $([ "${SKIP_HOSTS}" = "true" ] && echo "Yes" || echo "No")"
    echo "  Temporary Path: ${TMP_PATH}"
    echo "  Backup Path: ${BACKUP_PATH}"
    if $DEBUG; then
      echo "  Debug Mode: Enabled"
    fi
  fi
  echo ""
}

# 初始化语言文本，按逻辑分组排序
init_lang() {
  if [ "${LANG_CODE}" = "zh" ]; then
    # 基本错误消息
    MSG_ERROR_NOT_FOUND="错误：未找到 Cursor.app 在"
    MSG_ERROR_INVALID_MODE="错误：无效的模式。使用 'patch' 或 'restore'。"
    MSG_ERROR_MODIFIER_NOT_FOUND="错误：未找到 modifier 在"
    MSG_ERROR_MODIFIER_FAILED="错误：modifier 执行失败"
    MSG_INVALID_PORT="错误：端口必须是有效的数字"

    # 备份与恢复相关消息
    MSG_BACKUP_EXISTS="发现备份文件，正在执行恢复操作..."
    MSG_BACKUP_CREATED="已创建应用备份到"
    MSG_NO_BACKUP="未发现备份文件，执行修补操作"
    MSG_RESTORING="正在恢复 Cursor.app..."
    MSG_DELETE_ORIGINAL="删除原应用"
    MSG_REMOVING_ORIGINAL="正在移除原始应用..."
    MSG_MOVE_BACKUP="移动备份到原位置"
    MSG_MOVING_TO_ORIGINAL="正在移动到原始位置"
    MSG_RESTORING_COMPLETE="恢复完成！"

    # 修补相关消息
    MSG_PATCHING="正在修补 Cursor.app..."
    MSG_REMOVE_TMP="如果存在临时文件就移除"
    MSG_REMOVING_EXISTING="正在移除已存在的"
    MSG_COPY_TO_TMP="复制到临时目录"
    MSG_COPYING_TO="正在复制到"
    MSG_REMOVE_SIGNATURE="移除签名"
    MSG_REMOVING_SIGNATURE="正在移除签名..."
    MSG_PATCH_WITH_MODIFIER="使用 modifier 修补"
    MSG_PATCHING_WITH_MODIFIER="正在使用 modifier 修补..."
    MSG_CHECK_MODIFIER_SUCCESS="检查 modifier 是否成功执行"
    MSG_SIGN="签名"
    MSG_SIGNING="正在签名..."
    MSG_PATCHING_COMPLETE="修补完成！"
    MSG_PROCESS_COMPLETE="处理完成！"
  else
    # Basic error messages
    MSG_ERROR_NOT_FOUND="Error: Cursor.app not found at"
    MSG_ERROR_INVALID_MODE="Error: Invalid mode. Use 'patch' or 'restore'."
    MSG_ERROR_MODIFIER_NOT_FOUND="Error: modifier not found at"
    MSG_ERROR_MODIFIER_FAILED="Error: modifier failed"
    MSG_INVALID_PORT="Error: Port must be a valid number"

    # Backup and restore messages
    MSG_BACKUP_EXISTS="Backup file found, performing restore operation..."
    MSG_BACKUP_CREATED="App backup created at"
    MSG_NO_BACKUP="No backup file found, performing patch operation"
    MSG_RESTORING="Restoring Cursor.app..."
    MSG_DELETE_ORIGINAL="Delete original App Bundle"
    MSG_REMOVING_ORIGINAL="Removing original app..."
    MSG_MOVE_BACKUP="Move backup to original position"
    MSG_MOVING_TO_ORIGINAL="Moving to original position"
    MSG_RESTORING_COMPLETE="Restoring complete!"

    # Patching messages
    MSG_PATCHING="Patching Cursor.app..."
    MSG_REMOVE_TMP="Remove temporary directory if it exists"
    MSG_REMOVING_EXISTING="Removing existing"
    MSG_COPY_TO_TMP="Copy to temporary directory"
    MSG_COPYING_TO="Copying to"
    MSG_REMOVE_SIGNATURE="Remove signature"
    MSG_REMOVING_SIGNATURE="Removing signature..."
    MSG_PATCH_WITH_MODIFIER="Patch with modifier"
    MSG_PATCHING_WITH_MODIFIER="Patching with modifier..."
    MSG_CHECK_MODIFIER_SUCCESS="Check if modifier executed successfully"
    MSG_SIGN="Sign"
    MSG_SIGNING="Signing..."
    MSG_PATCHING_COMPLETE="Patching complete!"
    MSG_PROCESS_COMPLETE="Process complete!"
  fi
}

# 解析命令行参数
parse_params() {
  options=$(getopt -o hl:p:s: --long help,lang:,port:,suffix:,skip-hosts,debug -n "$(basename "$0")" -- "$@")
  if [ $? -ne 0 ]; then
    echo "错误的选项" >&2
    exit 1
  fi

  eval set -- "$options"

  while true; do
    case "$1" in
      -h|--help)
        show_help
        exit 0
        ;;
      -l|--lang)
        LANG_CODE="$2"
        shift 2
        ;;
      -p|--port)
        PORT="$2"
        if ! [[ "${PORT}" =~ ^[0-9]+$ ]]; then
          echo "${MSG_INVALID_PORT}: ${PORT}"
          exit 1
        fi
        shift 2
        ;;
      -s|--suffix)
        SUFFIX="$2"
        shift 2
        ;;
      --skip-hosts)
        SKIP_HOSTS=true
        MODIFIER_EXTRA_PARAMS=" --skip-hosts"
        shift
        ;;
      --debug)
        DEBUG=true
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        show_help
        exit 1
        ;;
    esac
  done

  LANG_CODE=${LANG_CODE:-$(detect_system_lang)}
  init_lang

  # 检查 Cursor.app 是否存在
  if [ ! -d "${BASE_PATH}" ]; then
    echo "${MSG_ERROR_NOT_FOUND} ${BASE_PATH}"
    exit 1
  fi

  # 定义 modifier 路径
  MODIFIER_PATH="${SCRIPT_DIR}/modifier"

  # 检查 modifier 是否存在
  if [ ! -f "${MODIFIER_PATH}" ]; then
    echo "${MSG_ERROR_MODIFIER_NOT_FOUND} ${MODIFIER_PATH}"
    exit 1
  fi

  show_info
}

# 处理应用修补或恢复，自动检测模式
process_app() {
  # 自动检测模式：如果存在备份则恢复，否则进行修补
  if [ -d "${BACKUP_PATH}" ]; then
    echo "${MSG_BACKUP_EXISTS}"
    restore_app
  else
    echo "${MSG_NO_BACKUP}"
    patch_app
  fi
}

# 修补应用
patch_app() {
  echo "${MSG_PATCHING}"

  # 创建备份
  echo "${MSG_BACKUP_CREATED} ${BACKUP_PATH}"
  cp -a "${BASE_PATH}" "${BACKUP_PATH}"

  # 如果存在临时目录就移除
  if [ -d "${TMP_PATH}" ]; then
    echo "${MSG_REMOVING_EXISTING} ${TMP_PATH}..."
    rm -rf "${TMP_PATH}"
  fi

  # 复制到临时目录
  echo "${MSG_COPYING_TO} ${TMP_PATH}..."
  cp -a "${BASE_PATH}" "${TMP_PATH}"

  # 移除签名
  echo "${MSG_REMOVING_SIGNATURE}"
  codesign --remove-signature "${TMP_PATH}"

  # 使用 modifier 修补
  echo "${MSG_PATCHING_WITH_MODIFIER}"
  debug_print "执行命令: ${MODIFIER_PATH} --cursor-path ${TMP_PATH}/Contents/Resources/app --port ${PORT} --suffix ${SUFFIX} local${MODIFIER_EXTRA_PARAMS}"
  "${MODIFIER_PATH}" --cursor-path "${TMP_PATH}/Contents/Resources/app" --port "${PORT}" --suffix "${SUFFIX}" local${MODIFIER_EXTRA_PARAMS}

  # 检查 modifier 是否成功执行
  if [ $? -ne 0 ]; then
    echo "${MSG_ERROR_MODIFIER_FAILED}"
    exit 1
  fi

  # 签名
  echo "${MSG_SIGNING}"
  codesign --force --deep --sign - "${TMP_PATH}"

  # 替换原始应用
  echo "${MSG_REMOVING_ORIGINAL}"
  rm -rf "${BASE_PATH}"

  echo "${MSG_MOVING_TO_ORIGINAL}"
  mv "${TMP_PATH}" "${BASE_PATH}"

  echo "${MSG_PATCHING_COMPLETE}"
  echo "${MSG_PROCESS_COMPLETE}"
}

# 恢复应用
restore_app() {
  echo "${MSG_RESTORING}"

  # 删除原应用
  if [ -d "${BASE_PATH}" ]; then
    echo "${MSG_REMOVING_ORIGINAL}"
    rm -rf "${BASE_PATH}"
  fi

  # 移动备份到原位置
  echo "${MSG_MOVING_TO_ORIGINAL}"
  mv "${BACKUP_PATH}" "${BASE_PATH}"

  echo "${MSG_RESTORING_COMPLETE}"
  echo "${MSG_PROCESS_COMPLETE}"
}

# 主函数
main() {
  parse_params "$@"
  process_app
}

main "$@"
