Yet Another Useless [Saturn] Library Installer
===

<p align="center">
  <img width="256" height="256" src=".images/yaul-installer.png">
</p>

## Installation

1. Download the _Yaul MSYS2 64-bit_ installer from the release [page][1].

2. Open the installer and click _Next_

![Step 2](/.images/step_01.png)

3. Select the installation path and click _Next_

![Step 3](/.images/step_02.png)

You must choose a path with no spaces. For example, `C:\John Doe\Projects\Yaul` will result in Yaul not working.

4. Name menu shortcuts and click _Next_

![Step 4](/.images/step_03.png)

5. Wait until installation is done

![Step 5](/.images/step_04.png)

6. Installation is done. Click _Next_

![Step 6](/.images/step_05.png)

7. Click _Finish_ to complete the installation

![Step 7](/.images/step_06.png)

8. All done! :tada:

![Step 8](/.images/step_07.png)

## Update Yaul

1. Open a terminal and type the following

       cd /opt/libyaul
       git pull

![Step 1](/.images/step_08.png)

2. Update the submodules

       git submodule update -f

![Step 2](/.images/step_09.png)

3. Clean and build the library

       make libyaul-clean-release
       SILENT=1 make libyaul-install-release

![Step 3](/.images/step_10.png)

4. Wait until build and installation is done

![Step 4](/.images/step_11.png)

5. All done building!

![Step 5](/.images/step_12.png)

6. Build `vdp1-balls` as a test

       cd /opt/libyaul/examples/vdp1-balls
       SILENT=1 make clean
       SILENT=1 make

![Step 6](/.images/step_13.png)

7. If you copied over a copy of the BIOS over to the correct paths, you can run Mednafen or Yabause

       mednafen vdp1-balls.cue

![Step 7](/.images/step_14.png)

8. Success! :tada:

![Step 8](/.images/step_15.png)
