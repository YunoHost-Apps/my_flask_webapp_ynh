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
ynh_get_arg () {
    arg=$(ynh_read_manifest "$final_path/ynh.json" $1)
    [[ "$arg" == "null" ]] && echo $2 || echo $arg
}

get_default_workers () {
    python3 -c "import multiprocessing; print(multiprocessing.cpu_count() * 2 + 1)"
}

add_env_config () {
    ynh_add_config --template="env" --destination="$final_path/.env"
    chmod 400 "$final_path/.env"
    chown $app:$app "$final_path/.env"
}

add_gunicorn_config () {
    script_name=$([ $path_url == "/" ] && echo "" || echo $path_url)
    ynh_add_config --template="gunicorn.conf.py" --destination="$final_path/gunicorn.conf.py"
    chmod 400 "$final_path/gunicorn.conf.py"
    chown $app:$app "$final_path/gunicorn.conf.py"
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
