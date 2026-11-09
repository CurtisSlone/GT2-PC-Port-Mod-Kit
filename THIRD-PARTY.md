# Third-party notices

Open-source libraries compiled into UGT2R and gt2-tools are listed with their licenses in `THIRD-PARTY-LICENSES.txt`.

## Inside the Linux AppImage

The first part of `UGT2R-x86_64.AppImage` is the AppImage type 2 runtime, the small program that starts the app. This
release uses the project's unmodified prebuilt runtime, release 20251108
(SHA-256 `2fca8b443c92510f1483a883f60061ad09b46b978b2631c807cd873a47ec260d`). It contains these, each under its own
license:

* AppImage type 2 runtime: https://github.com/AppImage/type2-runtime/blob/main/LICENSE
* musl libc: https://git.musl-libc.org/cgit/musl/tree/COPYRIGHT
* libfuse, under the GNU LGPL version 2.1: https://github.com/libfuse/libfuse/blob/master/LGPL2.txt
* squashfuse: https://github.com/vasi/squashfuse/blob/master/LICENSE
* libzstd: https://github.com/facebook/zstd/blob/dev/LICENSE
* zlib: https://zlib.net/zlib_license.html

Source code and build instructions for the runtime and how to get its parts:
https://github.com/AppImage/type2-runtime/tree/20251108 . You can replace the runtime in the AppImage with one you
built: extract the app with `--appimage-extract`, then pack the folder again with `appimagetool --runtime-file`.
