#!/usr/bin/bash
select_server() {
    servers=($(docker-compose config --services))
    echo "请选择服务："
    for i in "${!servers[@]}"; do
        echo "$i. ${servers[$i]}"
    done

    read -p "请输入序号： " choice

    # 检查用户输入的有效性
    if [[ $choice -ge 0 && $choice -lt ${#servers[@]} ]]; then
        selected_server=${servers[$choice]}
        return 0
    else
        echo "错误：请输入有效的序号。"
        return 1
    fi
}

execute_command() {
    select_server
    if [[ $? -eq 0 ]]; then
	# 自定义操作
	case $arg1 in
		log)
			docker-compose logs -f $selected_server
			;;
		exec)
			docker-compose  exec $selected_server bash
			;;
		restart)
			docker-compose restart $selected_server
			;;
	esac
    else
        echo "未能选择服务器，无法执行命令。"
    fi
}
arg1=$1
execute_command
