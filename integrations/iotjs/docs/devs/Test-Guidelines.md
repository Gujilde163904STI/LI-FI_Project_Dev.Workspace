### To write a test case

Depend on the purpose of the test case (whether it's a positive or negative one), place it under `test/run*pass` or `test/run*fail` directory. The required external resources should be placed into `test/resources`.

All test case files must be named in the following form `test*<module name>[*<functionality].js` where `<module name>`
should match one of the JS modules name in the IoT.js. If there is a test case which can not tied to a
module (like some js features) then the `iotjs` name can be used as module name. It is important to
correctly specify the module name as the test executor relies on that information.

1. Write a test case and place it into the proper directory.
2. List up the test case in [test/testsets.json](https://github.com/jerryscript-project/iotjs/blob/master/test/testsets.json), and set attributes (timeout, skip, ...) on the test case if it needs.

#### Test set descriptor
* [`test/testsets.json`](https://github.com/jerryscript-project/iotjs/blob/master/test/testsets.json)

```
{
  "directory": [
    { "name": "filename",
      "skip": ["all"],
      "reason": "reason of skipping",
      "timeout": seconds,
      "expected-failure": true,
      "required-modules": ["my_module"],
      "required-features": ["es-262-feature"]
    },
    ...
  ],
  ...
}
```

 - *directory*: group of tests
 - *name*: filename = testname
 - *skip*: platform where the test must be skipped. ["all", "darwin", "linux", "nuttx", "tizen", "tizenrt"] **(optional)**
 - *reason*: it belongs to skip property, reason of skipping. **(optional)**
 - *timeout*: timeout in seconds **(optional)**
 - *expected-failure*: identifies the "must fail" testcases. Still catches segfaults, IOTJS*ASSERT and JERRY*ASSERT. Default: false [true, false]  **(optional)**


### How to Test

When you build ``iotjs`` binary successfully, you can run test runner with this binary.

```bash
tools/testrunner.py /path/to/iotjs
```

#### Set test options

Some basic options are provided.

Existing test options are listed as follows;
```
-h, --help           show this help message and exit
--quiet              show or hide the output of the tests
--skip-modules list  module list to skip test of specific modules
--testsets TESTSETS  JSON file to extend or override the default testsets
--timeout TIMEOUT    default timeout for the tests in seconds
--valgrind           check tests with Valgrind
--coverage           measure JavaScript coverage
```
