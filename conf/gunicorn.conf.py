command = "__FINALPATH__/venv/bin/gunicorn"
pythonpath = "__FINALPATH__"
pid = "/run/gunicorn/__APP__-pid"
user = "__APP__"
group = "__APP__"
bind = "127.0.0.1:__PORT__"
worker_class = "eventlet"
workers = __WORKERS__
raw_env = ["SCRIPT_NAME=__PATH__"]
errorlog = "/var/log/__APP__/error.log"
accesslog = "/var/log/__APP__/access.log"
access_log_format = '%({X-Real-IP}i)s %({X-Forwarded-For}i)s %(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'
loglevel = "warning"
capture_output = True
