# agl_services_ctlapp_sample

This code was developped during Yokohama CES-2019 integration workshop

## Native build

```bash
mkdir build && cd build
cmake ..
make
```

## Manual tests

```bash
# Native binder
afb-daemon --port=1111 --name=afb-ctlapp-sample --workdir=$HOME/xxxxx/agl-services-ctlapp-/build/package --ldpaths=lib --roothttp=htdocs --token= --verbose
```

```bash
curl -s http://localhost:1111/api/ctlapp/start?token=HELLO&name=navigation 


You can also use the basic html app
```
chromium http://localhost:1111
```
