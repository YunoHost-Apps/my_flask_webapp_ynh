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
    ynh_add_config --template="gunicorn.conf.py" --destination="$final_path/gunicorn.conf.py"
    chmod 400 "$final_path/gunicorn.conf.py"
    chown $app:$app "$final_path/gunicorn.conf.py"
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
