Yet Another Useless [Saturn] Library Installer
===

<p align="center">
  <img width="256" height="256" src=".images/yaul-installer.png">
</p>

## Installation

1. Download the _Yaul MSYS2 64-bit_ installer from the release [page][1].

2. Open the installer and click _Next_

3. Select the installation path and click _Next_

You must choose a path with no spaces. For example, `C:\John Doe\Projects\Yaul`
will result in Yaul not working.

4. Name menu shortcuts and click _Next_

5. Wait until installation is done

6. Installation is done. Click _Next_

7. Click _Finish_ to complete the installation

8. All done! :tada:

## Update Yaul

1. Open a terminal (for example, `C:\yaul\mingw64.exe`) and type the following

```
cd /opt/libyaul
git pull
```

2. Update the submodules

```
git submodule update -f
```

3. Clean, build, and install the libraries and tools

```
make clean
SILENT=1 make install
```

4. Build `vdp1-balls` as a test

```
cd /opt/libyaul/examples/vdp1-balls
SILENT=1 make clean
SILENT=1 make
```

5. If you copied over a copy of the BIOS over to the correct paths, you can run
   Mednafen or Yabause

```
mednafen vdp1-balls.cue
```

6. Success! :tada:

<p align="center">
  <img src=".images/results.png" alt="Balls!">
</p>

## Installer development

### Requirements

Verify that the following packages are installed.

- `mingw-w64-x86_64-qt-installer-framework`

[1]: https://github.com/ijacquez/libyaul-installer/releases
