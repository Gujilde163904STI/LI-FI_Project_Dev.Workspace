---
toc*max*heading_level: 4
sidebar_label: C/C++
title: C/C++ Client Library
slug: /tdengine-reference/client-libraries/cpp
---

C/C++ developers can use the TDengine client driver, i.e., the C/C++ connector (hereinafter referred to as the TDengine client driver), to develop their own applications to connect to the TDengine cluster for data storage, querying, and other functionalities. The API of the TDengine client driver is similar to MySQL's C API. When using the application, it is necessary to include the TDengine header file, which lists the function prototypes of the provided APIs; the application also needs to link to the corresponding dynamic library on the platform.  
TDengine's client driver provides two dynamic libraries, taosws and taos, which support WebSocket connections and native connections, respectively. The difference between WebSocket connections and native connections is that WebSocket connections do not require the client and server versions to completely match, while native connections do, and in terms of performance, WebSocket connections are also close to native connections. Generally, we recommend using WebSocket connections.

Below, we will introduce the usage methods of the two connection types separately.

## WebSocket Connection Method

The WebSocket connection method requires using the taosws.h header file and the taosws dynamic library.

```c
#include <taosws.h>
```

After installing the TDengine server or client, `taosws.h` is located at:

- Linux: `/usr/local/taos/include`
- Windows: `C:\TDengine\include`
- macOS: `/usr/local/include`

The dynamic library of the TDengine client driver is located at:

- Linux: `/usr/local/taos/driver/libtaosws.so`
- Windows: `C:\TDengine\driver\taosws.dll`
- macOS: `/usr/local/lib/libtaosws.dylib`

### Supported Platforms

Please refer to the [Supported Platforms List](../#supported-platforms)

### Version History

| TDengine Client Version |     Major Changes           |   TDengine Version    |
| ------------------ | --------------------------- | ---------------- |
|        3.3.3.0        | First release, providing comprehensive support for SQL execution, parameter binding, schema-less writing, and data subscription.    |       3.3.2.0 and higher    |

### Error Codes

In the design of the C interface, error codes are represented by integer types, each corresponding to a specific error state. Unless otherwise specified, when the API's return value is an integer, *0* represents success, and others represent failure reasons; when the return value is a pointer, *NULL* indicates failure.  
WebSocket connection method-specific error codes are in `taosws.h`,

| Error Code  | Error Description | Possible Error Scenarios or Reasons | Recommended User Actions |
| ------- | -------- | ---------------------------- | ------------------ |
| 0xE000  | DSN Error | DSN does not meet specifications             | Check if the DSN string meets specifications |
| 0xE001  | Internal Error | Uncertain                        | Preserve the scene and logs, report issue on GitHub |
| 0xE002  | Connection Closed | Network disconnected                      | Please check the network condition, review `taosadapter` logs. |
| 0xE003  | Send Timeout | Network disconnected                      | Please check the network condition |
| 0xE004  | Receive Timeout | Slow query, or network disconnected          | Investigate `taosadapter` logs |

For other error codes, please refer to the `taoserror.h` file in the same directory, and for a detailed explanation of native connection error codes, refer to: [Error Codes](../../error-codes/).
:::info
WebSocket connection method error codes only retain the last two bytes of the native connection error codes.
:::

### Example Program

This section shows example code for common access methods using the client driver to access the TDengine cluster.

- Synchronous query example: [Synchronous Query](https://github.com/taosdata/TDengine/tree/main/docs/examples/c-ws/query*data*demo.c)

- Parameter Binding Example: [Parameter Binding](https://github.com/taosdata/TDengine/tree/main/docs/examples/c-ws/stmt*insert*demo.c)

- Schema-less Insert Example: [Schema-less Insert](https://github.com/taosdata/TDengine/tree/main/docs/examples/c-ws/sml*insert*demo.c)

- Subscription and Consumption Example: [Subscription and Consumption](https://github.com/taosdata/TDengine/tree/main/docs/examples/c-ws/tmq_demo.c)

:::info
For more example codes and downloads, see [GitHub](https://github.com/taosdata/TDengine/tree/main/docs/examples/c-ws).
:::

### API Reference

The following sections describe the DSN, Basic API, Synchronous Query API, Parameter Binding API, Schema-less Writing API, and Data Subscription API of the TDengine client driver.

#### DSN

The C/C++ WebSocket connector uses a DSN (Data Source Name) connection description string to represent connection information.
The basic structure of a DSN description string is as follows:

```text
<driver>[+<protocol>]://[[<username>:<password>@]<host>:<port>][/<database>][?<p1>=<v1>[&<p2>=<v2>]]
|------|------------|---|-----------|-----------|------|------|------------|-----------------------|
|driver|   protocol |   | username  | password  | host | port |  database  |  params               |
```

The meanings of each part are as follows:

- **driver**: Must specify a driver name so the connector can choose how to create a connection, supported driver names include:
  - **taos**: Default driver, supports SQL execution, parameter binding, schema-less writing.
  - **tmq**: Use TMQ to subscribe to data.
- **protocol**: Explicitly specify how to establish a connection, for example: `taos+ws://localhost:6041` specifies establishing a connection via WebSocket.
  - **http/ws**: Use WebSocket protocol.
  - **https/wss**: Explicitly enable SSL/TLS protocol under WebSocket connection.

- **username/password**: Username and password used to create the connection.
- **host/port**: Specifies the server and port for creating the connection. If the server address and port are not specified, the default WebSocket connection is `localhost:6041`.
- **database**: Specifies the default database name to connect to, optional parameter.
- **params**: Other optional parameters.

A complete DSN description string example: `taos+ws://localhost:6041/test`, indicates using WebSocket (`ws`) to connect to the server `localhost` through port `6041`, specifying the default database as `test`.

#### Basic API

The Basic API is used to create database connections and other tasks, providing a runtime environment for the execution of other APIs.

- `char *ws*get*client_info()`
  - **Interface Description**: Get client version information.
  - **Return Value**: Returns client version information.

- `WS*TAOS *ws*connect(const char *dsn)`
  - **Interface Description**: Create a database connection, initialize the connection context.
  - **Parameter Description**:
    - dsn: [Input] Connection information, see the DSN section above.
  - **Return Value**: Returns the database connection, a null return value indicates failure. The application needs to save the returned parameter for subsequent use.
  :::info
  The same process can connect to multiple TDengine clusters based on different dsns
  :::

- `const char *ws*get*server*info(WS*TAOS *taos)`
  - **Interface Description**: Get server version information.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
  - **Return Value**: Returns the server version information.

- `int32*t ws*select*db(WS*TAOS *taos, const char *db)`
  - **Interface Description**: Sets the current default database to `db`.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - db: [Input] Database name.
  - **Return Value**: `0`: Success, non-`0`: Failure, please refer to the error code page.

- `int32*t ws*get*current*db(WS_TAOS *taos, char *database, int len, int *required)`
  - **Interface Description**: Gets the current database name.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - database: [Output] Stores the current database name.
    - len: [Input] The size of the space for the database.
    - required: [Output] Stores the space required for the current database name (including the final '\0').
  - **Return Value**: `0`: Success, `-1`: Failure, you can call the function ws_errstr(NULL) for more detailed error information.
    - If database == NULL or len \<= 0, return failure.
    - If len is less than the space required to store the database name (including the final '\0'), return failure, and the data in the database is truncated and ends with '\0'.
    - If len is greater than or equal to the space required to store the database name (including the final '\0'), return success, and the database name ends with '\0' in the database.

- `int32*t ws*close(WS_TAOS *taos);`
  - **Interface Description**: Closes the connection.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
  - **Return Value**: `0`: Success, non-`0`: Failure, please refer to the error code page.

#### Synchronous Queries

This section introduces APIs that are all synchronous interfaces. When called by the application, it will block and wait for a response until a result or error information is obtained.

- `WS*RES *ws*query(WS_TAOS *taos, const char *sql)`
  - **Interface Description**: Executes an SQL statement, which can be a DQL, DML, or DDL statement.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - sql: [Input] SQL statement to be executed.
  - **Return Value**: The result cannot be determined by whether the return value is `NULL`; instead, the `ws_errno()` function must be called to parse the error code in the result set.
    - ws_errno return value: `0`: Success, `-1`: Failure, details please call ws_errstr function for error hints.

- `int32*t ws*result*precision(const WS*RES *rs)`
  - **Interface Description**: Returns the precision category of the timestamp field in the result set.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: `0`: Milliseconds, `1`: Microseconds, `2`: Nanoseconds.

- `WS*ROW ws*fetch*row(WS*RES *rs)`
  - **Interface Description**: Retrieves data from the result set row by row.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: Non-`NULL`: Success, `NULL`: Failure, you can call the function ws_errstr(NULL) for more detailed error information.

- `int32*t ws*fetch*raw*block(WS*RES *rs, const void **pData, int32*t *numOfRows)`
  - **Interface Description**: Batch retrieves data from the result set.
  - **Parameter Description**:
    - res: [Input] Result set.
    - pData: [Output] Used to store a data block retrieved from the result set.
    - numOfRows: [Output] Used to store the number of rows included in the data block retrieved from the result set.
  - **Return Value**: `0`: Success, non-`0`: Failure, please refer to the error code page.

- `int32*t ws*num*fields(const WS*RES *rs)` and `int32*t ws*field*count(const WS*RES *rs)`
  - **Interface Description**: These two APIs are equivalent, used to get the number of columns in the result set.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: The return value is the number of columns in the result set.

- `int32*t ws*affected*rows(const WS*RES *rs)`
  - **Interface Description**: Get the number of rows affected by the executed SQL statement.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: The return value represents the number of affected rows.

- `int64*t ws*affected*rows64(const WS*RES *rs)`
  - **Interface Description**: Get the number of rows affected by the executed SQL statement.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: The return value represents the number of affected rows.

- `const struct WS*FIELD *ws*fetch*fields(WS*RES *rs)`
  - **Interface Description**: Get the attributes of each column in the query result set (column name, data type, column length), used in conjunction with `ws*num*fields()`, can be used to parse the tuple (row) of data returned by `ws*fetch*row()`.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a WS_FIELD structure, each element representing the metadata of a column. `NULL`: Failure.

- `int32*t ws*stop*query(WS*RES *rs)`
  - **Interface Description**: Stop the execution of the current query.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int32*t ws*free*result(WS*RES *rs)`
  - **Interface Description**: Release the query result set and related resources. After completing the query, it is imperative to call this API to release resources, otherwise, it may lead to memory leaks in the application. However, it should also be noted that if functions like `ws*fetch*fields()` are called to obtain query results after releasing resources, it will cause the application to crash.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `const char *ws*errstr(WS*RES *rs)`
  - **Interface Description**: Get the reason for the failure of the last API call, the return value is a string indicating the error message.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: String indicating the error message.

- `int32*t ws*errno(WS_RES *rs)`
  - **Interface Description**: Get the error code for the failure of the last API call.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: Error code.

:::note
TDengine recommends that each thread in a database application establish an independent connection or establish a connection pool based on the thread. Do not pass the connection (WS_TAOS*) structure in the application to different threads for shared use.
Another point to note is that during the execution of the above synchronous APIs, APIs like pthread_cancel should not be used to forcibly end the thread, as it involves some modules' synchronization operations, and forcibly ending the thread may cause exceptions including but not limited to deadlocks.

:::

#### Parameter Binding

In addition to directly calling `ws_query()` to write data by executing SQL, TDengine also provides a Prepare API that supports parameter binding, similar in style to MySQL, and currently only supports using the question mark `?` to represent parameters to be bound.

When writing data through the parameter binding interface, it can avoid the resource consumption of SQL syntax parsing, thereby significantly improving the writing performance in most cases. The typical operation steps at this time are as follows:

1. Call `ws*stmt*init()` to create a parameter binding object;
2. Call `ws*stmt*prepare()` to parse the INSERT statement;
3. If the INSERT statement reserves the table name but not the TAGS, then call `ws*stmt*set_tbname()` to set the table name;
4. If the INSERT statement reserves both the table name and TAGS (for example, the INSERT statement adopts the method of automatic table creation), then call `ws*stmt*set*tbname*tags()` to set the values of the table name and TAGS;
5. Call `ws*stmt*bind*param*batch()` to set the VALUES values in a multi-row manner;
6. Call `ws*stmt*add_batch()` to add the currently bound parameters to the batch processing;
7. Steps 3 to 6 can be repeated to add more data rows to the batch processing;
8. Call `ws*stmt*execute()` to execute the prepared batch command;
9. After execution, call `ws*stmt*close()` to release all resources.

Note: If `ws*stmt*execute()` is executed successfully and there is no need to change the SQL statement, the parsing result of `ws*stmt*prepare()` can be reused, and steps 3 to 6 can be directly performed to bind new data. However, if an error occurs during execution, it is not recommended to continue working in the current context. Instead, it is advisable to release resources and start over from the `ws*stmt*init()` step.

For related interfaces, refer to the specific functions below (you can also refer to the way these functions are used in the [stmt*insert*demo.c](https://github.com/taosdata/TDengine/blob/develop/docs/examples/c-ws/stmt*insert*demo.c) file):

- `WS*STMT *ws*stmt*init(const WS*TAOS *taos)`
  - **Interface Description**: Initializes a precompiled SQL statement object.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a WS*STMT structure representing the precompiled SQL statement object. `NULL`: Failure, please call the ws*stmt_errstr() function for error details.

- `int ws*stmt*prepare(WS_STMT *stmt, const char *sql, unsigned long len)`
  - **Interface Description**: Parses a precompiled SQL statement and binds the parsing results and parameter information to stmt.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - sql: [Input] SQL statement to be parsed.
    - len: [Input] Length of the sql parameter. If len is greater than 0, this parameter will be used as the length of the SQL statement; if it is 0, the length of the SQL statement will be automatically determined.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int ws*stmt*bind*param*batch(WS*STMT *stmt, const WS*MULTI*BIND *bind, uint32*t len)`
  - **Interface Description**: Passes the data to be bound in a multi-column manner, ensuring that the order and number of data columns passed here are completely consistent with the VALUES parameters in the SQL statement.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - bind: [Input] Pointer to a valid WS_MULTI_BIND structure, which contains the list of parameters to be batch bound to the SQL statement.
    - len: [Input] Number of elements in the bind array.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int ws*stmt*set*tbname(WS*STMT *stmt, const char *name)`
  - **Interface Description**: (Only supports replacing parameter values in INSERT statements) When the table name in the SQL statement uses a `?` placeholder, this function can be used to bind a specific table name.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - name: [Input] Pointer to a string constant containing the subtable name.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int ws*stmt*set*tbname*tags(WS_STMT *stmt,
                            const char *name,
                            const WS_MULTI_BIND *bind,
                            uint32_t len);`
  - **Interface Description**: (Only supports replacing parameter values in INSERT statements) When both the table name and TAGS in the SQL statement use a `?` placeholder, this function can be used to bind specific table names and specific TAGS values. The most typical scenario is the use of the auto-table creation feature in INSERT statements (the current version does not support specifying specific TAGS columns). The number of columns in the TAGS parameter must be completely consistent with the number of TAGS required by the SQL statement.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - name: [Input] Pointer to a string constant containing the subtable name.
    - tags: [Input] Pointer to a valid WS_MULTI_BIND structure, which contains the values of the subtable tags.
    - len: [Input] Number of elements in the bind array.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int ws*stmt*add*batch(WS*STMT *stmt)`
  - **Interface Description**: Adds the currently bound parameters to the batch. After calling this function, you can bind new parameters by calling `ws*stmt*bind*param*batch()` again. Note that this function only supports INSERT/IMPORT statements. If other SQL statements like SELECT are used, an error will be returned.
    - stmt: [Input] Points to a valid pointer of a precompiled SQL statement object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page.

- `int ws*stmt*execute(WS*STMT *stmt, int32*t *affected_rows)`
  - **Interface Description**: Executes the prepared statement. Currently, a statement can only be executed once.
    - stmt: [Input] Points to a valid pointer of a precompiled SQL statement object.
    - affected_rows: [Output] Number of rows successfully written.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page.

- `int ws*stmt*affected*rows(WS*STMT *stmt)`
  - **Interface Description**: Gets the number of rows affected after executing the precompiled SQL statement.
    - stmt: [Input] Points to a valid pointer of a precompiled SQL statement object.
  - **Return Value**: Returns the number of affected rows.

- `int ws*stmt*affected*rows*once(WS_STMT *stmt)`
  - **Interface Description**: Gets the number of rows affected by executing a bound statement once.
    - stmt: [Input] Points to a valid pointer of a precompiled SQL statement object.
  - **Return Value**: Returns the number of affected rows.

- `int32*t ws*stmt*close(WS*STMT *stmt)`
  - **Interface Description**: After execution, releases all resources.
    - stmt: [Input] Points to a valid pointer of a precompiled SQL statement object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page.

- `const char *ws*stmt*errstr(WS_STMT *stmt)`
  - **Interface Description**: Used to obtain error information when other STMT APIs return an error (return error code or null pointer).
    - stmt: [Input] Points to a valid pointer of a precompiled SQL statement object.
  - **Return Value**: Returns a pointer to a string containing error information.

#### Schemaless Writing

In addition to using SQL or parameter binding APIs to write data, you can also use Schemaless methods to write data. Schemaless allows you to write data without having to pre-create the structure of supertables/subtables. TDengine will automatically create and maintain the required table structure based on the data written. For more details on using Schemaless, see the [Schemaless Writing](../../../developer-guide/schemaless-ingestion/) section. Here, we introduce the accompanying C/C++ API.

- `WS*RES *ws*schemaless*insert*raw(WS_TAOS *taos,
                                 const char *lines,
                                 int len,
                                 int32_t *totalRows,
                                 int protocol,
                                 int precision)`
  - **Interface Description**: Performs a schemaless batch insertion operation, writing line protocol text data into TDengine. The data is represented by the pointer lines and its length len, to address issues where the original interface data is truncated due to containing '\0'.
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet parsing format requirements.
    - len: [Input] Total length (in bytes) of the data buffer lines.
    - totalRows: [Output] Points to an integer pointer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
  - **Return Value**: Returns a pointer to a WS*RES structure containing the results of the insertion operation. Applications can obtain error information using `ws*errstr()` or get the error code using `ws*errno()`. In some cases, the returned WS*RES may be `NULL`, in which case `ws_errno()` can still be safely called to obtain the error code.
  The returned WS_RES must be managed by the caller to avoid memory leaks.

**Description**
The protocol type is an enumeration type, including the following three formats:

- WS*TSDB*SML*LINE*PROTOCOL: InfluxDB Line Protocol
- WS*TSDB*SML*TELNET*PROTOCOL: OpenTSDB Telnet Text Line Protocol
- WS*TSDB*SML*JSON*PROTOCOL: OpenTSDB Json Protocol Format

The definition of timestamp resolution is defined in the `taosws.h` file, with details as follows:

- WS*TSDB*SML*TIMESTAMP*NOT_CONFIGURED = 0,
- WS*TSDB*SML*TIMESTAMP*HOURS,
- WS*TSDB*SML*TIMESTAMP*MINUTES,
- WS*TSDB*SML*TIMESTAMP*SECONDS,
- WS*TSDB*SML*TIMESTAMP*MILLI_SECONDS,
- WS*TSDB*SML*TIMESTAMP*MICRO_SECONDS,
- WS*TSDB*SML*TIMESTAMP*NANO_SECONDS

Note that the timestamp resolution parameter is only effective when the protocol type is `WS*SML*LINE_PROTOCOL`.
For the OpenTSDB text protocol, the parsing of timestamps follows its official parsing rules — determined by the number of characters contained in the timestamp.

Other related schemaless interfaces:

- `WS*RES *ws*schemaless*insert*raw*with*reqid(WS_TAOS *taos,
                                            const char *lines,
                                            int len,
                                            int32_t *totalRows,
                                            int protocol,
                                            int precision,
                                            uint64_t reqid)`
  - **Interface Description**: Performs a batch insert operation without a schema, writing text data in line protocol format into TDengine. Data is represented by the lines pointer and length len to address the issue of data being truncated due to containing '\0'. The reqid parameter is passed to track the entire function call chain.
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet the parsing format requirements.
    - len: [Input] Total length of the data buffer lines (in bytes).
    - totalRows: [Output] Pointer to an integer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Precision of the timestamps in the text data.
    - reqid: [Input] Specified request ID, used to track the call request. The request ID (reqid) can be used to establish a correlation between requests and responses on the client and server sides, which is very useful for tracking and debugging in distributed systems.
  - **Return Value**: Returns a pointer to a WS*RES structure containing the results of the insert operation. Applications can obtain error information using `ws*errstr()` or get the error code using `ws*errno()`. In some cases, the returned WS*RES may be `NULL`, in which case `ws_errno()` can still be safely called to obtain error code information.
  The returned WS_RES must be managed by the caller to prevent memory leaks.

- `WS*RES *ws*schemaless*insert*raw*ttl(WS*TAOS *taos,
                                     const char *lines,
                                     int len,
                                     int32_t *totalRows,
                                     int protocol,
                                     int precision,
                                     int ttl)`
  - **Interface Description**: Performs a batch insert operation without a schema, writing text data in line protocol format into TDengine. Data is represented by the lines pointer and length len to address the issue of data being truncated due to containing '\0'. The ttl parameter is passed to control the TTL expiration time for table creation.
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet the parsing format requirements.
    - len: [Input] Total length of the data buffer lines (in bytes).
    - totalRows: [Output] Pointer to an integer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Precision of the timestamps in the text data.
    - ttl: [Input] Specified lifespan (TTL), in days. Records will be automatically deleted after exceeding this lifespan.
  - **Return Value**: Returns a pointer to a WS*RES structure containing the results of the insert operation. Applications can obtain error information using `ws*errstr()` or get the error code using `ws*errno()`. In some cases, the returned WS*RES may be `NULL`, in which case `ws_errno()` can still be safely called to obtain error code information.
  The returned WS_RES must be managed by the caller to prevent memory leaks.

- `WS*RES *ws*schemaless*insert*raw*ttl*with*reqid(WS*TAOS *taos,
                                                const char *lines,
                                                int len,
                                                int32_t *totalRows,
                                                int protocol,
                                                int precision,
                                                int ttl,
                                                uint64_t reqid)`
  - **Interface Description**: Executes a batch insert operation without a schema, writing text data in line protocol to TDengine. Data is represented by the `lines` pointer and its length `len`, addressing the issue of data being truncated due to containing '\0'. The `ttl` parameter controls the TTL expiration time for table creation. The `reqid` parameter is used to track the entire function call chain.
    - taos: [Input] Pointer to the database connection, which is established through the `ws_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet parsing format requirements.
    - len: [Input] Total length of the data buffer `lines` (in bytes).
    - totalRows: [Output] Points to an integer pointer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
    - ttl: [Input] Specified Time to Live (TTL), in days. Records will be automatically deleted after exceeding this lifespan.
    - reqid: [Input] Specified request ID, used for tracking the call request. The request ID (`reqid`) can be used to establish a correlation between requests and responses on the client and server sides, which is very useful for tracking and debugging in distributed systems.
  - **Return Value**: Returns a pointer to a WS*RES structure containing the results of the insert operation. Errors can be obtained using `ws*errstr()`, and error codes using `ws*errno()`. In some cases, the returned WS*RES may be `NULL`, in which case `ws_errno()` can still be safely called to obtain error code information.
  The returned WS_RES must be freed by the caller to avoid memory leaks.

  **Notes**
  - The above three interfaces are extended interfaces, mainly used for passing `ttl` and `reqid` parameters during schemaless writes, and can be used as needed.
  - Interfaces with `ttl` can pass the `ttl` parameter to control the TTL expiration time for table creation.
  - Interfaces with `reqid` can track the entire call chain by passing the `reqid` parameter.

#### Data Subscription

- `const char *ws*tmq*errstr(ws*tmq*t *tmq)`
  - **Interface Description**: Used to obtain error information for data subscriptions.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, representing a TMQ consumer object.
  - **Return Value**: Returns a pointer to a string containing error information, the return value is non-NULL, but the error information may be an empty string.

- `ws*tmq*conf*t *ws*tmq*conf*new(void);`
  - **Interface Description**: Creates a new TMQ configuration object.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a ws*tmq*conf*t structure, which is used to configure the behavior and characteristics of TMQ. `NULL`: Failure, detailed error information can be obtained by calling `ws*errstr(NULL)`.

- `enum ws*tmq*conf*res*t ws*tmq*conf*set(ws*tmq*conf*t *conf, const char *key, const char *value)`
  - **Interface Description**: Sets configuration items in a TMQ configuration object, used to configure consumption parameters.
    - conf: [Input] Points to a valid ws_tmq_conf_t structure pointer, representing a TMQ configuration object.
    - key: [Input] Configuration item key name.
    - value: [Input] Configuration item value.
  - **Return Value**: Returns a ws*tmq*conf*res*t enumeration value, indicating the result of the configuration setting.
    - WS_TMQ_CONF_OK: Successfully set the configuration item.
    - WS_TMQ_CONF_INVALID_KEY: Invalid key value.
    - WS_TMQ_CONF_UNKNOWN: Invalid key name.

- `int32*t ws*tmq*conf*destroy(ws*tmq*conf_t *conf)`
  - **Interface Description**: Destroys a TMQ configuration object and releases related resources.
    - conf: [Input] A pointer to a valid ws_tmq_conf_t structure, representing a TMQ configuration object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(NULL)` for more detailed error information.

- `ws*tmq*list*t *ws*tmq*list*new(void)`
  - **Interface Description**: Used to create a ws*tmq*list_t structure for storing subscribed topics.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a ws*tmq*list*t structure. `NULL`: Failure, you can call the function `ws*tmq_errstr(NULL)` for more detailed error information.

- `int32*t ws*tmq*list*append(ws*tmq*list_t *list, const char *topic)`
  - **Interface Description**: Used to add a topic to a ws*tmq*list_t structure.
    - list: [Input] A pointer to a valid ws_tmq_list_t structure, representing a TMQ list object.
    - topic: [Input] Topic name.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(NULL)` for more detailed error information.

- `int32*t ws*tmq*list*destroy(ws*tmq*list_t *list);`
  - **Interface Description**: Used to destroy a ws*tmq*list*t structure, the result of ws*tmq*list*new needs to be destroyed through this interface.
    - list: [Input] A pointer to a valid ws_tmq_list_t structure, representing a TMQ list object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(NULL)` for more detailed error information.

- `int32*t ws*tmq*list*get*size(ws*tmq*list*t *list);`
  - **Interface Description**: Used to get the number of topics in a ws*tmq*list_t structure.
    - list: [Input] A pointer to a valid ws_tmq_list_t structure, representing a TMQ list object.
  - **Return Value**: `>=0`: Success, returns the number of topics in the ws*tmq*list_t structure. `-1`: Failure, indicates that the input parameter list is NULL.

- `char **ws*tmq*list*to*c_array(const ws*tmq*list*t *list, uint32*t *topic_num);`
  - **Interface Description**: Used to convert a ws*tmq*list_t structure into a C array, each element of the array is a string pointer.
    - list: [Input] A pointer to a valid ws_tmq_list_t structure, representing a TMQ list object.
    - topic_num: [Input] The number of elements in the list.
  - **Return Value**: Non-`NULL`: Successful, returns a C array, each element is a string pointer representing a topic name. `NULL`: Failure, indicates that the input parameter list is NULL.

- `ws*tmq*t *ws*tmq*consumer*new(ws*tmq*conf*t *conf, const char *dsn, char *errstr, int errstr_len)`
  - **Interface Description**: Used to create a ws*tmq*t structure for consuming data, after consuming data, call tmq*consumer*close to close the consumer.
    - conf: [Input] A pointer to a valid ws_tmq_conf_t structure, representing a TMQ configuration object.
    - dsn: [Input] DSN information string, for details refer to the DSN section above. A common valid dsn is "tmq+ws://root:taosdata@localhost:6041".
    - errstr: [Output] A pointer to a valid character buffer, used to receive possible error information during creation. Memory allocation/release is the responsibility of the caller.
    - errstrLen: [Input] Specifies the size of the errstr buffer (in bytes).
  - **Return Value**: Non-`NULL`: Successful, returns a pointer to a ws*tmq*t structure, representing a TMQ consumer object. `NULL`: Failure, error information stored in the errstr parameter.

- `int32*t ws*tmq*subscribe(ws*tmq*t *tmq, const ws*tmq*list*t *topic_list)`
  - **Interface Description**: Used to subscribe to a list of topics. After consuming the data, you need to call ws*tmq*subscribe to unsubscribe.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, which represents a TMQ consumer object.
    - topic_list: [Input] Points to a valid ws_tmq_list_t structure pointer, which contains one or more topic names, currently only supports one topic name.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(tmq)` to get more detailed error information.
  
- `int32*t ws*tmq*unsubscribe(ws*tmq_t *tmq)`
  - **Interface Description**: Used to unsubscribe from the list of topics. Must be used in conjunction with ws*tmq*subscribe.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, which represents a TMQ consumer object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(tmq)` to get more detailed error information.

- `WS*RES *ws*tmq*consumer*poll(ws*tmq*t *tmq, int64_t timeout)`
  - **Interface Description**: Used for polling to consume data. Each consumer can only call this interface in a single thread.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, which represents a TMQ consumer object.
    - timeout: [Input] Polling timeout in milliseconds, a negative number indicates a default timeout of 1 second.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a WS*RES structure, which contains the received message. `NULL`: indicates no data, the error code can be obtained through ws*errno (NULL), please refer to the reference manual for specific error message. WS*RES results are consistent with taos*query results, and information in WS_RES can be obtained through various query interfaces, such as schema, etc.
- `int32*t ws*tmq*consumer*close(ws*tmq*t *tmq)`
  - **Interface Description**: Used to close the ws*tmq*t structure. Must be used in conjunction with ws*tmq*consumer_new.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, which represents a TMQ consumer object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(tmq)` to get more detailed error information.

- `int32*t ws*tmq*get*topic*assignment(ws*tmq_t *tmq,
                                    const char *pTopicName,
                                    struct ws_tmq_topic_assignment **assignment,
                                    int32_t *numOfAssignment)`
  - **Interface Description**: Returns the information of the vgroup currently assigned to the consumer, including vgId, the maximum and minimum offset of wal, and the current consumed offset.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, which represents a TMQ consumer object.
    - pTopicName: [Input] The topic name for which to query the assignment information.
    - assignment: [Output] Points to a pointer to a tmq_topic_assignment structure, used to receive assignment information. The data size is numOfAssignment, and it needs to be released through the tmq_free_assignment interface.
    - numOfAssignment: [Output] Points to an integer pointer, used to receive the number of valid vgroups assigned to the consumer.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(tmq)` to get more detailed error information.

- `int32*t ws*tmq*free*assignment(struct ws*tmq*topic*assignment *pAssignment, int32*t numOfAssignment)`
  - **Interface Description**: Returns the information of the vgroup currently assigned to the consumer, including vgId, the maximum and minimum offset of wal, and the current consumed offset.
    - pAssignment: [Input] Points to a valid ws_tmq_topic_assignment structure array pointer, which contains the vgroup assignment information.
    - numOfAssignment: [Input] The number of elements in the array pointed to by pAssignment.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `ws*tmq*errstr(tmq)` to get more detailed error information.

- `int64*t ws*tmq*committed(ws*tmq*t *tmq, const char *pTopicName, int32*t vgId)`
  - **Interface Description**: Gets the committed offset for a specific topic and vgroup for the TMQ consumer object.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The topic name for which the committed offset is queried.
    - vgId: [Input] The ID of the vgroup.
  - **Return Value**: `>=0`: Success, returns an int64*t value representing the committed offset. `<0`: Failure, the return value is the error code, you can call the function `ws*tmq_errstr(tmq)` for more detailed error information.

- `int32*t ws*tmq*commit*sync(ws*tmq*t *tmq, const WS_RES *rs)`
  - **Interface Description**: Synchronously commits the message offset processed by the TMQ consumer object.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, representing a TMQ consumer object.
    - rs: [Input] Points to a valid WS_RES structure pointer, containing the processed messages. If NULL, commits the current progress of all vgroups consumed by the current consumer.
  - **Return Value**: `0`: Success, the offset has been successfully committed. Non `0`: Failure, you can call the function `ws*tmq*errstr(tmq)` for more detailed error information.

- `int32*t ws*tmq*commit*offset*sync(ws*tmq_t *tmq,
                                  const char *pTopicName,
                                  int32_t vgId,
                                  int64_t offset)`
  - **Interface Description**: Synchronously commits the offset for a specific topic and vgroup for the TMQ consumer object.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The topic name for which the offset is to be committed.
    - vgId: [Input] The ID of the virtual group vgroup.
    - offset: [Input] The offset to be committed.
  - **Return Value**: `0`: Success, the offset has been successfully committed. Non `0`: Failure, you can call the function `ws*tmq*errstr(tmq)` for more detailed error information.

- `int64*t ws*tmq*position(ws*tmq*t *tmq, const char *pTopicName, int32*t vgId)`
  - **Interface Description**: Gets the current consumption position, i.e., the next position of the data that has been consumed.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The topic name for which the current position is queried.
    - vgId: [Input] The ID of the virtual group vgroup.
  - **Return Value**: `>=0`: Success, returns an int64*t value representing the current position's offset. `<0`: Failure, the return value is the error code, you can call the function `ws*tmq_errstr(tmq)` for more detailed error information.

- `int32*t ws*tmq*offset*seek(ws*tmq*t *tmq, const char *pTopicName, int32*t vgId, int64*t offset)`
  - **Interface Description**: Sets the offset for a specific topic and vgroup for the TMQ consumer object to a specified position.
    - tmq: [Input] Points to a valid ws_tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The topic name for which the current position is queried.
    - vgId: [Input] The ID of the virtual group vgroup.
    - offset: [Input] The offset to be set.
  - **Return Value**: `0`: Success, non `0`: Failure, you can call the function `ws*tmq*errstr(tmq)` for more detailed error information.

- `int64*t ws*tmq*get*vgroup*offset(const WS*RES *rs)`
  - **Interface Description**: Extracts the current consumption data position's offset for the virtual group (vgroup) from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid WS_RES structure pointer, containing messages polled from the TMQ consumer.
  - **Return Value**: `>=0`: Success, returns an int64*t value representing the current consumption position's offset. `<0`: Failure, the return value is the error code, you can call the function `ws*tmq_errstr(tmq)` for more detailed error information.

- `int32*t ws*tmq*get*vgroup*id(const WS*RES *rs)`
  - **Interface Description**: Extracts the ID of the virtual group (vgroup) from the message result obtained by the TMQ consumer.
    - res: [Input] Points to a valid WS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: `>=0`: Success, returns an int32*t type value representing the ID of the virtual group (vgroup). `<0`: Failure, the return value is the error code, you can call the function `ws*tmq_errstr(tmq)` for more detailed error information.

- `const char *ws*tmq*get*table*name(const WS_RES *rs)`
  - **Interface Description**: Gets the table name from the message result obtained by the TMQ consumer.
    - res: [Input] Points to a valid WS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Non-`NULL`: Success, returns a const char * type pointer pointing to the table name string. `NULL`: Failure, invalid input parameters.

- `enum ws*tmq*res*t ws*tmq*get*res*type(const WS*RES *rs)`
  - **Interface Description**: Gets the message type from the message result obtained by the TMQ consumer.
    - res: [Input] Points to a valid WS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Returns a ws*tmq*res_t type enumeration value, representing the message type.
    - ws_tmq_res_t represents the type of data consumed, defined as follows:

  ```cpp
  typedef enum ws*tmq*res_t {
    WS_TMQ_RES_INVALID = -1,   // Invalid
    WS_TMQ_RES_DATA = 1,       // Data type
    WS_TMQ_RES_TABLE_META = 2, // Metadata type
    WS_TMQ_RES_METADATA = 3    // Both metadata and data types, i.e., automatic table creation
  } tmq*res*t;
  ```

- `const char *ws*tmq*get*topic*name(const WS_RES *rs)`
  - **Interface Description**: Gets the topic name from the message result obtained by the TMQ consumer.
    - res: [Input] Points to a valid WS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Non-`NULL`: Success, returns a const char * type pointer pointing to the topic name string. `NULL`: Failure, invalid input parameters.

- `const char *ws*tmq*get*db*name(const WS_RES *rs)`
  - **Interface Description**: Gets the database name from the message result obtained by the TMQ consumer.
    - res: [Input] Points to a valid WS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Non-`NULL`: Success, returns a const char * type pointer pointing to the database name string. `NULL`: Failure, invalid input parameters.

## Native Connection Method

The native connection method requires using the taos.h header file and the taos dynamic library.

```c
#include <taos.h>
```

After installing the TDengine server or client, `taos.h` is located at:

- Linux: `/usr/local/taos/include`
- Windows: `C:\TDengine\include`
- macOS: `/usr/local/include`

The dynamic library of the TDengine client driver is located at:

- Linux: `/usr/local/taos/driver/libtaos.so`
- Windows: `C:\TDengine\driver\taos.dll`
- macOS: `/usr/local/lib/libtaos.dylib`

### Supported Platforms

Please refer to the [list of supported platforms](../#supported-platforms)

### Supported Versions

The version number of the TDengine client driver corresponds strongly to the version number of the TDengine server. It is recommended to use the client driver that is exactly the same as the TDengine server. Although a lower version of the client driver can be compatible with a higher version of the server if the first three segments of the version number match (only the fourth segment is different), this is not recommended. It is strongly advised against using a higher version of the client driver to access a lower version of the server.

### Error Codes

In the design of the C interface, error codes are represented by integer types, with each error code corresponding to a specific error state. Unless otherwise specified, when the return value of an API is an integer, *0* represents success, and other values represent error codes indicating failure reasons. When the return value is a pointer, *NULL* indicates failure.  
All error codes and their corresponding descriptions are listed in the `taoserror.h` file.  
For detailed explanations of error codes, refer to: [Error Codes](../../error-codes/)  

### Example Programs

This section showcases example code for common access methods to the TDengine cluster using the client driver.

- Synchronous query example: [Synchronous Query](https://github.com/taosdata/TDengine/tree/main/docs/examples/c/demo.c)

- Asynchronous query example: [Asynchronous Query](https://github.com/taosdata/TDengine/tree/main/docs/examples/c/asyncdemo.c)

- Parameter binding example: [Parameter Binding](https://github.com/taosdata/TDengine/tree/main/docs/examples/c/prepare.c)

- Schemaless write example: [Schemaless Write](https://github.com/taosdata/TDengine/tree/main/docs/examples/c/schemaless.c)

- Subscription and consumption example: [Subscription and Consumption](https://github.com/taosdata/TDengine/tree/main/docs/examples/c/tmq.c)

:::info
For more example codes and downloads, please visit [GitHub](https://github.com/taosdata/TDengine/tree/main/docs/examples/c).
You can also find them in the `examples/c` directory of the installation path. There is a makefile in this directory, and you can compile the executable files directly by executing make in a Linux/macOS environment.
**Note:** When compiling in an ARM environment, please remove `-msse4.2` from the makefile, as this option is only supported on x64/x86 hardware platforms.

:::

### API Reference

The following sections introduce the basic API, synchronous API, asynchronous API, parameter binding API, schemaless write API, and data subscription API of the TDengine client driver.

#### Basic API

The basic API is used to establish database connections and provide a runtime environment for other APIs.

- `int taos_init()`
  - **Interface Description**: Initializes the runtime environment. If this API is not actively called, the driver will automatically call it when `taos_connect()` is invoked, so it is generally not necessary to call it manually.
  - **Return Value**: `0`: Success, non-`0`: Failure, you can call the function taos_errstr(NULL) for more detailed error information.

- `void taos_cleanup()`
  - **Interface Description**: Cleans up the runtime environment, should be called before the application exits.

- `int taos*options(TSDB*OPTION option, const void * arg, ...)`
  - **Interface Description**: Sets client options, currently supports locale (`TSDB*OPTION*LOCALE`), character set (`TSDB*OPTION*CHARSET`), timezone (`TSDB*OPTION*TIMEZONE`), configuration file path (`TSDB*OPTION*CONFIGDIR`), and driver type (`TSDB*OPTION*DRIVER`). Locale, character set, and timezone default to the current settings of the operating system. The driver type can be either the native interface(`native`) or the WebSocket interface(`websocket`), with the default being `websocket`.
  - **Parameter Description**:
    - `option`: [Input] Setting item type.
    - `arg`: [Input] Setting item value.
  - **Return Value**: `0`: Success, `-1`: Failure.

- `int taos*options*connection(TAOS *taos, TSDB*OPTION*CONNECTION option, const void *arg, ...)`
  - **description**:Set each connection option on the client side. Currently, it supports character set setting(`TSDB*OPTION*CONNECTION*CHARSET`), time zone setting(`TSDB*OPTION*CONNECTION*TIMEZONE`), user IP setting(`TSDB*OPTION*CONNECTION*USER*IP`), and user APP setting(`TSDB*OPTION*CONNECTION*USER*APP`).
  - **input**:
    - `taos`: returned by taos_connect.
    - `option`: option name.
    - `arg`: option value.
  - **return**:
    - `0`: success.
    - `others`: fail.
  - **notice**:
    - The character set and time zone default to the current settings of the operating system, and Windows does not support connection level time zone settings.
    - When arg is NULL, it means resetting the option.
    - This interface is only valid for the current connection and will not affect other connections.
    - If the same parameter is called multiple times, the latter shall prevail and can be used as a modification method.
    - The option of TSDB_OPTION_CONNECTION_CLEAR is used to reset all connection options.
    - After resetting the time zone and character set, using the operating system settings, the user IP and user app will be reset to empty.
    - The values of the connection options are all string type, and the maximum value of the user app parameter is 23, which will be truncated if exceeded; Error reported when other parameters are illegal.
    - If time zone value can not be used to find a time zone file or can not be interpreted as a direct specification, UTC is used, which is the same as the operating system time zone rules. Please refer to the tzset function description for details. You can view the current time zone of the connection by sql:select timezone().
    - Time zones and character sets only work on the client side and do not affect related behaviors on the server side.
    - The time zone file uses the operating system time zone file and can be updated by oneself. If there is an error when setting the time zone, please check if the time zone file or path (mac:/var/db/timezone/zoneinfo, Linux:/var/share/zoneinfo) is correct.

- `char *taos*get*client_info()`
  - **Interface Description**: Gets client version information.
  - **Return Value**: Returns client version information.

- `TAOS *taos*connect(const char *ip, the char *user, the char *pass, the char *db, uint16*t port);`
  - **Interface Description**: Creates a database connection, initializes the connection context.
  - **Parameter Description**:
    - ip: [Input] FQDN of any node in the TDengine cluster.
    - user: [Input] Username.
    - pass: [Input] Password.
    - db: [Input] Database name, if not provided by the user, connection can still be established, and the user can create a new database through this connection. If a database name is provided, it indicates that the database has already been created by the user, and it will be used by default.
    - port: [Input] Port on which the taosd program listens.
  - **Return Value**: Returns the database connection, a null return value indicates failure. The application needs to save the returned parameter for subsequent use.
  :::info
  The same process can connect to multiple TDengine clusters based on different hosts/ports.
  :::

- `TAOS *taos*connect*auth(const char *host, const char *user, const char *auth, const char *db, uint16_t port)`
  - **Interface Description**: Same functionality as taos*connect. Except the pass parameter is replaced by auth, other parameters are the same as taos*connect.
  - **Parameter Description**:
    - ip: [Input] FQDN of any node in the TDengine cluster.
    - user: [Input] Username.
    - auth: [Input] Original password taken as 32-bit lowercase md5.
    - db: [Input] Database name, if not provided by the user, connection can still be established, and the user can create a new database through this connection. If a database name is provided, it indicates that the database has already been created, and it will be used by default.
    - port: [Input] Port listened by the taosd program.
  - **Return Value**: Returns the database connection, a null return value indicates failure. The application needs to save the returned parameter for subsequent use.

- `char *taos*get*server_info(TAOS *taos)`
  - **Interface Description**: Get server version information.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
  - **Return Value**: Returns the server version information.

- `int taos*select*db(TAOS *taos, const char *db)`
  - **Interface Description**: Sets the current default database to `db`.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - db: [Input] Database name.
  - **Return Value**: `0`: Success, non-`0`: Failure, refer to the error code page for details.

- `int taos*get*current_db(TAOS *taos, char *database, int len, int *required)`
  - **Interface Description**: Get the current database name.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - database: [Output] Stores the current database name.
    - len: [Input] Space size of the database.
    - required: [Output] Stores the space required for the current database name (including the final '\0').
  - **Return Value**: `0`: Success, `-1`: Failure, detailed error information can be obtained by calling the function taos_errstr(NULL).
    - If database == NULL or len \<= 0, returns failure.
    - If len is less than the space required to store the database name (including the final '\0'), returns failure, and the data in the database is truncated and ends with '\0'.
    - If len is greater than or equal to the space required to store the database name (including the final '\0'), returns success, and the database name ends with '\0' in the database.

- `int taos*set*notify_cb(TAOS *taos, __taos*notify*fn_t fp, void *param, int type)`
  - **Interface Description**: Set the event callback function.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - fp: [Input] Event callback function pointer. Function declaration: typedef void (*__taos_notify_fn_t)(void*param, void *ext, int type); where, param is the user-defined parameter, ext is the extension parameter (dependent on the event type, for TAOS_NOTIFY_PASSVER returns user password version), type is the event type.
    - param: [Input] User-defined parameter.
    - type: [Input] Event type. Range of values: 1) TAOS_NOTIFY_PASSVER: User password change.
  - **Return Value**: `0`: Success, `-1`: Failure, detailed error information can be obtained by calling the function taos_errstr(NULL).

- `void taos_close(TAOS *taos)`
  - **Interface Description**: Close connection.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.

#### Synchronous Queries

This section introduces APIs that are all synchronous interfaces. After being called by the application, they will block and wait for a response until a result or error message is received.

- `TAOS*RES* taos*query(TAOS *taos, const char *sql)`
  - **Interface Description**: Executes an SQL statement, which can be a DQL, DML, or DDL statement.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - sql: [Input] The SQL statement to execute.
  - **Return Value**: The execution result cannot be determined by whether the return value is `NULL`. Instead, the `taos_errno()` function must be called to parse the error code in the result set.
    - taos_errno return value: `0`: success, `-1`: failure, for details please call the taos_errstr function to get the error message.

- `int taos*result*precision(TAOS_RES *res)`
  - **Interface Description**: Returns the precision category of the timestamp field in the result set.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: `0`: millisecond, `1`: microsecond, `2`: nanosecond.

- `TAOS*ROW taos*fetch*row(TAOS*RES *res)`
  - **Interface Description**: Fetches data from the query result set row by row.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: Non-`NULL`: success, `NULL`: failure, you can call taos_errstr(NULL) for more detailed error information.

- `int taos*fetch*block(TAOS*RES *res, TAOS*ROW *rows)`
  - **Interface Description**: Batch fetches data from the query result set.
  - **Parameter Description**:
    - res: [Input] Result set.
    - rows: [Output] Used to store rows fetched from the result set.
  - **Return Value**: The return value is the number of rows fetched; if there are no more rows, it returns 0.

- `int taos*num*fields(TAOS*RES *res)` and `int taos*field*count(TAOS*RES *res)`
  - **Interface Description**: These two APIs are equivalent and are used to get the number of columns in the query result set.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: The return value is the number of columns in the result set.

- `int* taos*fetch*lengths(TAOS_RES *res)`
  - **Interface Description**: Gets the length of each field in the result set.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: The return value is an array, the length of which is the number of columns in the result set.

- `int taos*affected*rows(TAOS_RES *res)`
  - **Interface Description**: Gets the number of rows affected by the executed SQL statement.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: The return value indicates the number of affected rows.

- `TAOS*FIELD *taos*fetch*fields(TAOS*RES *res)`
  - **Interface Description**: Gets the attributes of each column's data in the query result set (column name, data type, length), used in conjunction with `taos*num*fields()` to parse the data of a tuple (a row) returned by `taos*fetch*row()`.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: Non-`NULL`: successful, returns a pointer to a TAOS_FIELD structure, each element representing the metadata of a column. `NULL`: failure.

- `TAOS*FIELD*E *taos*fetch*fields*e(TAOS*RES *res)`
  - **Interface Description**: Retrieves the attributes of each column in the query result set (column name, data type, column length). Used in conjunction with `taos*num*fields()`, it can be used to parse the data of a tuple (a row) returned by `taos*fetch*row()`. In addition to the basic information provided by TAOS*FIELD, TAOS*FIELD_E also includes `precision` and `scale` information for the data type.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a TAOS*FIELD*E structure, where each element represents the metadata of a column. `NULL`: Failure.

- `void taos*stop*query(TAOS_RES *res)`
  - **Interface Description**: Stops the execution of the current query.
  - **Parameter Description**:
    - res: [Input] Result set.

- `void taos*free*result(TAOS_RES *res)`
  - **Interface Description**: Frees the query result set and related resources. After completing the query, it is essential to call this API to release resources, otherwise, it may lead to memory leaks in the application. However, be aware that if you call `taos_consume()` or other functions to fetch query results after releasing resources, it will cause the application to crash.
  - **Parameter Description**:
    - res: [Input] Result set.

- `char *taos*errstr(TAOS*RES *res)`
  - **Interface Description**: Gets the reason for the failure of the most recent API call, returning a string indicating the error message.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: A string indicating the error message.

- `int taos*errno(TAOS*RES *res)`
  - **Interface Description**: Retrieves the error code of the last API call failure.
  - **Parameter Description**:
    - res: [Input] Result set.
  - **Return Value**: String indicating the error message.

:::note
From version 2.0, TDengine recommends that each thread in a database application establishes its own connection, or builds a connection pool based on the thread, rather than sharing the connection (TAOS*) structure across different threads in the application. Operations such as queries and writes based on the TAOS structure are thread-safe, but stateful statements like "USE statement" may interfere with each other across threads. Additionally, the C language connector can dynamically establish new database-oriented connections as needed (this process is invisible to users), and it is recommended to call `taos_close()` to close the connection only when the program is about to exit.
Another point to note is that during the execution of the aforementioned synchronous APIs, APIs like pthread_cancel should not be used to forcibly terminate threads, as this involves synchronization operations of some modules and may cause issues including but not limited to deadlocks.

:::

#### Asynchronous Queries

TDengine also offers higher-performance asynchronous APIs for data insertion and query operations. Under the same hardware and software conditions, the asynchronous API processes data insertions 2 to 4 times faster than the synchronous API. Asynchronous APIs use a non-blocking call method, returning immediately before a specific database operation is actually completed. The calling thread can then handle other tasks, thereby enhancing the overall application performance. Asynchronous APIs are particularly advantageous under conditions of severe network latency.

Asynchronous APIs require the application to provide corresponding callback functions, with parameters set as follows: the first two parameters are consistent, the third depends on the specific API. The first parameter, param, is provided by the application during the asynchronous API call for use in the callback to retrieve the context of the operation, depending on the implementation. The second parameter is the result set of the SQL operation; if null, such as in an insert operation, it means no records are returned; if not null, such as in a select operation, it means records are returned.

Asynchronous APIs are relatively demanding for users, who may choose to use them based on specific application scenarios. Below are two important asynchronous APIs:

- `void taos*query*a(TAOS *taos, const char *sql, void (*fp)(void *param, TAOS_RES *, int code), void *param);`
  - **Interface Description**: Asynchronously executes an SQL statement.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, established through the `taos_connect()` function.
    - sql: [Input] SQL statement to be executed.
    - fp: User-defined callback function, where the third parameter `code` indicates whether the operation was successful (`0` for success, negative for failure; call `taos_errstr()` to get the reason for failure). The application should mainly handle the second parameter `TAOS_RES *`, which is the result set returned by the query.
    - param: Parameter provided by the application for the callback.

- `void taos*fetch*rows*a(TAOS*RES *res, void (*fp)(void *param, TAOS_RES *, int numOfRows), void *param);`
  - **Interface Description**: Batch retrieves the result set of an asynchronous query, can only be used in conjunction with `taos*query*a()`.
  - **Parameter Description**:
    - res: Result set returned by the callback of `taos_query_a()`.
    - fp: Callback function. Its parameter `param` is a user-defined parameter structure passed to the callback function; `numOfRows` is the number of rows of data retrieved (not the function of the entire result set). In the callback function, the application can iterate forward through the batch records by calling `taos_fetch_row()`. After reading all the records in a block, the application needs to continue calling `taos_fetch_rows_a()` in the callback function to process the next batch of records until the returned number of rows `numOfRows` is zero (results are completely returned) or the number of rows is negative (query error).

TDengine's asynchronous APIs all use a non-blocking call mode. Applications can open multiple tables simultaneously with multiple threads and can perform queries or insertions on each opened table at the same time. It should be noted that **client applications must ensure that operations on the same table are completely serialized**, meaning that a second insertion or query operation cannot be performed on the same table until the first operation is completed (has not returned).

#### Parameter Binding

In addition to directly calling `taos_query()` for queries, TDengine also offers a Prepare API that supports parameter binding, similar in style to MySQL, currently only supporting the use of a question mark `?` to represent the parameter to be bound.

Starting from versions 2.1.1.0 and 2.1.2.0, TDengine has significantly improved the parameter binding interface support for data writing (INSERT) scenarios. This avoids the resource consumption of SQL syntax parsing when writing data through the parameter binding interface, thereby significantly improving writing performance in most cases. The typical operation steps are as follows:

1. Call `taos*stmt*init()` to create a parameter binding object;
2. Call `taos*stmt*prepare()` to parse the INSERT statement;
3. If the INSERT statement reserves a table name but no TAGS, then call `taos*stmt*set_tbname()` to set the table name;
4. If the INSERT statement reserves both a table name and TAGS (for example, the INSERT statement adopts the automatic table creation method), then call `taos*stmt*set*tbname*tags()` to set the values of the table name and TAGS;
5. Call `taos*stmt*bind*param*batch()` to set the VALUES in a multi-row manner, or call `taos*stmt*bind_param()` to set the VALUES in a single-row manner;
6. Call `taos*stmt*add_batch()` to add the currently bound parameters to the batch processing;
7. Steps 3 to 6 can be repeated to add more data rows to the batch processing;
8. Call `taos*stmt*execute()` to execute the prepared batch processing command;
9. Once execution is complete, call `taos*stmt*close()` to release all resources.

Note: If `taos*stmt*execute()` is successful and there is no need to change the SQL statement, then it is possible to reuse the parsing result of `taos*stmt*prepare()` and directly proceed to steps 3 to 6 to bind new data. However, if there is an error in execution, it is not recommended to continue working in the current context. Instead, it is advisable to release resources and start over from the `taos*stmt*init()` step.

The specific functions related to the interface are as follows (you can also refer to the [prepare.c](https://github.com/taosdata/TDengine/blob/develop/docs/examples/c/prepare.c) file for how to use the corresponding functions):

- `TAOS*STMT* taos*stmt_init(TAOS *taos)`
  - **Interface Description**: Initializes a precompiled SQL statement object.
  - **Parameter Description**:
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a TAOS*STMT structure representing the precompiled SQL statement object. `NULL`: Failure, please call taos*stmt_errstr() function for error details.

- `int taos*stmt*prepare(TAOS_STMT *stmt, const char *sql, unsigned long length)`
  - **Interface Description**: Parses a precompiled SQL statement and binds the parsing results and parameter information to stmt.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - sql: [Input] SQL statement to be parsed.
    - length: [Input] Length of the sql parameter. If the length is greater than 0, this parameter will be used as the length of the SQL statement; if it is 0, the length of the SQL statement will be automatically determined.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*bind*param(TAOS*STMT *stmt, TAOS*MULTI*BIND *bind)`
  - **Interface Description**: Binds parameters to a precompiled SQL statement. Not as efficient as `taos*stmt*bind*param*batch()`, but can support non-INSERT type SQL statements.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - bind: [Input] Pointer to a valid TAOS_MULTI_BIND structure, which contains the list of parameters to be bound to the SQL statement. Ensure that the number and order of elements in this array match the parameters in the SQL statement exactly. The usage of TAOS_MULTI_BIND is similar to MYSQL_BIND in MySQL.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*set*tbname(TAOS*STMT* stmt, const char* name)`
  - **Interface Description**: (New in version 2.1.1.0, only supports replacing parameter values in INSERT statements) When the table name in the SQL statement uses a `?` placeholder, this function can be used to bind a specific table name.
  - **Parameter Description**:
    - stmt: [Input] Pointer to a valid precompiled SQL statement object.
    - name: [Input] Pointer to a string constant containing the subtable name.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*set*tbname*tags(TAOS*STMT* stmt, const char* name, TAOS*MULTI_BIND* tags)`
  - **Interface Description**: (Added in version 2.1.2.0, only supports replacing parameter values in INSERT statements) When both the table name and TAGS in the SQL statement use `?` placeholders, this function can be used to bind specific table names and specific TAGS values. The most typical scenario is the INSERT statement that uses the auto-create table feature (the current version does not support specifying specific TAGS columns). The number of columns in the TAGS parameter must match exactly the number of TAGS required by the SQL statement.
  - **Parameter Description**:
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
    - name: [Input] Points to a string constant containing the subtable name.
    - tags: [Input] Points to a valid pointer to a TAOS_MULTI_BIND structure, which contains the values of the subtable tags.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*bind*param*batch(TAOS*STMT* stmt, TAOS*MULTI_BIND* bind)`
  - **Interface Description**: (Added in version 2.1.1.0, only supports replacing parameter values in INSERT statements) Passes the data to be bound in a multi-column manner, ensuring that the order and number of data columns passed here are completely consistent with the VALUES parameters in the SQL statement.
  - **Parameter Description**:
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
    - bind: [Input] Points to a valid pointer to a TAOS_MULTI_BIND structure, which contains the list of parameters to be batch bound to the SQL statement.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*add*batch(TAOS*STMT *stmt)`
  - **Interface Description**: Adds the currently bound parameters to the batch processing. After calling this function, you can call `taos*stmt*bind*param()` or `taos*stmt*bind*param_batch()` again to bind new parameters. Note that this function only supports INSERT/IMPORT statements; if it is a SELECT or other SQL statements, it will return an error.
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*execute(TAOS_STMT *stmt)`
  - **Interface Description**: Executes the prepared statement. Currently, a statement can only be executed once.
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `int taos*stmt*affected*rows(TAOS*STMT *stmt)`
  - **Interface Description**: Gets the number of rows affected after executing the precompiled SQL statement.
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: Returns the number of affected rows.

- `int taos*stmt*affected*rows*once(TAOS_STMT *stmt)`
  - **Interface Description**: Gets the number of rows affected by executing a bound statement once.
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: Returns the number of affected rows.

- `TAOS*RES* taos*stmt*use*result(TAOS_STMT *stmt)`
  - **Interface Description**: Retrieves the result set of the statement. The usage of the result set is consistent with non-parameterized calls, and `taos*free*result()` should be called to release resources after use.
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to the query result set. `NULL`: Failure, please call taos*stmt*errstr() function for error details.

- `int taos*stmt*close(TAOS_STMT *stmt)`
  - **Interface Description**: After execution, releases all resources.
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, please refer to the error code page for details.

- `char * taos*stmt*errstr(TAOS_STMT *stmt)`
  - **Interface Description**: (Added in version 2.1.3.0) Used to obtain error information when other STMT APIs return an error (return error code or null pointer).
    - stmt: [Input] Points to a valid pointer to a precompiled SQL statement object.
  - **Return Value**: Returns a pointer to a string containing error information.

#### Schemaless Insert

In addition to using SQL or parameter binding APIs to insert data, you can also use a Schemaless method for insertion. Schemaless allows you to insert data without having to pre-create the structure of supertables/subtables. The TDengine system will automatically create and maintain the required table structure based on the data content written. For more details on how to use Schemaless, see the [Schemaless Insert](../../../developer-guide/schemaless-ingestion/) section. Here, we introduce the accompanying C/C++ API.

- `TAOS*RES* taos*schemaless_insert(TAOS* taos, const char* lines[], int numLines, int protocol, int precision)`
  - **Interface Description**: Performs a batch insert operation in schemaless mode, writing text data in line protocol to TDengine.
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet the parsing format requirements.
    - numLines: [Input] The number of lines of text data, cannot be 0.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
  - **Return Value**: Returns a pointer to a TAOS*RES structure, which contains the results of the insert operation. Applications can obtain error information using `taos*errstr()`, or get the error code using `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, in which case `taos_errno()` can still be safely called to obtain the error code information.
  The returned TAOS_RES must be managed by the caller to avoid memory leaks.

  **Explanation**
  
  Protocol type is an enumeration type, including the following three formats:

  - TSDB*SML*LINE_PROTOCOL: InfluxDB Line Protocol
  - TSDB*SML*TELNET_PROTOCOL: OpenTSDB Telnet text line protocol
  - TSDB*SML*JSON_PROTOCOL: OpenTSDB Json protocol format

  The definition of timestamp resolution, defined in the `taos.h` file, is as follows:

  - TSDB*SML*TIMESTAMP*NOT*CONFIGURED = 0,
  - TSDB*SML*TIMESTAMP_HOURS,
  - TSDB*SML*TIMESTAMP_MINUTES,
  - TSDB*SML*TIMESTAMP_SECONDS,
  - TSDB*SML*TIMESTAMP*MILLI*SECONDS,
  - TSDB*SML*TIMESTAMP*MICRO*SECONDS,
  - TSDB*SML*TIMESTAMP*NANO*SECONDS

  Note that the timestamp resolution parameter only takes effect when the protocol type is `SML*LINE*PROTOCOL`.
  For OpenTSDB's text protocols, timestamp parsing follows its official parsing rules — based on the number of characters contained in the timestamp to determine the time precision.

  **Other related schemaless interfaces**
- `TAOS*RES *taos*schemaless*insert*with*reqid(TAOS *taos, char *lines[], int numLines, int protocol, int precision, int64*t reqid)`
  - **Interface Description**: Performs a batch insert operation in schemaless mode, writing text data in line protocol to TDengine. The parameter reqid is passed to track the entire function call chain.
    - taos: [Input] Pointer to the database connection, which is established through `taos_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet the parsing format requirements.
    - numLines: [Input] The number of lines of text data, cannot be 0.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
    - reqid: [Input] Specified request ID, used to track the calling request. The request ID (reqid) can be used to establish a correlation between requests and responses on the client and server sides, which is very useful for tracking and debugging in distributed systems.
  - **Return Value**: Returns a pointer to a TAOS*RES structure, which contains the results of the insert operation. Applications can obtain error information using `taos*errstr()`, or get the error code using `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, in which case `taos_errno()` can still be safely called to obtain the error code information.
  The returned TAOS_RES must be managed by the caller to avoid memory leaks.

- `TAOS*RES *taos*schemaless*insert*raw(TAOS *taos, char *lines, int len, int32_t *totalRows, int protocol, int precision)`
  - **Interface Description**: Executes a schemaless batch insertion operation, writing text data in line protocol format into TDengine. Data is represented by the `lines` pointer and its length `len`, addressing the issue where data containing '\0' gets truncated.
    - taos: [Input] Pointer to the database connection, established through the `taos_connect()` function.
    - lines: [Input] Text data. A schemaless text string that meets parsing format requirements.
    - len: [Input] Total length (in bytes) of the data buffer `lines`.
    - totalRows: [Output] Pointer to an integer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Precision string for timestamps in the text data.
  - **Return Value**: Returns a pointer to a TAOS*RES structure containing the results of the insertion operation. Errors can be retrieved using `taos*errstr()`, and error codes with `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, but `taos_errno()` can still be safely called to obtain error code information.
  The returned TAOS_RES must be freed by the caller to avoid memory leaks.

- `TAOS*RES *taos*schemaless*insert*raw*with*reqid(TAOS *taos, char *lines, int len, int32*t *totalRows, int protocol, int precision, int64*t reqid)`
  - **Interface Description**: Executes a schemaless batch insertion operation, writing text data in line protocol format into TDengine. Data is represented by the `lines` pointer and its length `len`, addressing the issue where data containing '\0' gets truncated. The `reqid` parameter is passed to track the entire function call chain.
    - taos: [Input] Pointer to the database connection, established through the `taos_connect()` function.
    - lines: [Input] Text data. A schemaless text string that meets parsing format requirements.
    - len: [Input] Total length (in bytes) of the data buffer `lines`.
    - totalRows: [Output] Pointer to an integer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Precision string for timestamps in the text data.
    - reqid: [Input] Specified request ID, used to track the calling request. The request ID (reqid) can be used to establish a correlation between requests and responses on the client and server sides, which is very useful for tracking and debugging in distributed systems.
  - **Return Value**: Returns a pointer to a TAOS*RES structure containing the results of the insertion operation. Errors can be retrieved using `taos*errstr()`, and error codes with `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, but `taos_errno()` can still be safely called to obtain error code information.
  The returned TAOS_RES must be freed by the caller to avoid memory leaks.

- `TAOS*RES *taos*schemaless*insert*ttl(TAOS *taos, char *lines[], int numLines, int protocol, int precision, int32_t ttl)`
  - **Interface Description**: Executes a schemaless batch insertion operation, writing text data in line protocol format into TDengine. The `ttl` parameter is used to control the expiration time of the table's TTL.
    - taos: [Input] Pointer to the database connection, established through the `taos_connect()` function.
    - lines: [Input] Text data. A schemaless text string that meets parsing format requirements.
    - numLines: [Input] Number of lines of text data, cannot be 0.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Precision string for timestamps in the text data.
    - ttl: [Input] Specified Time-To-Live (TTL), in days. Records will be automatically deleted after exceeding this lifespan.
  - **Return Value**: Returns a pointer to a TAOS*RES structure containing the results of the insertion operation. Errors can be retrieved using `taos*errstr()`, and error codes with `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, but `taos_errno()` can still be safely called to obtain error code information.
  The returned TAOS_RES must be freed by the caller to avoid memory leaks.

- `TAOS*RES *taos*schemaless*insert*ttl*with*reqid(TAOS *taos, char *lines[], int numLines, int protocol, int precision, int32*t ttl, int64*t reqid)`
  - **Interface Description**: Executes a batch insert operation without a schema, writing line protocol text data into TDengine. The ttl parameter is passed to control the expiration time of the table's ttl. The reqid parameter is passed to track the entire function call chain.
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet parsing format requirements.
    - numLines: [Input] Number of lines of text data, cannot be 0.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
    - ttl: [Input] Specified Time-To-Live (TTL), in days. Records will be automatically deleted after exceeding this lifespan.
    - reqid: [Input] Specified request ID, used to track the call request. The request ID (reqid) can be used to establish a correlation between requests and responses across client and server sides, which is very useful for tracking and debugging in distributed systems.
  - **Return Value**: Returns a pointer to a TAOS*RES structure, which contains the results of the insert operation. Applications can obtain error information using `taos*errstr()`, or get the error code using `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, in which case `taos_errno()` can still be safely called to obtain error code information.
  The returned TAOS_RES must be freed by the caller to avoid memory leaks.

- `TAOS*RES *taos*schemaless*insert*raw*ttl(TAOS *taos, char *lines, int len, int32*t *totalRows, int protocol, int precision, int32_t ttl)`
  - **Interface Description**: Executes a batch insert operation without a schema, writing line protocol text data into TDengine. The lines pointer and length len are passed to represent the data, to address the issue of data being truncated due to containing '\0'. The ttl parameter is passed to control the expiration time of the table's ttl.
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet parsing format requirements.
    - len: [Input] Total length (in bytes) of the data buffer lines.
    - totalRows: [Output] Points to an integer pointer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
    - ttl: [Input] Specified Time-To-Live (TTL), in days. Records will be automatically deleted after exceeding this lifespan.
  - **Return Value**: Returns a pointer to a TAOS*RES structure, which contains the results of the insert operation. Applications can obtain error information using `taos*errstr()`, or get the error code using `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, in which case `taos_errno()` can still be safely called to obtain error code information.
  The returned TAOS_RES must be freed by the caller to avoid memory leaks.

- `TAOS*RES *taos*schemaless*insert*raw*ttl*with*reqid(TAOS *taos, char *lines, int len, int32*t *totalRows, int protocol, int precision, int32*t ttl, int64*t reqid)`
  - **Interface Description**: Executes a batch insert operation without a schema, writing line protocol text data into TDengine. The lines pointer and length len are passed to represent the data, to address the issue of data being truncated due to containing '\0'. The ttl parameter is passed to control the expiration time of the table's ttl. The reqid parameter is passed to track the entire function call chain.
    - taos: [Input] Pointer to the database connection, which is established through the `taos_connect()` function.
    - lines: [Input] Text data. Schemaless text strings that meet parsing format requirements.
    - len: [Input] Total length (in bytes) of the data buffer lines.
    - totalRows: [Output] Points to an integer pointer, used to return the total number of records successfully inserted.
    - protocol: [Input] Line protocol type, used to identify the text data format.
    - precision: [Input] Timestamp precision string in the text data.
    - ttl: [Input] Specified Time-To-Live (TTL), in days. Records will be automatically deleted after exceeding this lifespan.
    - reqid: [Input] Specified request ID, used to track the call request. The request ID (reqid) can be used to establish a correlation between requests and responses across client and server sides, which is very useful for tracking and debugging in distributed systems.
  - **Return Value**: Returns a pointer to a TAOS*RES structure, which contains the results of the insert operation. Applications can obtain error information using `taos*errstr()`, or get the error code using `taos*errno()`. In some cases, the returned TAOS*RES may be `NULL`, in which case `taos_errno()` can still be safely called to obtain error code information.
  The returned TAOS_RES must be freed by the caller to avoid memory leaks.

Description:

- The above 7 interfaces are extension interfaces, mainly used for passing ttl and reqid parameters during schemaless writing, and can be used as needed.
- Interfaces with _raw use the passed parameters lines pointer and length len to represent data, to solve the problem of data containing '\0' being truncated in the original interface. The totalRows pointer returns the number of data rows parsed.
- Interfaces with _ttl can pass the ttl parameter to control the ttl expiration time of table creation.
- Interfaces with _reqid can track the entire call chain by passing the reqid parameter.

#### Data Subscription

- `const char *tmq*err2str(int32*t code)`
  - **Interface Description**: Used to convert the error code of data subscription into error information.
    - code: [Input] Error code for data subscription.
  - **Return Value**: Returns a pointer to a string containing error information, the return value is not NULL, but the error information may be an empty string.

- `tmq*conf*t *tmq*conf*new()`
  - **Interface Description**: Creates a new TMQ configuration object.
  - **Return Value**: Non `NULL`: Success, returns a pointer to a tmq*conf*t structure, which is used to configure the behavior and features of TMQ. `NULL`: Failure, you can call the function taos_errstr(NULL) for more detailed error information.

- `tmq*conf*res*t tmq*conf*set(tmq*conf_t *conf, const char *key, const char *value)`
  - **Interface Description**: Sets the configuration items in the TMQ configuration object, used to configure consumption parameters.
    - conf: [Input] Pointer to a valid tmq_conf_t structure, representing a TMQ configuration object.
    - key: [Input] Configuration item key name.
    - value: [Input] Configuration item value.
  - **Return Value**: Returns a tmq*conf*res*t enum value, indicating the result of the configuration setting. tmq*conf*res*t defined as follows:

    ```cpp
    typedef enum tmq_conf_res_t {
         TMQ_CONF_UNKNOWN = -2,  // invalid key
         TMQ_CONF_INVALID = -1,  // invalid value
         TMQ_CONF_OK = 0,        // success
       } tmq_conf_res_t;
    ```

- `void tmq*conf*set*auto*commit*cb(tmq*conf*t *conf, tmq*commit_cb *cb, void *param)`
  - **Interface Description**: Sets the auto-commit callback function in the TMQ configuration object.
    - conf: [Input] Pointer to a valid tmq_conf_t structure, representing a TMQ configuration object.
    - cb: [Input] Pointer to a valid tmq_commit_cb callback function, which will be called after the message is consumed to confirm the message handling status.
    - param: [Input] User-defined parameter passed to the callback function.

  The definition of the auto-commit callback function is as follows:

  ```cpp
  typedef void(tmq*commit*cb(tmq*t *tmq, int32*t code, void *param))
  ```

- `void tmq*conf*destroy(tmq*conf*t *conf)`
  - **Interface Description**: Destroys a TMQ configuration object and releases related resources.
    - conf: [Input] Pointer to a valid tmq_conf_t structure, representing a TMQ configuration object.

- `tmq*list*t *tmq*list*new()`
  - **Interface Description**: Used to create a tmq*list*t structure, used to store subscribed topics.
  - **Return Value**: Non `NULL`: Success, returns a pointer to a tmq*list*t structure. `NULL`: Failure, you can call the function taos_errstr(NULL) for more detailed error information.

- `int32*t tmq*list*append(tmq*list_t *list, const char* topic)`
  - **Interface Description**: Used to add a topic to a tmq*list*t structure.
    - list: [Input] Pointer to a valid tmq_list_t structure, representing a TMQ list object.
    - topic: [Input] Topic name.
  - **Return Value**: `0`: Success. Non `0`: Failure, you can call the function `char *tmq*err2str(int32*t code)` for more detailed error information.

- `void tmq*list*destroy(tmq*list*t *list)`
  - **Interface Description**: Used to destroy a tmq*list*t structure, the result of tmq*list*new needs to be destroyed through this interface.
    - list: [Input] Pointer to a valid tmq_list_t structure, representing a TMQ list object.

- `int32*t tmq*list*get*size(const tmq*list*t *list)`
  - **Interface Description**: Used to get the number of topics in the tmq*list*t structure.
    - list: [Input] Points to a valid tmq_list_t structure pointer, representing a TMQ list object.
  - **Return Value**: `>=0`: Success, returns the number of topics in the tmq*list*t structure. `-1`: Failure, indicates the input parameter list is NULL.

- `char **tmq*list*to*c*array(const tmq*list*t *list)`
  - **Interface Description**: Used to convert a tmq*list*t structure into a C array, where each element is a string pointer.
    - list: [Input] Points to a valid tmq_list_t structure pointer, representing a TMQ list object.
  - **Return Value**: Non-`NULL`: Success, returns a C array, each element is a string pointer representing a topic name. `NULL`: Failure, indicates the input parameter list is NULL.

- `tmq*t *tmq*consumer*new(tmq*conf*t *conf, char *errstr, int32*t errstrLen)`
  - **Interface Description**: Used to create a tmq*t structure for consuming data. After consuming the data, tmq*consumer_close must be called to close the consumer.
    - conf: [Input] Points to a valid tmq_conf_t structure pointer, representing a TMQ configuration object.
    - errstr: [Output] Points to a valid character buffer pointer, used to receive error messages that may occur during creation. Memory allocation/release is the responsibility of the caller.
    - errstrLen: [Input] Specifies the size of the errstr buffer (in bytes).
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a tmq_t structure representing a TMQ consumer object. `NULL`: Failure, error information stored in the errstr parameter.

- `int32*t tmq*subscribe(tmq*t *tmq, const tmq*list*t *topic*list)`
  - **Interface Description**: Used to subscribe to a list of topics. After consuming the data, tmq_subscribe must be called to unsubscribe.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - topic_list: [Input] Points to a valid tmq_list_t structure pointer, containing one or more topic names.
  - **Return Value**: `0`: Success. Non-`0`: Failure, the function `char *tmq*err2str(int32*t code)` can be called for more detailed error information.

- `int32*t tmq*unsubscribe(tmq_t *tmq)`
  - **Interface Description**: Used to unsubscribe from a list of topics. Must be used in conjunction with tmq_subscribe.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, the function `char *tmq*err2str(int32*t code)` can be called for more detailed error information.

- `int32*t tmq*subscription(tmq*t *tmq, tmq*list*t **topic*list)`
  - **Interface Description**: Used to get the list of subscribed topics.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - topic_list: [Output] Points to a pointer of a tmq_list_t structure pointer, used to receive the current list of subscribed topics.
  - **Return Value**: `0`: Success. Non-`0`: Failure, the function `char *tmq*err2str(int32*t code)` can be called for more detailed error information.

- `TAOS*RES *tmq*consumer*poll(tmq*t *tmq, int64_t timeout)`
  - **Interface Description**: Used to poll for consuming data, each consumer can only call this interface in a single thread.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - timeout: [Input] Polling timeout in milliseconds, a negative number indicates a default timeout of 1 second.
  - **Return Value**: Non-`NULL`: Success, returns a pointer to a TAOS*RES structure containing the received messages. `NULL`: indicates no data, the error code can be obtained through taos*errno (NULL), please refer to the reference manual for specific error message. TAOS*RES results are consistent with taos*query results, and information in TAOS_RES can be obtained through various query interfaces, such as schema, etc.

- `int32*t tmq*consumer*close(tmq*t *tmq)`
  - **Interface Description**: Used to close a tmq*t structure. Must be used in conjunction with tmq*consumer_new.
    - tmq: [Input] Points to a valid tmq_t structure pointer, which represents a TMQ consumer object.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `char *tmq*err2str(int32*t code)` to get more detailed error information.

- `int32*t tmq*get*topic*assignment(tmq*t *tmq, const char *pTopicName, tmq*topic*assignment **assignment, int32*t *numOfAssignment)`
  - **Interface Description**: Returns the information of the vgroup currently assigned to the consumer, including vgId, the maximum and minimum offset of wal, and the current consumed offset.
    - tmq: [Input] Points to a valid tmq_t structure pointer, which represents a TMQ consumer object.
    - pTopicName: [Input] The topic name for which to query the assignment information.
    - assignment: [Output] Points to a pointer to a tmq_topic_assignment structure, used to receive assignment information. The data size is numOfAssignment, and it needs to be released through the tmq_free_assignment interface.
    - numOfAssignment: [Output] Points to an integer pointer, used to receive the number of valid vgroups assigned to the consumer.
  - **Return Value**: `0`: Success. Non-`0`: Failure, you can call the function `char *tmq*err2str(int32*t code)` to get more detailed error information.

- `void tmq*free*assignment(tmq*topic*assignment* pAssignment)`
  - **Interface Description**: Returns the information of the vgroup currently assigned to the consumer, including vgId, the maximum and minimum offset of wal, and the current consumed offset.
    - pAssignment: [Input] Points to a valid tmq_topic_assignment structure array pointer, which contains the vgroup assignment information.

- `int64*t tmq*committed(tmq*t *tmq, const char *pTopicName, int32*t vgId)`
  - **Interface Description**: Gets the committed offset for a specific topic and vgroup of the TMQ consumer object.
    - tmq: [Input] Points to a valid tmq_t structure pointer, which represents a TMQ consumer object.
    - pTopicName: [Input] The topic name for which to query the committed offset.
    - vgId: [Input] The ID of the vgroup.
  - **Return Value**: `>=0`: Success, returns an int64*t value representing the committed offset. `<0`: Failure, the return value is the error code, you can call the function `char *tmq*err2str(int32_t code)` to get more detailed error information.

- `int32*t tmq*commit*sync(tmq*t *tmq, const TAOS_RES *msg)`
  - **Interface Description**: Synchronously commits the message offset processed by the TMQ consumer object.
    - tmq: [Input] Points to a valid tmq_t structure pointer, which represents a TMQ consumer object.
    - msg: [Input] Points to a valid TAOS_RES structure pointer, which contains the processed message. If NULL, commits the current progress of all vgroups consumed by the current consumer.
  - **Return Value**: `0`: Success, the offset has been successfully committed. Non-`0`: Failure, you can call the function `char *tmq*err2str(int32*t code)` to get more detailed error information.

- `void tmq*commit*async(tmq*t *tmq, const TAOS*RES *msg, tmq*commit*cb *cb, void *param)`
  - **Interface Description**: Asynchronously commits the message offset processed by the TMQ consumer object.
    - tmq: [Input] Points to a valid tmq_t structure pointer, which represents a TMQ consumer object.
    - msg: [Input] Points to a valid TAOS_RES structure pointer, which contains the processed message. If NULL, commits the current progress of all vgroups consumed by the current consumer.
    - cb: [Input] A pointer to a callback function, which will be called upon completion of the commit.
    - param: [Input] A user-defined parameter, which will be passed to cb in the callback function.

- `int32*t tmq*commit*offset*sync(tmq*t *tmq, const char *pTopicName, int32*t vgId, int64_t offset)`
  - **Interface Description**: Synchronously commits the offset for a specific topic and vgroup of a TMQ consumer object.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The name of the topic for which the offset is to be committed.
    - vgId: [Input] The ID of the virtual group vgroup.
    - offset: [Input] The offset to be committed.
  - **Return Value**: `0`: Success, the offset has been successfully committed. Non-`0`: Failure, you can call the function `char *tmq*err2str(int32*t code)` to get more detailed error information.

- `void tmq*commit*offset*async(tmq*t *tmq, const char *pTopicName, int32*t vgId, int64*t offset, tmq*commit*cb *cb, void *param)`
  - **Interface Description**: Asynchronously commits the offset for a specific topic and vgroup of a TMQ consumer object.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The name of the topic for which the offset is to be committed.
    - vgId: [Input] The ID of the virtual group vgroup.
    - offset: [Input] The offset to be committed.
    - cb: [Input] A pointer to a callback function that will be called upon completion of the commit.
    - param: [Input] A user-defined parameter that will be passed to the callback function cb.

  **Description**
  - There are two types of commit interfaces, each type has synchronous and asynchronous interfaces:
  - First type: Commit based on message, submitting the progress in the message, if the message is NULL, submit the current progress of all vgroups consumed by the current consumer: tmq*commit*sync/tmq*commit*async
  - Second type: Commit based on the offset of a specific topic and a specific vgroup: tmq*commit*offset*sync/tmq*commit*offset*async

- `int64*t tmq*position(tmq*t *tmq, const char *pTopicName, int32*t vgId)`
  - **Interface Description**: Gets the current consumption position, i.e., the position of the next data that has been consumed.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The name of the topic for which the current position is being queried.
    - vgId: [Input] The ID of the virtual group vgroup.
  - **Return Value**: `>=0`: Success, returns an int64*t type value representing the offset of the current position. `<0`: Failure, the return value is the error code, you can call the function `char *tmq*err2str(int32_t code)` to get more detailed error information.

- `int32*t tmq*offset*seek(tmq*t *tmq, const char *pTopicName, int32*t vgId, int64*t offset)`
  - **Interface Description**: Sets the offset of a TMQ consumer object in a specific topic and vgroup to a specified position.
    - tmq: [Input] Points to a valid tmq_t structure pointer, representing a TMQ consumer object.
    - pTopicName: [Input] The name of the topic for which the current position is being queried.
    - vgId: [Input] The ID of the virtual group vgroup.
    - offset: [Input] The ID of the virtual group vgroup.
  - **Return Value**: `0`: Success, non-`0`: Failure, you can call the function `char *tmq*err2str(int32*t code)` to get more detailed error information.

- `int64*t tmq*get*vgroup*offset(TAOS_RES* res)`
  - **Interface Description**: Extracts the current consumption data position offset of the virtual group (vgroup) from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid TAOS_RES structure pointer, containing messages polled from the TMQ consumer.
  - **Return Value**: `>=0`: Success, returns an int64*t type value representing the offset of the current consumption position. `<0`: Failure, the return value is the error code, you can call the function `char *tmq*err2str(int32_t code)` to get more detailed error information.

- `int32*t tmq*get*vgroup*id(TAOS_RES *res)`
  - **Interface Description**: Extracts the ID of the virtual group (vgroup) from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid TAOS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: `>=0`: Success, returns an int32*t type value representing the ID of the virtual group (vgroup). `<0`: Failure, the return value is the error code, you can call the function `char *tmq*err2str(int32_t code)` to get more detailed error information.

- `TAOS *tmq*get*connect(tmq_t *tmq)`
  - **Interface Description**: Retrieves the connection handle to the TDengine database from the TMQ consumer object.
    - tmq: [Input] Points to a valid tmq_t structure pointer, which represents a TMQ consumer object.
  - **Return Value**: Non-`NULL`: Success, returns a TAOS * type pointer pointing to the connection handle with the TDengine database. `NULL`: Failure, illegal input parameters.

- `const char *tmq*get*table*name(TAOS*RES *res)`
  - **Interface Description**: Retrieves the table name from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid TAOS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Non-`NULL`: Success, returns a const char * type pointer pointing to the table name string. `NULL`: Failure, illegal input parameters.

- `tmq*res*t tmq*get*res*type(TAOS*RES *res)`
  - **Interface Description**: Retrieves the message type from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid TAOS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Returns a tmq*res*t type enumeration value representing the message type.
    - tmq_res_t represents the type of data consumed, defined as follows:

  ```cpp
  typedef enum tmq*res*t {
    TMQ_RES_INVALID = -1,   // Invalid
    TMQ_RES_DATA = 1,       // Data type
    TMQ_RES_TABLE_META = 2, // Metadata type
    TMQ_RES_METADATA = 3    // Both metadata and data types, i.e., automatic table creation
  } tmq*res*t;
  ```

- `const char *tmq*get*topic*name(TAOS*RES *res)`
  - **Interface Description**: Retrieves the topic name from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid TAOS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Non-`NULL`: Success, returns a const char * type pointer pointing to the topic name string. `NULL`: Failure, illegal input parameters.

- `const char *tmq*get*db*name(TAOS*RES *res)`
  - **Interface Description**: Retrieves the database name from the message results obtained by the TMQ consumer.
    - res: [Input] Points to a valid TAOS_RES structure pointer, which contains messages polled from the TMQ consumer.
  - **Return Value**: Non-`NULL`: Success, returns a const char * type pointer pointing to the database name string. `NULL`: Failure, illegal input parameters.
