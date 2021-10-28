#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="python3-venv python3-pip"
postgresql_dependencies="postgresql postgresql-server-dev-all"
sqlite_dependencies="sqlite3"

#=================================================
# PERSONAL HELPERS
#=================================================
get_default_workers () {
    python3 -c "import multiprocessing; print(multiprocessing.cpu_count() * 2 + 1)"
}

add_env_config () {
    ynh_add_config --template="env" --destination="$final_path/.env"
    chmod 400 "$final_path/.env"
    chown $app:$app "$final_path/.env"
}

add_gunicorn_config () {
    local script_name=$([[ $path_url == "/" ]] && echo "" || echo $path_url)
    ynh_add_config --template="gunicorn.conf.py" --destination="$final_path/gunicorn.conf.py"
    chmod 400 "$final_path/gunicorn.conf.py"
    chown $app:$app "$final_path/gunicorn.conf.py"
}

# equivalent of `ynh_add_nginx_config` with check if custom config in app repo
add_nginx_config () {
    local finalnginxconf="/etc/nginx/conf.d/$domain.d/$app.conf"
    local inputnginxconf=$([[ -f "$final_path/yunohost/nginx.conf" ]] && echo "$final_path/yunohost/nginx.conf" || echo "$YNH_APP_BASEDIR/conf/nginx.conf")

    if [ "${path_url:-}" != "/" ]; then
        ynh_replace_string --match_string="^#sub_path_only" --replace_string="" --target_file="$inputnginxconf"
    else
        ynh_replace_string --match_string="^#root_path_only" --replace_string="" --target_file="$inputnginxconf"
    fi


    ynh_add_config --template="$inputnginxconf" --destination="$finalnginxconf"

    # ynh_systemd_action --service_name=nginx --action=reload
}

service_action () {
  ynh_systemd_action --service_name=$app --action=$1 --log_path="/var/log/$app/$app.log"
}

get_json_setting () {
    arg=$(ynh_read_manifest "$final_path/yunohost/config.json" $1)
    [[ "$arg" == "null" ]] && echo $2 || echo $arg
}

get_set_json_setting () {
    local key=$1
    local default_value=$2
    local value=$(get_json_setting $key $default_value)
    ynh_app_setting_set --app=$app --key=$key --value=$value
    echo $value
}

exec_from_venv () {
    ynh_exec_as $app "$final_path/venv/bin/$@"
}

exec_flask () {
  pushd $final_path
  ynh_exec_as $app "venv/bin/flask" $@
  popd
}

install_dependencies () {
  extra_dependencies=""
  if [ $db_type == "postgresql" ]; then
    extra_dependencies=$postgresql_dependencies
  elif [ $db_type == "sqlite" ]; then
    extra_dependencies=$sqlite_dependencies
  fi

  ynh_install_app_dependencies $pkg_dependencies $extra_dependencies
}

install_pip_dependencies () {
  exec_from_venv pip install --upgrade pip
  exec_from_venv pip install -r "$final_path/requirements.txt"

  if [ $db_type = "postgresql" ]; then
    exec_from_venv pip install psycopg2
  fi
  # FIXME there is a bug with eventlet > 0.30.2 currently
  exec_from_venv pip install gunicorn eventlet==0.30.2
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

ynh_update_config_var () {
    # Declare an array to define the options of this helper.
    local legacy_args=fkva
    local -A args_array=( [f]=file= [k]=key= [v]=value= [a]=after=)
    local file
    local key
    local value
    local after
    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"
    after="${after:-}"

    ynh_backup_if_checksum_is_different --file=$file
    ynh_write_var_in_file --file=$file --key=$key --value="$value" --after="$after"
    ynh_store_file_checksum --file="$file" --update_only
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
