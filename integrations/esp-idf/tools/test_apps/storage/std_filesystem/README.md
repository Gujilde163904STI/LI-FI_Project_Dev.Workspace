| Supported Targets | ESP32 | ESP32-C3 |
| ----------------- | ----- | -------- |

This is a test app which verifies that std::filesystem features work in ESP-IDF. The tests are written using [Catch2](https://github.com/catchorg/Catch2) managed [component](https://components.espressif.com/components/espressif/catch2/).

To run the tests:

```shell
idf.py flash monitor
```

Or, in QEMU:

```shell
idf.py qemu monitor
```

Or, using pytest:

```shell
idf.py build
pytest --embedded-services idf,qemu --target esp32 --ignore managed_components
```

## Feature Support

Please update `*cplusplus*filesystem` section in cplusplus.rst when modifying this table.

| Feature                      | Supported | Tested | Comment                                                                                                       |
|------------------------------|-----------|--------|---------------------------------------------------------------------------------------------------------------|
| absolute                     | y         | y      |                                                                                                               |
| canonical                    | y         | y      |                                                                                                               |
| weakly_canonical             | y         | y      |                                                                                                               |
| relative                     | y         | y      |                                                                                                               |
| proximate                    | y         | y      |                                                                                                               |
| copy                         | y         | y      | this function has complex behavior, not sure about test coverage                                              |
| copy_file                    | y         | y      |                                                                                                               |
| copy_symlink                 | n         | n      | symlinks are not supported                                                                                    |
| create_directory             | y         | y      |                                                                                                               |
| create_directories           | y         | y      |                                                                                                               |
| create*hard*link             | n         | n      | hard links are not supported                                                                                  |
| create_symlink               | n         | n      | symlinks are not supported                                                                                    |
| create*directory*symlink     | n         | n      | symlinks are not supported                                                                                    |
| current_path                 | partial   | y      | setting path is not supported in IDF                                                                          |
| exists                       | y         | y      |                                                                                                               |
| equivalent                   | y         | y      |                                                                                                               |
| file_size                    | y         | y      |                                                                                                               |
| hard*link*count              | n         | n      | hard links are not supported                                                                                  |
| last*write*time              | y         | y      |                                                                                                               |
| permissions                  | partial   | y      | setting permissions is not supported                                                                          |
| read_symlink                 | n         | n      | symlinks are not supported                                                                                    |
| remove                       | y         | y      |                                                                                                               |
| remove_all                   | y         | y      |                                                                                                               |
| rename                       | y         | y      |                                                                                                               |
| resize*file                  | n         | y      | doesn't work, toolchain has to be built with *GLIBCXX*HAVE*TRUNCATE                                           |
| space                        | n         | y      | doesn't work, toolchain has to be built with *GLIBCXX*HAVE*SYS*STATVFS_H and statvfs function must be defined |
| status                       | y         | y      |                                                                                                               |
| symlink_status               | n         | n      | symlinks are not supported                                                                                    |
| temp*directory*path          | y         | y      | works if /tmp directory has been mounted                                                                      |
| directory_iterator           | y         | y      |                                                                                                               |
| recursive*directory*iterator | y         | y      |                                                                                                               |
| is*block*file                | y         | y      |                                                                                                               |
| is*character*file            | y         | y      |                                                                                                               |
| is_directory                 | y         | y      |                                                                                                               |
| is_empty                     | y         | y      |                                                                                                               |
| is_fifo                      | y         | y      |                                                                                                               |
| is_other                     | n         | n      |                                                                                                               |
| is*regular*file              | y         | y      |                                                                                                               |
| is_socket                    | y         | y      |                                                                                                               |
| is_symlink                   | y         | y      |                                                                                                               |
