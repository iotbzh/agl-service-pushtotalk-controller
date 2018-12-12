# agl_service_pushtotalk_controller

Push To Talk controller for CES 2019 demo. This controller subscribes/listens to HID button events. When events are received (driver or passenger
wants to talk), calls the corresponding verbs of microphone (to set direction) and voice recognition module (to start the audio analyse).

## Native build

```bash
mkdir build && cd build
cmake ..
make
```

## Manual tests

```bash
# Native binder
afb-daemon --port=2345 --name=afb-pushtotalk --token= -vvv
```

