# My Flask Webapp pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/my_flask_webapp.svg)](https://dash.yunohost.org/appci/app/my_flask_webapp) ![](https://ci-apps.yunohost.org/ci/badges/my_flask_webapp.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/my_flask_webapp.maintain.svg)  
[![Installer My Flask Webapp avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=my_flask_webapp)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer My Flask Webapp rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

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


**Version incluse :** 0.1~ynh1



## Avertissements / informations importantes

### Currently known limitations

* Upgrade of this app itself has not really been tested;
* Apps will have names like `my_flask_webapp__1`;
* For some LDAP plugins .env LDAP vars might not be well formated;

## Documentations et ressources

* Documentation YunoHost pour cette app : https://yunohost.org/app_my_flask_webapp
* Signaler un bug : https://github.com/YunoHost-Apps/my_flask_webapp_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/my_flask_webapp_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/my_flask_webapp_ynh/tree/testing --debug
ou
sudo yunohost app upgrade my_flask_webapp -u https://github.com/YunoHost-Apps/my_flask_webapp_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps