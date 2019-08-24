# [py4web](http://py4web.com)

[![Build Status](https://img.shields.io/travis/web2py/py4web/master.svg?style=flat-square&label=Travis-CI)](https://travis-ci.org/web2py/py4web)

## Try me (from pip)

```
python3 -m pip install py4web
py4web-start apps
open http://localhost:8000/todo/index
```

(The apps folder will be created with some apps inside)

## Try me (from source)

```
git clone https://github.com/web2py/py4web.git
cd py4web 
python3 -m pip install -r requirements.txt
./py4web-start apps
open http://localhost:8000/todo/index
```

Notice "py4web-start" uses the pip installed py4web, "./py4web-start" uses the local one. Do not get confused.

## Tell me more

- this is a work in progress and not stable yet but close to being stable
- python3 only
- uses https://github.com/web2py/pydal (same DAL as web2py)
- uses https://github.com/web2py/yatl (same as web2py but defaults to [[...]] instead of {{...}} delimiters)
- uses the same validators as web2py (they are in pyDAL)
- uses the very similar helpers to web2py (A, DIV, SPAN, etc.)
- uses https://github.com/web2py/pluralize for i18n and pluralization
- request, response, abort are from https://bottlepy.org
- HTTP and redirect are our own objects
- like web2py, it supports static asset management /{appname}/static/_0.0.0/{path}
- implements sessions in cookies (jwt encrypted), db, memcache, redis and custom
- implements a cache.memorize (Ram cache with O(1) access)
- supports multiple apps under apps folder (same as web2py)
- unlike web2py does not use a custom importer or eval
- admin has been replaced by a _dashboard (90% done)
- appadmin has been replaced by dbadmin (within dashboard) (90% done)
- auth logic is implemented via a "auth" vue.js custom component (90% done)
- SQLFORM has been replaced by py4web/utils/form.py
- SQLFORM.grid was been replaced by a "mtable" vue.js custom component (90% done)
- there are not enough tests
- it is not as stable as web2py yet
- it is 10-20x faster than web2py

## Components

- pydal + dbapi (done)
- yatl (done)
- pluralize (done)
- auth (WIP, 90%)
- mailer (done)
- session (cookies, db, redis, memcache)
- form (done up to downloads)
- mtable (WIP, 75%)
- dashboard (90% done)
- scaffold (done)
- bus (0%)
- tornado (done)
- gevent (done)
- gunicorn (done)
- bottle (done)

## Storing _dashboard password 

If you do not want to be prompted for a dashboard password every time:

1) create the password:

```
$ python3 -c "from pydal.validators import CRYPT; open('password.txt','w').write(str(CRYPT()(input('password:'))[0]))"
password: *****
```

2) (re)use it:

```
./py4web-start -p password.txt apps
```

## Launch Arguments

###     Apps Path
 Syntax | Default | Type
-------------|--------------|-------------
`<path to apps folder>` | ./apps | str

###     Host Name, Host Port
Switch | Syntax | Default | Type
-------------|-------------|--------------|-------------
 -a | `py4web-start-a ***<hostname>:<port>***` | 127.0.0.1:8000 | str
|||
 --address | `py4web-start --address ***<hostname>:<port>***` | 127.0.0.1:8000 | str

###     Worker Count
Switch | Syntax | Default | Type
-------|--------|---------|--------
 -n | `./py4web-start -n <number of gunicorn workers>` | 0 | int
|||
--number_workers | `./py4web-start --number_workers <number of gunicorn workers>` | 0 | int

###  SSL Certificate File Path 
Switch | Syntax | Default | Type
-------------|-------------|--------------|-------------
--ssl_cert_filename | `./py4web-start --ssl_cert_filename <ssl key file>` | None | int

###     SQL Logging Destination
Switch | Syntax | Default | Type
-------------|-------------|--------------|-------------
--service_db_uri | `./py4web-start --service_db_uri <db uri for logging>` | sqlite://service.storage | str

###     Dashboard Mode
Switch | Syntax | Default | Type
-------------|-------------|--------------|-------------
-d | `./py4web-start -d <demo, readonly, full, none>` | full | str
|||
--dashboard_mode | `./py4web-start --dashboard_mode <demo, readonly, full, none>` | full | str

###     Fix missing files
Switch | Syntax | Default | Type
-------------|-------------|--------------|-------------
-c | `./py4web-start -c <create missing file(s) or folder(s)>` | False | T/F
|||
--create | `./py4web-start --create <create missing file(s) or folder(s)>` | False | T/F

###     Use a Stored Password
Switch | Syntax | Default | Type
-------------|-------------|--------------|-------------
-p | `./py4web-start -p <your file containing the encrypted (CRYPT) password>` | None | str
|||
--password_file | `./py4web-start --password_file <your file containing the encrypted (CRYPT) password>` | None | str
