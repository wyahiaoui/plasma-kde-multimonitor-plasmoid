
# Description 

This is a plasmoid to handle the widget with multiple monitor. It allows configuring and templating the widgets in the desktop according to the different settings 

# Dependencies 
    - libx11

# Install 
- `mkdir build && cd build`
- `cmake ../src/` (add -DCMAKE_INSTALL_PREFIX=$PWD/install if you don't want to install it)
- `source prefix.sh`
- `make -j$(nproc) && (sudo) make install`

