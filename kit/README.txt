GT2 PC PORT - MOD KIT

1. Run setup-kit.bat (once; again any time). It downloads pez2k's GT2 tools into tools\ (pinned versions,
   SHA-256 checked), installs the GT2 Track Tools add-on into your Blender 4.2+ and checks for .NET 8.
   Everything it uses is listed in ..\THIRD-PARTY.md.
2. Follow the guides in ..\guides: 03-EXPORT, 04-BUILD-A-TRACK, 05-CARS, 06-COURSES-IN-MENUS, 07-EDIT-A-COURSE,
   08-CONSOLE-SAFE, 09-EXAMPLE-SPLICE.

samples\   track descriptions made for this kit (no game data):
           sample_track.json + .glb + .csv   a 2.9 km road course drawn as a Blender-style line
           oval_scenery.json                 an oval with grandstands, trees, lamps and sponsor boards
           climb.json                        a point-to-point hill climb
tools\     filled by setup-kit.bat (third-party tools; not part of this release)

The command-line tools are one folder up: ..\gt2-course.exe, ..\gt2-trackc.exe and ..\gt2-scenec.exe.
