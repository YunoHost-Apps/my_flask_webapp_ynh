This package allows you to install a custom Flask app from a git repository.  
It will setup for you some basic requirements for a flask app to run by reading some settings on your app yunohost configuration.

/!\\ This is still a work in progress, upgrade of this app itself has not really been tested /!\\

### Features

- Install and run your app with Gunicorn and a custom number of workers;
- Create a database (PostgreSQL, SQLite3 or none);
- Create a data directory in /home/yunohost.app/my_flask_webapp for your database dump, uploads, etc. ;
- Basic nginx configuration file but you can overwrite it by adding one in your app repo;
- Some editable settings (workers, max upload size, admin route)
- An experimental series of actions to run `git pull`, `pip install`, `npm ci`, `npm run build` and `flask db migrate`
- Expose a service in YunoHost that you can turn on and off with some basic logging;
- Create a permission for accessing the app;
- Kind of LDAP integration (env vars available);
