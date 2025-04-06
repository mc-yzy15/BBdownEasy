#!/bin/bash
# BBdownEasy一键运行脚本 - 增强版

# 检查是否已安装
if [ ! -f "/opt/bbdowneasy/BBDown" ]; then
    echo "检测到未安装BBdownEasy，正在自动安装..."
    sudo ./bbdownInstall.sh || {
        echo "自动安装失败，请手动运行: sudo ./bbdownInstall.sh"
        exit 1
    }
fi

# 初始化变量
init_vars() {
    api_mode=""
    quality=""
    encoding=""
    danmaku=""
    cover=""
    info=""
    multithread="--multi-thread"
    save_path=""
    file_pattern=""
    multi_file_pattern=""
    select_page=""
    language=""
    user_agent=""
    cookie=""
    access_token=""
    aria2c_args=""
    ffmpeg_path=""
    mp4box_path=""
    aria2c_path=""
    upos_host=""
    force_replace_host=""
    save_archives=""
    delay_per_page=""
    config_file=""
    video_only=""
    audio_only=""
    danmaku_only=""
    sub_only=""
    cover_only=""
    debug=""
    skip_mux=""
    skip_subtitle=""
    skip_cover=""
    force_http=""
    skip_ai=""
    video_ascending=""
    audio_ascending=""
    allow_pcdn=""
}

# 主菜单
main_menu() {
    clear
    echo "===== BBDown 简易版 v1.6.3 ====="
    echo "1. 快速下载(默认参数)"
    echo "2. 高级下载(自定义参数)"
    echo "3. 账号登录管理"
    echo "4. 查看帮助文档"
    echo "5. 退出"
    echo
    read -p "请选择 [1-5]: " choice

    case $choice in
        1) quick_download ;;
        2) advanced_download ;;
        3) login_menu ;;
        4) show_help ;;
        5) exit 0 ;;
        *) main_menu ;;
    esac
}

# 快速下载模式
quick_download() {
    clear
    echo "=== 快速下载模式 ==="
    echo "提示：直接粘贴视频链接即可"
    echo
    read -p "请输入视频URL(输入q返回): " url
    
    if [ "$url" = "q" ]; then
        main_menu
    elif [ -z "$url" ]; then
        echo "URL不能为空"
        sleep 1
        quick_download
    fi

    echo "开始下载视频..."
    /opt/bbdowneasy/BBDown "$url" --download-danmaku --cover
    
    if [ $? -eq 0 ]; then
        echo "[成功] 下载完成"
    else
        echo "[错误] 下载失败，代码: $?"
    fi
    
    read -p "按任意键返回主菜单..." -n1
    main_menu
}

# 高级下载模式
advanced_download() {
    clear
    echo "=== 高级下载模式 ==="
    echo "提示：请按步骤设置参数，输入q返回菜单"
    echo
    
    read -p "请输入视频URL(必填): " url
    if [ "$url" = "q" ]; then
        main_menu
    elif [ -z "$url" ]; then
        echo "URL不能为空"
        sleep 1
        advanced_download
    fi
    
    # 初始化参数
    init_vars
    param_menu
}

# 参数菜单
param_menu() {
    clear
    echo "=== 当前参数设置 ==="
    echo "URL: $url"
    echo "API模式: ${api_mode:-默认}"
    echo "画质: ${quality:-自动选择最佳}"
    echo "编码优先级: ${encoding:-默认}"
    echo "弹幕: ${danmaku:-不下载}"
    echo "封面: ${cover:-不下载}"
    echo "视频信息: ${info:-不显示}"
    echo "多线程: ${multithread:-启用}"
    echo "保存路径: ${save_path:-默认}"
    echo "文件名格式: ${file_pattern:-默认}"
    echo "分P选择: ${select_page:-全部}"
    echo
    echo "===== 参数设置 ====="
    echo "1. 设置API模式"
    echo "2. 设置画质和编码"
    echo "3. 设置下载内容"
    echo "4. 设置保存路径"
    echo "5. 设置文件名格式"
    echo "6. 设置分P选择"
    echo "7. 设置高级选项"
    echo "8. 开始下载"
    echo "9. 返回主菜单"
    echo
    read -p "请选择 [1-9]: " param_choice

    case $param_choice in
        1) set_api ;;
        2) set_quality ;;
        3) set_content ;;
        4) set_path ;;
        5) set_filename ;;
        6) set_page ;;
        7) advanced_options ;;
        8) start_advanced_download ;;
        9) main_menu ;;
        *) param_menu ;;
    esac
}

# 设置API模式
set_api() {
    clear
    echo "=== 设置API模式 ==="
    echo "1. 默认模式"
    echo "2. TV模式 (--use-tv-api)"
    echo "3. APP模式 (--use-app-api)"
    echo "4. 国际版模式 (--use-intl-api)"
    echo "5. 使用MP4Box混流 (--use-mp4box)"
    echo
    read -p "请选择API模式 [1-5]: " api_choice
    
    case $api_choice in
        1) api_mode="" ;;
        2) api_mode="--use-tv-api" ;;
        3) api_mode="--use-app-api" ;;
        4) api_mode="--use-intl-api" ;;
        5) api_mode="--use-mp4box" ;;
        *) set_api ;;
    esac
    
    param_menu
}

# 设置画质和编码
set_quality() {
    clear
    echo "=== 设置画质 ==="
    echo "1. 自动选择最佳画质"
    echo "2. 交互式临时选择画质 (--interactive)"
    echo "3. 自定义画质优先级 (--dfn-priority)"
    echo "4. 自定义编码优先级 (--encoding-priority)"
    echo
    read -p "请选择 [1-4]: " quality_choice
    
    case $quality_choice in
        1) 
            quality=""
            encoding=""
            ;;
        2) 
            quality="--interactive"
            encoding=""
            ;;
        3)
            echo "请输入画质优先级，用逗号分隔 (例: \"8K 超高清,1080P 高码率,HDR 真彩\")"
            read -p "画质优先级: " dfn_priority
            quality="--dfn-priority \"$dfn_priority\""
            ;;
        4)
            echo "请输入编码优先级，用逗号分隔 (例: \"hevc,av1,avc\")"
            read -p "编码优先级: " encoding_priority
            encoding="--encoding-priority \"$encoding_priority\""
            ;;
        *) set_quality ;;
    esac
    
    param_menu
}

# 设置下载内容
set_content() {
    clear
    echo "=== 设置下载内容 ==="
    echo "1. 弹幕: ${danmaku:-不下载}"
    echo "2. 封面: ${cover:-不下载}"
    echo "3. 显示信息: ${info:-不显示}"
    echo "4. 多线程: ${multithread:-启用}"
    echo "5. 仅下载视频 (--video-only)"
    echo "6. 仅下载音频 (--audio-only)"
    echo "7. 仅下载弹幕 (--danmaku-only)"
    echo "8. 仅下载字幕 (--sub-only)"
    echo "9. 仅下载封面 (--cover-only)"
    echo
    read -p "请选择 [1-9]: " content_choice
    
    case $content_choice in
        1) 
            if [ "$danmaku" = "--download-danmaku" ]; then
                danmaku=""
            else
                danmaku="--download-danmaku"
            fi
            ;;
        2) 
            if [ "$cover" = "--cover" ]; then
                cover=""
            else
                cover="--cover"
            fi
            ;;
        3) 
            if [ "$info" = "--only-show-info" ]; then
                info=""
            else
                info="--only-show-info"
            fi
            ;;
        4) 
            if [ "$multithread" = "--multi-thread" ]; then
                multithread=""
            else
                multithread="--multi-thread"
            fi
            ;;
        5)
            video_only="--video-only"
            audio_only=""
            danmaku_only=""
            sub_only=""
            cover_only=""
            ;;
        6)
            audio_only="--audio-only"
            video_only=""
            danmaku_only=""
            sub_only=""
            cover_only=""
            ;;
        7)
            danmaku_only="--danmaku-only"
            video_only=""
            audio_only=""
            sub_only=""
            cover_only=""
            ;;
        8)
            sub_only="--sub-only"
            video_only=""
            audio_only=""
            danmaku_only=""
            cover_only=""
            ;;
        9)
            cover_only="--cover-only"
            video_only=""
            audio_only=""
            danmaku_only=""
            sub_only=""
            ;;
        *) set_content ;;
    esac
    
    param_menu
}

# 设置保存路径
set_path() {
    clear
    echo "=== 路径设置 ==="
    echo "当前路径: /opt/bbdowneasy/downloads"
    echo "请输入自定义路径(留空使用默认):"
    read custom_path
    
    if [ -n "$custom_path" ]; then
        save_path="--work-dir \"$custom_path\""
    else
        save_path=""
    fi
    
    param_menu
}

# 设置文件名格式
set_filename() {
    clear
    echo "=== 文件名格式设置 ==="
    echo "1. 单P文件名格式 (--file-pattern)"
    echo "2. 多P文件名格式 (--multi-file-pattern)"
    echo
    read -p "请选择 [1-2]: " filename_choice
    
    case $filename_choice in
        1)
            echo "请输入单P文件名格式 (可用变量: <videoTitle>, <pageNumber>等)"
            read -p "文件名格式: " pattern
            file_pattern="--file-pattern \"$pattern\""
            ;;
        2)
            echo "请输入多P文件名格式 (可用变量: <videoTitle>, <pageNumber>等)"
            read -p "文件名格式: " pattern
            multi_file_pattern="--multi-file-pattern \"$pattern\""
            ;;
        *) set_filename ;;
    esac
    
    param_menu
}

# 设置分P选择
set_page() {
    clear
    echo "=== 分P选择设置 ==="
    echo "1. 下载全部分P"
    echo "2. 选择特定分P (--select-page)"
    echo
    read -p "请选择 [1-2]: " page_choice
    
    case $page_choice in
        1)
            select_page=""
            ;;
        2)
            echo "请输入要下载的分P (例: 1 或 1,2 或 3-5 或 ALL 或 LAST)"
            read -p "分P选择: " page
            select_page="--select-page \"$page\""
            ;;
        *) set_page ;;
    esac
    
    param_menu
}

# 高级选项
advanced_options() {
    clear
    echo "=== 高级选项设置 ==="
    echo "1. 调试模式 (--debug)"
    echo "2. 跳过混流 (--skip-mux)"
    echo "3. 跳过字幕 (--skip-subtitle)"
    echo "4. 跳过封面 (--skip-cover)"
    echo "5. 强制HTTP (--force-http)"
    echo "6. 跳过AI字幕 (--skip-ai)"
    echo "7. 视频升序 (--video-ascending)"
    echo "8. 音频升序 (--audio-ascending)"
    echo "9. 允许PCDN (--allow-pcdn)"
    echo "10. 返回参数菜单"
    echo
    read -p "请选择 [1-10]: " advanced_choice
    
    case $advanced_choice in
        1)
            if [ "$debug" = "--debug" ]; then
                debug=""
            else
                debug="--debug"
            fi
            ;;
        2)
            if [ "$skip_mux" = "--skip-mux" ]; then
                skip_mux=""
            else
                skip_mux="--skip-mux"
            fi
            ;;
        3)
            if [ "$skip_subtitle" = "--skip-subtitle" ]; then
                skip_subtitle=""
            else
                skip_subtitle="--skip-subtitle"
            fi
            ;;
        4)
            if [ "$skip_cover" = "--skip-cover" ]; then
                skip_cover=""
            else
                skip_cover="--skip-cover"
            fi
            ;;
        5)
            if [ "$force_http" = "--force-http" ]; then
                force_http=""
            else
                force_http="--force-http"
            fi
            ;;
        6)
            if [ "$skip_ai" = "--skip-ai" ]; then
                skip_ai=""
            else
                skip_ai="--skip-ai"
            fi
            ;;
        7)
            if [ "$video_ascending" = "--video-ascending" ]; then
                video_ascending=""
            else
                video_ascending="--video-ascending"
            fi
            ;;
        8)
            if [ "$audio_ascending" = "--audio-ascending" ]; then
                audio_ascending=""
            else
                audio_ascending="--audio-ascending"
            fi
            ;;
        9)
            if [ "$allow_pcdn" = "--allow-pcdn" ]; then
                allow_pcdn=""
            else
                allow_pcdn="--allow-pcdn"
            fi
            ;;
        10)
            param_menu
            return
            ;;
        *) ;;
    esac
    
    advanced_options
}

# 开始高级下载
start_advanced_download() {
    clear
    echo "=== 下载参数确认 ==="
    echo "将使用以下参数进行下载:"
    echo "URL: $url"
    echo "API模式: ${api_mode:-默认}"
    echo "画质: ${quality:-自动选择最佳}"
    echo "编码: ${encoding:-默认}"
    echo "弹幕: ${danmaku:-不下载}"
    echo "封面: ${cover:-不下载}"
    echo "视频信息: ${info:-不显示}"
    echo "多线程: ${multithread:-启用}"
    echo "保存路径: ${save_path:-默认}"
    echo "文件名格式: ${file_pattern:-默认}"
    echo "分P选择: ${select_page:-全部}"
    echo "高级选项:"
    echo "  ${video_only}"
    echo "  ${audio_only}"
    echo "  ${danmaku_only}"
    echo "  ${sub_only}"
    echo "  ${cover_only}"
    echo "  ${debug}"
    echo "  ${skip_mux}"
    echo "  ${skip_subtitle}"
    echo "  ${skip_cover}"
    echo "  ${force_http}"
    echo "  ${skip_ai}"
    echo "  ${video_ascending}"
    echo "  ${audio_ascending}"
    echo "  ${allow_pcdn}"
    echo
    read -p "确认开始下载? [Y/n]: " confirm
    
    if [ "$confirm" = "n" ] || [ "$confirm" = "N" ]; then
        param_menu
    fi
    
    echo "开始下载..."
    eval /opt/bbdowneasy/BBDown "$url" $api_mode $quality $encoding $danmaku $cover $info $multithread $save_path \
        $file_pattern $multi_file_pattern $select_page $video_only $audio_only $danmaku_only $sub_only $cover_only \
        $debug $skip_mux $skip_subtitle $skip_cover $force_http $skip_ai $video_ascending $audio_ascending $allow_pcdn
    
    if [ $? -eq 0 ]; then
        echo "[成功] 下载完成"
    else
        echo "[错误] 下载失败，代码: $?"
    fi
    
    read -p "按任意键返回主菜单..." -n1
    main_menu
}

# 登录菜单
login_menu() {
    clear
    echo "=== 账号登录管理 ==="
    echo "1. WEB账号登录"
    echo "2. TV账号登录"
    echo "3. 返回主菜单"
    echo
    read -p "请选择登录方式 [1-3]: " login_choice
    
    case $login_choice in
        1) 
            /opt/bbdowneasy/BBDown login
            read -p "按任意键返回主菜单..." -n1
            main_menu
            ;;
        2) 
            /opt/bbdowneasy/BBDown logintv
            read -p "按任意键返回主菜单..." -n1
            main_menu
            ;;
        3) main_menu ;;
        *) login_menu ;;
    esac
}

# 显示帮助
show_help() {
    clear
    echo "=== BBDown 帮助文档 ==="
    echo "版本: 1.6.3"
    echo "Bilibili 视频/番剧下载工具"
    echo
    echo "常见问题与反馈:"
    echo "https://github.com/nilaoda/BBDown/issues"
    echo
    echo "按下q键返回主菜单..."
    
    case $login_choice in
        q) 
            main_menu
    esac
}