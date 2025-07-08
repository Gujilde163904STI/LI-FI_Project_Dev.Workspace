## Adding a new SDK library

- Create a directory for the new SDK.
- Copy .a files from SDK `lib` directory to the new directory
- Add the new SDK directory to those supported in `eval*fix*sdks.sh` and `fix*sdk*libs.sh`.
- To support WPA2 Enterprise connections, some patches are  reguired review `wpa2*eap*patch.cpp` and `eval*fix*sdks.sh` for details.
- Use `./eval*fix*sdks.sh --analyze` to aid in finding relevant differences.
  - Also, you can compare two SDKs with something like `./eval*fix*sdks.sh --analyze "NONOSDK305\nNONOSDK306"`
- Apply updates to `fix*sdk*libs.sh` and `wpa2*eap*patch.cpp`. You can run `./eval*fix*sdks.sh --patch` to do a batch run of `fix*sdk*libs.sh` against each SDK.
- If you used this section, you can skip *Updating SDK libraries*.

## Updating SDK libraries

- Copy .a files from SDK `lib` directory to this directory
- Run `fix*sdk*libs.sh`


## Updating libstdc++

After building gcc using crosstool-NG, get compiled libstdc++ and remove some objects:

```bash
xtensa-lx106-elf-ar d libstdc++.a pure.o
xtensa-lx106-elf-ar d libstdc++.a vterminate.o
xtensa-lx106-elf-ar d libstdc++.a guard.o
xtensa-lx106-elf-ar d libstdc++.a functexcept.o
xtensa-lx106-elf-ar d libstdc++.a del_op.o
xtensa-lx106-elf-ar d libstdc++.a del_opv.o
xtensa-lx106-elf-ar d libstdc++.a new_op.o
xtensa-lx106-elf-ar d libstdc++.a new_opv.o
```
