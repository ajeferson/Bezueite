## Compiling and Running
```
gnatmake -o trabalhoada *.adb
gcc -c trabalhoada.adb
gnatbind -x trabalhoada.ali
gnatlink trabalhoada.ali -o trabalhoada
```
