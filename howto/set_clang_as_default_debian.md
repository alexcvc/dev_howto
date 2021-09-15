# How set clang as default compiler instead gcc in debian

Use the following:

```
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100

sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

```
