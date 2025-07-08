---
title: taosAdapter Reference
sidebar_label: taosAdapter
slug: /tdengine-reference/components/taosadapter
---

import Image from '@theme/IdealImage';
import imgAdapter from '../../assets/taosadapter-01.png';
import Prometheus from "../../assets/resources/_prometheus.mdx"
import CollectD from "../../assets/resources/_collectd.mdx"
import StatsD from "../../assets/resources/_statsd.mdx"
import Icinga2 from "../../assets/resources/_icinga2.mdx"
import TCollector from "../../assets/resources/_tcollector.mdx"

taosAdapter is a companion tool for TDengine, serving as a bridge and adapter between the TDengine cluster and applications. It provides an easy and efficient way to ingest data directly from data collection agents (such as Telegraf, StatsD, collectd, etc.). It also offers InfluxDB/OpenTSDB compatible data ingestion interfaces, allowing InfluxDB/OpenTSDB applications to be seamlessly ported to TDengine.
The connectors of TDengine in various languages communicate with TDengine through the WebSocket interface, hence the taosAdapter must be installed.

The architecture diagram is as follows:

<figure>
<Image img={imgAdapter} alt="taosAdapter architecture"/>
<figcaption>Figure 1. taosAdapter architecture</figcaption>
</figure>

## Feature List

The taosAdapter provides the following features:

- WebSocket Interface:
  Supports executing SQL, schemaless writing, parameter binding, and data subscription through the WebSocket protocol.
- InfluxDB v1 write interface:
  [https://docs.influxdata.com/influxdb/v2.0/reference/api/influxdb-1x/write/](https://docs.influxdata.com/influxdb/v2.0/reference/api/influxdb-1x/write/)
- Compatible with OpenTSDB JSON and telnet format writing:
  - [http://opentsdb.net/docs/build/html/api*http/put.html](http://opentsdb.net/docs/build/html/api*http/put.html)
  - [http://opentsdb .net/docs/build/html/api*telnet/put.html](http://opentsdb.net/docs/build/html/api*telnet/put.html)
- collectd data writing:
  collectd is a system statistics collection daemon, visit [https://collectd.org/](https://collectd.org/) for more information.
- StatsD data writing:
  StatsD is a simple yet powerful daemon for gathering statistics. Visit [https://github.com/statsd/statsd](https://github.com/statsd/statsd) for more information.
- icinga2 OpenTSDB writer data writing:
  icinga2 is a software for collecting check results metrics and performance data. Visit [https://icinga.com/docs/icinga-2/latest/doc/14-features/#opentsdb-writer](https://icinga.com/docs/icinga-2/latest/doc/14-features/#opentsdb-writer) for more information.
- TCollector data writing:
  TCollector is a client process that collects data from local collectors and pushes it to OpenTSDB. Visit [http://opentsdb.net/docs/build/html/user*guide/utilities/tcollector.html](http://opentsdb.net/docs/build/html/user*guide/utilities/tcollector.html) for more information.
- node_exporter data collection and writing:
  node*exporter is an exporter of machine metrics. Visit [https://github.com/prometheus/node*exporter](https://github.com/prometheus/node_exporter) for more information.
- Supports Prometheus remote*read and remote*write:
  remote*read and remote*write are Prometheus's data read-write separation cluster solutions. Visit [https://prometheus.io/blog/2019/10/10/remote-read-meets-streaming/#remote-apis](https://prometheus.io/blog/2019/10/10/remote-read-meets-streaming/#remote-apis) for more information.
- RESTful API:
  [RESTful API](../../client-libraries/rest-api/)

### WebSocket Interface

Through the WebSocket interface of taosAdapter, connectors in various languages can achieve SQL execution, schemaless writing, parameter binding, and data subscription functionalities. Refer to the [Development Guide](../../../developer-guide/connecting-to-tdengine/#websocket-connection) for more details.

### InfluxDB v1 write interface

You can use any client that supports the HTTP protocol to write data in InfluxDB compatible format to TDengine by accessing the Restful interface URL `http://<fqdn>:6041/influxdb/v1/write`.

Supported InfluxDB parameters are as follows:

- `db` specifies the database name used by TDengine
- `precision` the time precision used by TDengine
- `u` TDengine username
- `p` TDengine password
- `ttl` the lifespan of automatically created subtables, determined by the TTL parameter of the first data entry in the subtable, which cannot be updated. For more information, please refer to the TTL parameter in the [table creation document](../../sql-manual/manage-tables/).

Note: Currently, InfluxDB's token authentication method is not supported, only Basic authentication and query parameter verification are supported.
Example: `curl --request POST http://127.0.0.1:6041/influxdb/v1/write?db=test --user "root:taosdata" --data-binary "measurement,host=host1 field1=2i,field2=2.0 1577836800000000000"`

### OpenTSDB JSON and telnet format writing

You can use any client that supports the HTTP protocol to write data in OpenTSDB compatible format to TDengine by accessing the Restful interface URL `http://<fqdn>:6041/<APIEndPoint>`. EndPoint as follows:

```text
/opentsdb/v1/put/json/<db>
/opentsdb/v1/put/telnet/<db>
```

### collectd data writing

<CollectD />

### StatsD data writing

<StatsD />

### icinga2 OpenTSDB writer data writing

<Icinga2 />

### TCollector data writing

<TCollector />

### node_exporter data collection and writing

An exporter used by Prometheus that exposes hardware and operating system metrics from \*NIX kernels

- Enable configuration of taosAdapter node_exporter.enable
- Set the relevant configuration for node_exporter
- Restart taosAdapter

### Supports Prometheus remote*read and remote*write

<Prometheus />

### RESTful API

You can use any client that supports the HTTP protocol to write data to TDengine or query data from TDengine by accessing the RESTful interface URL `http://<fqdn>:6041/rest/sql`. For details, please refer to the [REST API documentation](../../client-libraries/rest-api/).

## Installation

taosAdapter is part of the TDengine server software. If you are using TDengine server, you do not need any additional steps to install taosAdapter. If you need to deploy taosAdapter separately from the TDengine server, you should install the complete TDengine on that server to install taosAdapter. If you need to compile taosAdapter from source code, you can refer to the [Build taosAdapter](https://github.com/taosdata/taosadapter/blob/3.0/BUILD.md) document.

After the installation is complete, you can start the taosAdapter service using the command `systemctl start taosadapter`.

## Configuration

taosAdapter supports configuration through command-line parameters, environment variables, and configuration files. The default configuration file is `/etc/taos/taosadapter.toml`, and you can specify the configuration file using the -c or --config command-line parameter..

Command-line parameters take precedence over environment variables, which take precedence over configuration files. The command-line usage is arg=val, such as taosadapter -p=30000 --debug=true.

See the example configuration file at [example/config/taosadapter.toml](https://github.com/taosdata/taosadapter/blob/3.0/example/config/taosadapter.toml).

### Basic Configuration

The basic configuration parameters for `taosAdapter` are as follows:

- **`debug`**: Whether to enable debug mode (pprof)
  - **When set to `true` (default)**: Enables Go pprof debug mode, allowing access to debug information via `http://<fqdn>:<port>/debug/pprof`.
  - **When set to `false`**: Disables debug mode, preventing access to debug information.

- **`instanceId`**: The instance ID of `taosAdapter`, used to distinguish logs from different instances. Default value: `32`.

- **`port`**: The port on which `taosAdapter` provides HTTP/WebSocket services. Default value: `6041`.

- **`taosConfigDir`**: The configuration file directory for TDengine. Default value: `/etc/taos`. The `taos.cfg` file in this directory will be loaded.

Starting from version 3.3.4.0, taosAdapter supports setting the number of concurrent calls for invoking C methods:

- **`maxAsyncConcurrentLimit`**

  Sets the maximum number of concurrent calls for C asynchronous methods (`0` means using the number of CPU cores).

- **`maxSyncConcurrentLimit`**

  Sets the maximum number of concurrent calls for C synchronous methods (`0` means using the number of CPU cores).

### Cross-Origin Configuration

When making API calls from the browser, please configure the following Cross-Origin Resource Sharing (CORS) parameters based on your actual situation:

- **`cors.allowAllOrigins`**: Whether to allow all origins to access, default is true.
- **`cors.allowOrigins`**: A comma-separated list of origins allowed to access. Multiple origins can be specified.
- **`cors.allowHeaders`**: A comma-separated list of request headers allowed for cross-origin access. Multiple headers can be specified.
- **`cors.exposeHeaders`**: A comma-separated list of response headers exposed for cross-origin access. Multiple headers can be specified.
- **`cors.allowCredentials`**: Whether to allow cross-origin requests to include user credentials, such as cookies, HTTP authentication information, or client SSL certificates.
- **`cors.allowWebSockets`**: Whether to allow WebSockets connections.

If you are not making API calls through a browser, you do not need to worry about these configurations.

The above configurations take effect for the following interfaces:

- RESTful API requests
- WebSocket API requests
- InfluxDB v1 write interface
- OpenTSDB HTTP write interface

For details about the CORS protocol, please refer to: [https://www.w3.org/wiki/CORS*Enabled](https://www.w3.org/wiki/CORS*Enabled) or [https://developer.mozilla.org/docs/Web/HTTP/CORS](https://developer.mozilla.org/docs/Web/HTTP/CORS).

### Connection Pool Configuration

taosAdapter uses a connection pool to manage connections to TDengine, improving concurrency performance and resource utilization. The connection pool configuration applies to the following interfaces, and these interfaces share a single connection pool:

- RESTful API requests
- InfluxDB v1 write interface
- OpenTSDB JSON and telnet format writing
- Telegraf data writing
- collectd data writing
- StatsD data writing
- node_exporter data collection writing
- Prometheus remote*read and remote*write

The configuration parameters for the connection pool are as follows:

- **`pool.maxConnect`**: The maximum number of connections allowed in the pool, default is twice the number of CPU cores. It is recommended to keep the default setting.
- **`pool.maxIdle`**: The maximum number of idle connections in the pool, default is the same as `pool.maxConnect`. It is recommended to keep the default setting.
- **`pool.idleTimeout`**: Connection idle timeout, default is never timeout. It is recommended to keep the default setting.
- **`pool.waitTimeout`**: Timeout for obtaining a connection from the pool, default is set to 60 seconds. If a connection is not obtained within the timeout period, HTTP status code 503 will be returned. This parameter is available starting from version 3.3.3.0.
- **`pool.maxWait`**: The maximum number of requests waiting to get a connection in the pool, default is 0, which means no limit. When the number of queued requests exceeds this value, new requests will return HTTP status code 503. This parameter is available starting from version 3.3.3.0.

### HTTP Response Code Configuration

taosAdapter uses the parameter `httpCodeServerError` to set whether to return a non-200 HTTP status code when the C interface returns an error. When set to true, it will return different HTTP status codes based on the error code returned by C. See [HTTP Response Codes](../../client-libraries/rest-api/) for details.

This configuration only affects the **RESTful interface**.

Parameter Description:

- **`httpCodeServerError`**:
  - **When set to `true`**: Map the error code returned by the C interface to the corresponding HTTP status code.
  - **When set to `false`**: Regardless of the error returned by the C interface, always return the HTTP status code `200` (default value).

### Memory limit configuration

taosAdapter will monitor the memory usage during its operation and adjust it through two thresholds. The valid value range is an integer from 1 to 100, and the unit is the percentage of system physical memory.

This configuration only affects the following interfaces:

- RESTful interface request
- InfluxDB v1 write interface
- OpenTSDB HTTP write interface
- Prometheus remote*read and remote*write interfaces

#### Parameter Description

- **`pauseQueryMemoryThreshold`**:
  - When memory usage exceeds this threshold, taosAdapter will stop processing query requests.
  - Default value: `70` (i.e. 70% of system physical memory).
- **`pauseAllMemoryThreshold`**:
  - When memory usage exceeds this threshold, taosAdapter will stop processing all requests (including writes and queries).
  - Default value: `80` (i.e. 80% of system physical memory).

When memory usage falls below the threshold, taosAdapter will automatically resume the corresponding function.

#### HTTP return content

- **When `pauseQueryMemoryThreshold` is exceeded**:
  - HTTP status code: `503`
  - Return content: `"query memory exceeds threshold"`

- **When `pauseAllMemoryThreshold` is exceeded**:
  - HTTP status code: `503`
  - Return content: `"memory exceeds threshold"`

#### Status check interface

The memory status of taosAdapter can be checked through the following interface:

- **Normal status**: `http://<fqdn>:6041/-/ping` returns `code 200`.
- **Memory exceeds threshold**:
  - If the memory exceeds `pauseAllMemoryThreshold`, `code 503` is returned.
  - If the memory exceeds `pauseQueryMemoryThreshold` and the request parameter contains `action=query`, `code 503` is returned.

#### Related configuration parameters

- **`monitor.collectDuration`**: memory monitoring interval, default value is `3s`, environment variable is `TAOS*MONITOR*COLLECT_DURATION`.
- **`monitor.incgroup`**: whether to run in a container (set to `true` for running in a container), default value is `false`, environment variable is `TAOS*MONITOR*INCGROUP`.
- **`monitor.pauseQueryMemoryThreshold`**: memory threshold (percentage) for query request pause, default value is `70`, environment variable is `TAOS*MONITOR*PAUSE*QUERY*MEMORY_THRESHOLD`.
- **`monitor.pauseAllMemoryThreshold`**: memory threshold (percentage) for query and write request pause, default value is `80`, environment variable is `TAOS*MONITOR*PAUSE*ALL*MEMORY_THRESHOLD`.

You can make corresponding adjustments based on the specific project application scenario and operation strategy, and it is recommended to use operation monitoring software to monitor the system memory status in a timely manner. The load balancer can also check the operation status of taosAdapter through this interface.

### Schemaless write create DB configuration

Starting from **version 3.0.4.0**, taosAdapter provides the parameter `smlAutoCreateDB` to control whether to automatically create a database (DB) when writing to the schemaless protocol.

The `smlAutoCreateDB` parameter only affects the following interfaces:

- InfluxDB v1 write interface
- OpenTSDB JSON and telnet format writing
- Telegraf data writing
- collectd data writing
- StatsD data writing
- node_exporter data writing

#### Parameter Description

- **`smlAutoCreateDB`**:
  - **When set to `true`**: When writing to the schemaless protocol, if the target database does not exist, taosAdapter will automatically create the database.
  - **When set to `false`**: The user needs to manually create the database, otherwise the write will fail (default value).

### Number of results returned configuration

taosAdapter provides the parameter `restfulRowLimit` to control the number of results returned by the HTTP interface.

The `restfulRowLimit` parameter only affects the return results of the following interfaces:

- RESTful interface
- Prometheus remote_read interface

#### Parameter Description

- **`restfulRowLimit`**:
  - **When set to a positive integer**: The number of results returned by the interface will not exceed this value.
  - **When set to `-1`**: The number of results returned by the interface is unlimited (default value).

### Log configuration

The log can be configured with the following parameters:

- **`log.path`**

  Specifies the log storage path (Default: `"/var/log/taos"`).

- **`log.level`**

  Sets the log level (Default: `"info"`).

- **`log.keepDays`**

  Number of days to retain logs (Positive integer, Default: `30`).

- **`log.rotationCount`**

  Number of log files to rotate (Default: `30`).

- **`log.rotationSize`**

  Maximum size of a single log file (Supports KB/MB/GB units, Default: `"1GB"`).

- **`log.compress`**

  Whether to compress old log files (Default: `false`).

- **`log.rotationTime`**

  Log rotation interval (Deprecated, fixed at 24-hour rotation).

- **`log.reservedDiskSize`**

  Disk space reserved for log directory (Supports KB/MB/GB units, Default: `"1GB"`).

- **`log.enableRecordHttpSql`**

  Whether to record HTTP SQL requests (Default: `false`).

- **`log.sqlRotationCount`**

  Number of SQL log files to rotate (Default: `2`).

- **`log.sqlRotationSize`**

  Maximum size of a single SQL log file (Supports KB/MB/GB units, Default: `"1GB"`).

- **`log.sqlRotationTime`**

  SQL log rotation interval (Default: `24h`).

1. You can set the taosAdapter log output detail level by setting the --log.level parameter or the environment variable TAOS*ADAPTER*LOG_LEVEL. Valid values ​​include: panic, fatal, error, warn, warning, info, debug, and trace.
2. Starting from **3.3.5.0 version**, taosAdapter supports dynamic modification of log level through HTTP interface. Users can dynamically adjust the log level by sending HTTP PUT request to /config interface. The authentication method of this interface is the same as /rest/sql interface, and the configuration item key-value pair in JSON format must be passed in the request body.

The following is an example of setting the log level to debug through the curl command:

```shell
curl --location --request PUT 'http://127.0.0.1:6041/config' \
-u root:taosdata \
--data '{"log.level": "debug"}'
```

### Third-party Data Source Configuration

#### Collectd Configuration

- **`collectd.enable`**

  Enable/disable collectd protocol support (Default: `false`)

- **`collectd.port`**

  Collectd service listening port (Default: `6045`)

- **`collectd.db`**

  Target database for collectd data (Default: `"collectd"`)

- **`collectd.user`**

  Database username (Default: `"root"`)

- **`collectd.password`**

  Database password (Default: `"taosdata"`)

- **`collectd.ttl`**

  Data time-to-live (Default: `0` = no expiration)

- **`collectd.worker`**

  Number of write worker threads (Default: `10`)

#### InfluxDB Configuration

- **`influxdb.enable`**

  Enable/disable InfluxDB protocol support (Default: `true`)

#### Node Exporter Configuration

- **`node_exporter.enable`**

  Enable node_exporter data collection (Default: `false`)

- **`node_exporter.db`**

  Target database name (Default: `"node_exporter"`)

- **`node_exporter.urls`**

  Service endpoints (Default: `["http://localhost:9100"]`)

- **`node_exporter.gatherDuration`**

  Collection interval (Default: `5s`)

- **`node_exporter.responseTimeout`**

  Request timeout (Default: `5s`)

- **`node_exporter.user`**

  Database username (Default: `"root"`)

- **`node_exporter.password`**

  Database password (Default: `"taosdata"`)

- **`node_exporter.ttl`**

  Data TTL (Default: `0`)

- **`node_exporter.httpUsername`**

  HTTP Basic Auth username (Optional)

- **`node_exporter.httpPassword`**

  HTTP Basic Auth password (Optional)

- **`node_exporter.httpBearerTokenString`**

  HTTP Bearer Token (Optional)

- **`node_exporter.insecureSkipVerify`**

  Skip SSL verification (Default: `true`)

- **`node_exporter.certFile`**

  Client certificate path (Optional)

- **`node_exporter.keyFile`**

  Client key path (Optional)

- **`node_exporter.caCertFile`**

  CA certificate path (Optional)

#### OpenTSDB Configuration

- **`opentsdb.enable`**

  Enable OpenTSDB HTTP protocol (Default: `true`)

- **`opentsdb_telnet.enable`**

  Enable OpenTSDB Telnet (Warning: no auth, Default: `false`)

- **`opentsdb_telnet.ports`**

  Listening ports (Default: `[6046,6047,6048,6049]`)

- **`opentsdb_telnet.dbs`**

  Target databases (Default: `["opentsdb*telnet","collectd*tsdb","icinga2*tsdb","tcollector*tsdb"]`)

- **`opentsdb_telnet.user`**

  Database username (Default: `"root"`)

- **`opentsdb_telnet.password`**

  Database password (Default: `"taosdata"`)

- **`opentsdb_telnet.ttl`**

  Data TTL (Default: `0`)

- **`opentsdb_telnet.batchSize`**

  Batch write size (Default: `1`)

- **`opentsdb_telnet.flushInterval`**

  Flush interval (Default: `0s`)

- **`opentsdb_telnet.maxTCPConnections`**

  Max TCP connections (Default: `250`)

- **`opentsdb_telnet.tcpKeepAlive`**

  Enable TCP KeepAlive (Default: `false`)

#### StatsD Configuration

- **`statsd.enable`**

  Enable StatsD protocol (Default: `false`)

- **`statsd.port`**

  Listening port (Default: `6044`)

- **`statsd.protocol`**

  Transport protocol (Options: tcp/udp/tcp4/udp4, Default: `"udp4"`)

- **`statsd.db`**

  Target database (Default: `"statsd"`)

- **`statsd.user`**

  Database username (Default: `"root"`)

- **`statsd.password`**

  Database password (Default: `"taosdata"`)

- **`statsd.ttl`**

  Data TTL (Default: `0`)

- **`statsd.gatherInterval`**

  Collection interval (Default: `5s`)

- **`statsd.worker`**

  Worker threads (Default: `10`)

- **`statsd.allowPendingMessages`**

  Max pending messages (Default: `50000`)

- **`statsd.maxTCPConnections`**

  Max TCP connections (Default: `250`)

- **`statsd.tcpKeepAlive`**

  Enable TCP KeepAlive (Default: `false`)

- **`statsd.deleteCounters`**

  Clear counter cache after collection (Default: `true`)

- **`statsd.deleteGauges`**

  Clear gauge cache after collection (Default: `true`)

- **`statsd.deleteSets`**

  Clear sets cache after collection (Default: `true`)

- **`statsd.deleteTimings`**

  Clear timings cache after collection (Default: `true`)

#### Prometheus Configuration

- **`prometheus.enable`**

  Enable Prometheus protocol (Default: `true`)

### Metrics Reporting Configuration

taosAdapter reports metrics to taosKeeper with these parameters:

- **`uploadKeeper.enable`**

  Enable metrics reporting (Default: `true`)

- **`uploadKeeper.url`**

  taosKeeper endpoint (Default: `http://127.0.0.1:6043/adapter_report`)

- **`uploadKeeper.interval`**

  Reporting interval (Default: `15s`)

- **`uploadKeeper.timeout`**

  Request timeout (Default: `5s`)

- **`uploadKeeper.retryTimes`**

  Max retries (Default: `3`)

- **`uploadKeeper.retryInterval`**

  Retry interval (Default: `5s`)

### Environment Variables

Configuration Parameters and their corresponding environment variables:

<details>
<summary>Details</summary>

| Configuration Parameter               | Environment Variable                                  |
|:--------------------------------------|:------------------------------------------------------|
| `collectd.db`                         | `TAOS*ADAPTER*COLLECTD_DB`                            |
| `collectd.enable`                     | `TAOS*ADAPTER*COLLECTD_ENABLE`                        |
| `collectd.password`                   | `TAOS*ADAPTER*COLLECTD_PASSWORD`                      |
| `collectd.port`                       | `TAOS*ADAPTER*COLLECTD_PORT`                          |
| `collectd.ttl`                        | `TAOS*ADAPTER*COLLECTD_TTL`                           |
| `collectd.user`                       | `TAOS*ADAPTER*COLLECTD_USER`                          |
| `collectd.worker`                     | `TAOS*ADAPTER*COLLECTD_WORKER`                        |
| `cors.allowAllOrigins`                | `TAOS*ADAPTER*CORS*ALLOW*ALL_ORIGINS`                 |
| `cors.allowCredentials`               | `TAOS*ADAPTER*CORS*ALLOW*Credentials`                 |
| `cors.allowHeaders`                   | `TAOS*ADAPTER*ALLOW_HEADERS`                          |
| `cors.allowOrigins`                   | `TAOS*ADAPTER*ALLOW_ORIGINS`                          |
| `cors.allowWebSockets`                | `TAOS*ADAPTER*CORS*ALLOW*WebSockets`                  |
| `cors.exposeHeaders`                  | `TAOS*ADAPTER*Expose_Headers`                         |
| `debug`                               | `TAOS*ADAPTER*DEBUG`                                  |
| `httpCodeServerError`                 | `TAOS*ADAPTER*HTTP*CODE*SERVER_ERROR`                 |
| `influxdb.enable`                     | `TAOS*ADAPTER*INFLUXDB_ENABLE`                        |
| `instanceId`                          | `TAOS*ADAPTER*INSTANCE_ID`                            |
| `log.compress`                        | `TAOS*ADAPTER*LOG_COMPRESS`                           |
| `log.enableRecordHttpSql`             | `TAOS*ADAPTER*LOG*ENABLE*RECORD*HTTP*SQL`             |
| `log.keepDays`                        | `TAOS*ADAPTER*LOG*KEEP*DAYS`                          |
| `log.level`                           | `TAOS*ADAPTER*LOG_LEVEL`                              |
| `log.path`                            | `TAOS*ADAPTER*LOG_PATH`                               |
| `log.reservedDiskSize`                | `TAOS*ADAPTER*LOG*RESERVED*DISK_SIZE`                 |
| `log.rotationCount`                   | `TAOS*ADAPTER*LOG*ROTATION*COUNT`                     |
| `log.rotationSize`                    | `TAOS*ADAPTER*LOG*ROTATION*SIZE`                      |
| `log.rotationTime`                    | `TAOS*ADAPTER*LOG*ROTATION*TIME`                      |
| `log.sqlRotationCount`                | `TAOS*ADAPTER*LOG*SQL*ROTATION_COUNT`                 |
| `log.sqlRotationSize`                 | `TAOS*ADAPTER*LOG*SQL*ROTATION_SIZE`                  |
| `log.sqlRotationTime`                 | `TAOS*ADAPTER*LOG*SQL*ROTATION_TIME`                  |
| `logLevel`                            | `TAOS*ADAPTER*LOG_LEVEL`                              |
| `maxAsyncConcurrentLimit`             | `TAOS*ADAPTER*MAX*ASYNC*CONCURRENT_LIMIT`             |
| `maxSyncConcurrentLimit`              | `TAOS*ADAPTER*MAX*SYNC*CONCURRENT_LIMIT`              |
| `monitor.collectDuration`             | `TAOS*ADAPTER*MONITOR*COLLECT*DURATION`               |
| `monitor.disable`                     | `TAOS*ADAPTER*MONITOR_DISABLE`                        |
| `monitor.identity`                    | `TAOS*ADAPTER*MONITOR_IDENTITY`                       |
| `monitor.incgroup`                    | `TAOS*ADAPTER*MONITOR_INCGROUP`                       |
| `monitor.pauseAllMemoryThreshold`     | `TAOS*ADAPTER*MONITOR*PAUSE*ALL*MEMORY*THRESHOLD`     |
| `monitor.pauseQueryMemoryThreshold`   | `TAOS*ADAPTER*MONITOR*PAUSE*QUERY*MEMORY*THRESHOLD`   |
| `node*exporter.caCertFile`            | `TAOS*ADAPTER*NODE*EXPORTER*CA*CERT_FILE`             |
| `node*exporter.certFile`              | `TAOS*ADAPTER*NODE*EXPORTER*CERT*FILE`                |
| `node*exporter.db`                    | `TAOS*ADAPTER*NODE*EXPORTER_DB`                       |
| `node*exporter.enable`                | `TAOS*ADAPTER*NODE*EXPORTER_ENABLE`                   |
| `node*exporter.gatherDuration`        | `TAOS*ADAPTER*NODE*EXPORTER*GATHER*DURATION`          |
| `node*exporter.httpBearerTokenString` | `TAOS*ADAPTER*NODE*EXPORTER*HTTP*BEARER*TOKEN*STRING` |
| `node*exporter.httpPassword`          | `TAOS*ADAPTER*NODE*EXPORTER*HTTP*PASSWORD`            |
| `node*exporter.httpUsername`          | `TAOS*ADAPTER*NODE*EXPORTER*HTTP*USERNAME`            |
| `node*exporter.insecureSkipVerify`    | `TAOS*ADAPTER*NODE*EXPORTER*INSECURE*SKIP_VERIFY`     |
| `node*exporter.keyFile`               | `TAOS*ADAPTER*NODE*EXPORTER*KEY*FILE`                 |
| `node*exporter.password`              | `TAOS*ADAPTER*NODE*EXPORTER_PASSWORD`                 |
| `node*exporter.responseTimeout`       | `TAOS*ADAPTER*NODE*EXPORTER*RESPONSE*TIMEOUT`         |
| `node*exporter.ttl`                   | `TAOS*ADAPTER*NODE*EXPORTER_TTL`                      |
| `node*exporter.urls`                  | `TAOS*ADAPTER*NODE*EXPORTER_URLS`                     |
| `node*exporter.user`                  | `TAOS*ADAPTER*NODE*EXPORTER_USER`                     |
| `opentsdb.enable`                     | `TAOS*ADAPTER*OPENTSDB_ENABLE`                        |
| `opentsdb*telnet.batchSize`           | `TAOS*ADAPTER*OPENTSDB*TELNET*BATCH*SIZE`             |
| `opentsdb*telnet.dbs`                 | `TAOS*ADAPTER*OPENTSDB*TELNET_DBS`                    |
| `opentsdb*telnet.enable`              | `TAOS*ADAPTER*OPENTSDB*TELNET_ENABLE`                 |
| `opentsdb*telnet.flushInterval`       | `TAOS*ADAPTER*OPENTSDB*TELNET*FLUSH*INTERVAL`         |
| `opentsdb*telnet.maxTCPConnections`   | `TAOS*ADAPTER*OPENTSDB*TELNET*MAX*TCP_CONNECTIONS`    |
| `opentsdb*telnet.password`            | `TAOS*ADAPTER*OPENTSDB*TELNET_PASSWORD`               |
| `opentsdb*telnet.ports`               | `TAOS*ADAPTER*OPENTSDB*TELNET_PORTS`                  |
| `opentsdb*telnet.tcpKeepAlive`        | `TAOS*ADAPTER*OPENTSDB*TELNET*TCP*KEEP_ALIVE`         |
| `opentsdb*telnet.ttl`                 | `TAOS*ADAPTER*OPENTSDB*TELNET_TTL`                    |
| `opentsdb*telnet.user`                | `TAOS*ADAPTER*OPENTSDB*TELNET_USER`                   |
| `pool.idleTimeout`                    | `TAOS*ADAPTER*POOL*IDLE*TIMEOUT`                      |
| `pool.maxConnect`                     | `TAOS*ADAPTER*POOL*MAX*CONNECT`                       |
| `pool.maxIdle`                        | `TAOS*ADAPTER*POOL*MAX*IDLE`                          |
| `pool.maxWait`                        | `TAOS*ADAPTER*POOL*MAX*WAIT`                          |
| `pool.waitTimeout`                    | `TAOS*ADAPTER*POOL*WAIT*TIMEOUT`                      |
| `P`, `port`                           | `TAOS*ADAPTER*PORT`                                   |
| `prometheus.enable`                   | `TAOS*ADAPTER*PROMETHEUS_ENABLE`                      |
| `restfulRowLimit`                     | `TAOS*ADAPTER*RESTFUL*ROW*LIMIT`                      |
| `smlAutoCreateDB`                     | `TAOS*ADAPTER*SML*AUTO*CREATE_DB`                     |
| `statsd.allowPendingMessages`         | `TAOS*ADAPTER*STATSD*ALLOW*PENDING_MESSAGES`          |
| `statsd.db`                           | `TAOS*ADAPTER*STATSD_DB`                              |
| `statsd.deleteCounters`               | `TAOS*ADAPTER*STATSD*DELETE*COUNTERS`                 |
| `statsd.deleteGauges`                 | `TAOS*ADAPTER*STATSD*DELETE*GAUGES`                   |
| `statsd.deleteSets`                   | `TAOS*ADAPTER*STATSD*DELETE*SETS`                     |
| `statsd.deleteTimings`                | `TAOS*ADAPTER*STATSD*DELETE*TIMINGS`                  |
| `statsd.enable`                       | `TAOS*ADAPTER*STATSD_ENABLE`                          |
| `statsd.gatherInterval`               | `TAOS*ADAPTER*STATSD*GATHER*INTERVAL`                 |
| `statsd.maxTCPConnections`            | `TAOS*ADAPTER*STATSD*MAX*TCP_CONNECTIONS`             |
| `statsd.password`                     | `TAOS*ADAPTER*STATSD_PASSWORD`                        |
| `statsd.port`                         | `TAOS*ADAPTER*STATSD_PORT`                            |
| `statsd.protocol`                     | `TAOS*ADAPTER*STATSD_PROTOCOL`                        |
| `statsd.tcpKeepAlive`                 | `TAOS*ADAPTER*STATSD*TCP*KEEP_ALIVE`                  |
| `statsd.ttl`                          | `TAOS*ADAPTER*STATSD_TTL`                             |
| `statsd.user`                         | `TAOS*ADAPTER*STATSD_USER`                            |
| `statsd.worker`                       | `TAOS*ADAPTER*STATSD_WORKER`                          |
| `taosConfigDir`                       | `TAOS*ADAPTER*TAOS*CONFIG*FILE`                       |
| `uploadKeeper.enable`                 | `TAOS*ADAPTER*UPLOAD*KEEPER*ENABLE`                   |
| `uploadKeeper.interval`               | `TAOS*ADAPTER*UPLOAD*KEEPER*INTERVAL`                 |
| `uploadKeeper.retryInterval`          | `TAOS*ADAPTER*UPLOAD*KEEPER*RETRY_INTERVAL`           |
| `uploadKeeper.retryTimes`             | `TAOS*ADAPTER*UPLOAD*KEEPER*RETRY_TIMES`              |
| `uploadKeeper.timeout`                | `TAOS*ADAPTER*UPLOAD*KEEPER*TIMEOUT`                  |
| `uploadKeeper.url`                    | `TAOS*ADAPTER*UPLOAD*KEEPER*URL`                      |

</details>

## Service Management

### Starting/Stopping taosAdapter

On Linux systems, the taosAdapter service is managed by default by systemd. Use the command `systemctl start taosadapter` to start the taosAdapter service. Use the command `systemctl stop taosadapter` to stop the taosAdapter service.

### Upgrading taosAdapter

taosAdapter and TDengine server need to use the same version. Please upgrade taosAdapter by upgrading the TDengine server.
taosAdapter deployed separately from taosd must be upgraded by upgrading the TDengine server on its server.

### Removing taosAdapter

Use the command rmtaos to remove the TDengine server software, including taosAdapter.

## IPv6 Support

Starting from **version 3.3.7.0**, taosAdapter supports IPv6. No additional configuration is required.
taosAdapter automatically detects the system's IPv6 support: when available, it enables IPv6 and simultaneously listens on both IPv4 and IPv6 addresses.

## Monitoring Metrics

Currently, taosAdapter only collects monitoring indicators for RESTful/WebSocket related requests. There are no monitoring indicators for other interfaces.

taosAdapter reports monitoring indicators to taosKeeper, which will be written to the monitoring database by taosKeeper. The default is the `log` database, which can be modified in the taoskeeper configuration file. The following is a detailed introduction to these monitoring indicators.

The `adapter_requests` table records taosAdapter monitoring data:

<details>
<summary>Details</summary>

| field            | type         | is_tag | comment                                   |
|:-----------------|:-------------|:-------|:------------------------------------------|
| ts               | TIMESTAMP    |        | data collection timestamp                 |
| total            | INT UNSIGNED |        | total number of requests                  |
| query            | INT UNSIGNED |        | number of query requests                  |
| write            | INT UNSIGNED |        | number of write requests                  |
| other            | INT UNSIGNED |        | number of other requests                  |
| in_process       | INT UNSIGNED |        | number of requests in process             |
| success          | INT UNSIGNED |        | number of successful requests             |
| fail             | INT UNSIGNED |        | number of failed requests                 |
| query_success    | INT UNSIGNED |        | number of successful query requests       |
| query_fail       | INT UNSIGNED |        | number of failed query requests           |
| write_success    | INT UNSIGNED |        | number of successful write requests       |
| write_fail       | INT UNSIGNED |        | number of failed write requests           |
| other_success    | INT UNSIGNED |        | number of successful other requests       |
| other_fail       | INT UNSIGNED |        | number of failed other requests           |
| query*in*process | INT UNSIGNED |        | number of query requests in process       |
| write*in*process | INT UNSIGNED |        | number of write requests in process       |
| endpoint         | VARCHAR      |        | request endpoint                          |
| req_type         | NCHAR        | tag    | request type: 0 for REST, 1 for WebSocket |

</details>

The `adapter_status` table records the status data of taosAdapter:

<details>
<summary>Details</summary>

| field                       | type      | is\_tag | comment                                                                            |
|:----------------------------|:----------|:--------|:-----------------------------------------------------------------------------------|
| _ts                         | TIMESTAMP |         | data collection timestamp                                                          |
| go*heap*sys                 | DOUBLE    |         | heap memory allocated by Go runtime (bytes)                                        |
| go*heap*inuse               | DOUBLE    |         | heap memory in use by Go runtime (bytes)                                           |
| go*stack*sys                | DOUBLE    |         | stack memory allocated by Go runtime (bytes)                                       |
| go*stack*inuse              | DOUBLE    |         | stack memory in use by Go runtime (bytes)                                          |
| rss                         | DOUBLE    |         | actual physical memory occupied by the process (bytes)                             |
| ws*query*conn               | DOUBLE    |         | current WebSocket connections for `/rest/ws` endpoint                              |
| ws*stmt*conn                | DOUBLE    |         | current WebSocket connections for `/rest/stmt` endpoint                            |
| ws*sml*conn                 | DOUBLE    |         | current WebSocket connections for `/rest/schemaless` endpoint                      |
| ws*ws*conn                  | DOUBLE    |         | current WebSocket connections for `/ws` endpoint                                   |
| ws*tmq*conn                 | DOUBLE    |         | current WebSocket connections for `/rest/tmq` endpoint                             |
| async*c*limit               | DOUBLE    |         | total concurrency limit for the C asynchronous interface                           |
| async*c*inflight            | DOUBLE    |         | current concurrency for the C asynchronous interface                               |
| sync*c*limit                | DOUBLE    |         | total concurrency limit for the C synchronous interface                            |
| sync*c*inflight             | DOUBLE    |         | current concurrency for the C synchronous interface                                |
| `ws*query*conn_inc`         | DOUBLE    |         | New connections on `/rest/ws` interface (Available since v3.3.6.10)                |
| `ws*query*conn_dec`         | DOUBLE    |         | Closed connections on `/rest/ws` interface (Available since v3.3.6.10)             |
| `ws*stmt*conn_inc`          | DOUBLE    |         | New connections on `/rest/stmt` interface (Available since v3.3.6.10)              |
| `ws*stmt*conn_dec`          | DOUBLE    |         | Closed connections on `/rest/stmt` interface (Available since v3.3.6.10)           |
| `ws*sml*conn_inc`           | DOUBLE    |         | New connections on `/rest/schemaless` interface (Available since v3.3.6.10)        |
| `ws*sml*conn_dec`           | DOUBLE    |         | Closed connections on `/rest/schemaless` interface (Available since v3.3.6.10)     |
| `ws*ws*conn_inc`            | DOUBLE    |         | New connections on `/ws` interface (Available since v3.3.6.10)                     |
| `ws*ws*conn_dec`            | DOUBLE    |         | Closed connections on `/ws` interface (Available since v3.3.6.10)                  |
| `ws*tmq*conn_inc`           | DOUBLE    |         | New connections on `/rest/tmq` interface (Available since v3.3.6.10)               |
| `ws*tmq*conn_dec`           | DOUBLE    |         | Closed connections on `/rest/tmq` interface (Available since v3.3.6.10)            |
| `ws*query*sql*result*count` | DOUBLE    |         | Current SQL query results held by `/rest/ws` interface (Available since v3.3.6.10) |
| `ws*stmt*stmt_count`        | DOUBLE    |         | Current stmt objects held by `/rest/stmt` interface (Available since v3.3.6.10)    |
| `ws*ws*sql*result*count`    | DOUBLE    |         | Current SQL query results held by `/ws` interface (Available since v3.3.6.10)      |
| `ws*ws*stmt_count`          | DOUBLE    |         | Current stmt objects held by `/ws` interface (Available since v3.3.6.10)           |
| `ws*ws*stmt2_count`         | DOUBLE    |         | Current stmt2 objects held by `/ws` interface (Available since v3.3.6.10)          |
| endpoint                    | NCHAR     | TAG     | request endpoint                                                                   |

</details>

The `adapter*conn*pool` table records the connection pool monitoring data of taosAdapter:

<details>
<summary>Details</summary>

| field            | type      | is\_tag | comment                                                     |
|:-----------------|:----------|:--------|:------------------------------------------------------------|
| _ts              | TIMESTAMP |         | data collection timestamp                                   |
| conn*pool*total  | DOUBLE    |         | maximum connection limit for the connection pool            |
| conn*pool*in_use | DOUBLE    |         | current number of connections in use in the connection pool |
| endpoint         | NCHAR     | TAG     | request endpoint                                            |
| user             | NCHAR     | TAG     | username to which the connection pool belongs               |

</details>

Starting from version **3.3.6.10**, the `adapter*c*interface` table has been added to record taosAdapter C interface call metrics:

<details>
<summary>Details</summary>

| field                                               | type      | is\_tag | comment                                                  |
|:----------------------------------------------------|:----------|:--------|:---------------------------------------------------------|
| _ts                                                 | TIMESTAMP |         | Data collection timestamp                                |
| taos*connect*total                                  | DOUBLE    |         | Count of total connection attempts                       |
| taos*connect*success                                | DOUBLE    |         | Count of successful connections                          |
| taos*connect*fail                                   | DOUBLE    |         | Count of failed connections                              |
| taos*close*total                                    | DOUBLE    |         | Count of total close attempts                            |
| taos*close*success                                  | DOUBLE    |         | Count of successful closes                               |
| taos*schemaless*insert_total                        | DOUBLE    |         | Count of schemaless insert operations                    |
| taos*schemaless*insert_success                      | DOUBLE    |         | Count of successful schemaless inserts                   |
| taos*schemaless*insert_fail                         | DOUBLE    |         | Count of failed schemaless inserts                       |
| taos*schemaless*free*result*total                   | DOUBLE    |         | Count of schemaless result set releases                  |
| taos*schemaless*free*result*success                 | DOUBLE    |         | Count of successful schemaless result set releases       |
| taos*query*total                                    | DOUBLE    |         | Count of synchronous SQL executions                      |
| taos*query*success                                  | DOUBLE    |         | Count of successful synchronous SQL executions           |
| taos*query*fail                                     | DOUBLE    |         | Count of failed synchronous SQL executions               |
| taos*query*free*result*total                        | DOUBLE    |         | Count of synchronous SQL result set releases             |
| taos*query*free*result*success                      | DOUBLE    |         | Count of successful synchronous SQL result set releases  |
| taos*query*a_with*reqid*total                       | DOUBLE    |         | Count of async SQL with request ID                       |
| taos*query*a_with*reqid*success                     | DOUBLE    |         | Count of successful async SQL with request ID            |
| taos*query*a_with*reqid*callback_total              | DOUBLE    |         | Count of async SQL callbacks with request ID             |
| taos*query*a_with*reqid*callback_success            | DOUBLE    |         | Count of successful async SQL callbacks with request ID  |
| taos*query*a_with*reqid*callback_fail               | DOUBLE    |         | Count of failed async SQL callbacks with request ID      |
| taos*query*a_free*result*total                      | DOUBLE    |         | Count of async SQL result set releases                   |
| taos*query*a_free*result*success                    | DOUBLE    |         | Count of successful async SQL result set releases        |
| tmq*consumer*poll*result*total                      | DOUBLE    |         | Count of consumer polls with data                        |
| tmq*free*result_total                               | DOUBLE    |         | Count of TMQ data releases                               |
| tmq*free*result_success                             | DOUBLE    |         | Count of successful TMQ data releases                    |
| taos*stmt2*init_total                               | DOUBLE    |         | Count of stmt2 initializations                           |
| taos*stmt2*init_success                             | DOUBLE    |         | Count of successful stmt2 initializations                |
| taos*stmt2*init_fail                                | DOUBLE    |         | Count of failed stmt2 initializations                    |
| taos*stmt2*close_total                              | DOUBLE    |         | Count of stmt2 closes                                    |
| taos*stmt2*close_success                            | DOUBLE    |         | Count of successful stmt2 closes                         |
| taos*stmt2*close_fail                               | DOUBLE    |         | Count of failed stmt2 closes                             |
| taos*stmt2*get*fields*total                         | DOUBLE    |         | Count of stmt2 field fetches                             |
| taos*stmt2*get*fields*success                       | DOUBLE    |         | Count of successful stmt2 field fetches                  |
| taos*stmt2*get*fields*fail                          | DOUBLE    |         | Count of failed stmt2 field fetches                      |
| taos*stmt2*free*fields*total                        | DOUBLE    |         | Count of stmt2 field releases                            |
| taos*stmt2*free*fields*success                      | DOUBLE    |         | Count of successful stmt2 field releases                 |
| taos*stmt*init*with*reqid_total                     | DOUBLE    |         | Count of stmt initializations with request ID            |
| taos*stmt*init*with*reqid_success                   | DOUBLE    |         | Count of successful stmt initializations with request ID |
| taos*stmt*init*with*reqid_fail                      | DOUBLE    |         | Count of failed stmt initializations with request ID     |
| taos*stmt*close_total                               | DOUBLE    |         | Count of stmt closes                                     |
| taos*stmt*close_success                             | DOUBLE    |         | Count of successful stmt closes                          |
| taos*stmt*close_fail                                | DOUBLE    |         | Count of failed stmt closes                              |
| taos*stmt*get*tag*fields_total                      | DOUBLE    |         | Count of stmt tag field fetches                          |
| taos*stmt*get*tag*fields_success                    | DOUBLE    |         | Count of successful stmt tag field fetches               |
| taos*stmt*get*tag*fields_fail                       | DOUBLE    |         | Count of failed stmt tag field fetches                   |
| taos*stmt*get*col*fields_total                      | DOUBLE    |         | Count of stmt column field fetches                       |
| taos*stmt*get*col*fields_success                    | DOUBLE    |         | Count of successful stmt column field fetches            |
| taos*stmt*get*col*fields_fail                       | DOUBLE    |         | Count of failed stmt column field fetches                |
| taos*stmt*reclaim*fields*total                      | DOUBLE    |         | Count of stmt field releases                             |
| taos*stmt*reclaim*fields*success                    | DOUBLE    |         | Count of successful stmt field releases                  |
| tmq*get*json*meta*total                             | DOUBLE    |         | Count of TMQ JSON metadata fetches                       |
| tmq*get*json*meta*success                           | DOUBLE    |         | Count of successful TMQ JSON metadata fetches            |
| tmq*free*json*meta*total                            | DOUBLE    |         | Count of TMQ JSON metadata releases                      |
| tmq*free*json*meta*success                          | DOUBLE    |         | Count of successful TMQ JSON metadata releases           |
| taos*fetch*whitelist*a*total                        | DOUBLE    |         | Count of async whitelist fetches                         |
| taos*fetch*whitelist*a*success                      | DOUBLE    |         | Count of successful async whitelist fetches              |
| taos*fetch*whitelist*a*callback_total               | DOUBLE    |         | Count of async whitelist callbacks                       |
| taos*fetch*whitelist*a*callback_success             | DOUBLE    |         | Count of successful async whitelist callbacks            |
| taos*fetch*whitelist*a*callback_fail                | DOUBLE    |         | Count of failed async whitelist callbacks                |
| taos*fetch*rows*a*total                             | DOUBLE    |         | Count of async row fetches                               |
| taos*fetch*rows*a*success                           | DOUBLE    |         | Count of successful async row fetches                    |
| taos*fetch*rows*a*callback_total                    | DOUBLE    |         | Count of async row callbacks                             |
| taos*fetch*rows*a*callback_success                  | DOUBLE    |         | Count of successful async row callbacks                  |
| taos*fetch*rows*a*callback_fail                     | DOUBLE    |         | Count of failed async row callbacks                      |
| taos*fetch*raw*block*a_total                        | DOUBLE    |         | Count of async raw block fetches                         |
| taos*fetch*raw*block*a_success                      | DOUBLE    |         | Count of successful async raw block fetches              |
| taos*fetch*raw*block*a_callback_total               | DOUBLE    |         | Count of async raw block callbacks                       |
| taos*fetch*raw*block*a_callback_success             | DOUBLE    |         | Count of successful async raw block callbacks            |
| taos*fetch*raw*block*a_callback_fail                | DOUBLE    |         | Count of failed async raw block callbacks                |
| tmq*get*raw_total                                   | DOUBLE    |         | Count of raw data fetches                                |
| tmq*get*raw_success                                 | DOUBLE    |         | Count of successful raw data fetches                     |
| tmq*get*raw_fail                                    | DOUBLE    |         | Count of failed raw data fetches                         |
| tmq*free*raw_total                                  | DOUBLE    |         | Count of raw data releases                               |
| tmq*free*raw_success                                | DOUBLE    |         | Count of successful raw data releases                    |
| tmq*consumer*new_total                              | DOUBLE    |         | Count of new consumer creations                          |
| tmq*consumer*new_success                            | DOUBLE    |         | Count of successful new consumer creations               |
| tmq*consumer*new_fail                               | DOUBLE    |         | Count of failed new consumer creations                   |
| tmq*consumer*close_total                            | DOUBLE    |         | Count of consumer closes                                 |
| tmq*consumer*close_success                          | DOUBLE    |         | Count of successful consumer closes                      |
| tmq*consumer*close_fail                             | DOUBLE    |         | Count of failed consumer closes                          |
| tmq*subscribe*total                                 | DOUBLE    |         | Count of topic subscriptions                             |
| tmq*subscribe*success                               | DOUBLE    |         | Count of successful topic subscriptions                  |
| tmq*subscribe*fail                                  | DOUBLE    |         | Count of failed topic subscriptions                      |
| tmq*unsubscribe*total                               | DOUBLE    |         | Count of unsubscriptions                                 |
| tmq*unsubscribe*success                             | DOUBLE    |         | Count of successful unsubscriptions                      |
| tmq*unsubscribe*fail                                | DOUBLE    |         | Count of failed unsubscriptions                          |
| tmq*list*new_total                                  | DOUBLE    |         | Count of new topic list creations                        |
| tmq*list*new_success                                | DOUBLE    |         | Count of successful new topic list creations             |
| tmq*list*new_fail                                   | DOUBLE    |         | Count of failed new topic list creations                 |
| tmq*list*destroy_total                              | DOUBLE    |         | Count of topic list destructions                         |
| tmq*list*destroy_success                            | DOUBLE    |         | Count of successful topic list destructions              |
| tmq*conf*new_total                                  | DOUBLE    |         | Count of TMQ new config creations                        |
| tmq*conf*new_success                                | DOUBLE    |         | Count of successful TMQ new config creations             |
| tmq*conf*new_fail                                   | DOUBLE    |         | Count of failed TMQ new config creations                 |
| tmq*conf*destroy_total                              | DOUBLE    |         | Count of TMQ config destructions                         |
| tmq*conf*destroy_success                            | DOUBLE    |         | Count of successful TMQ config destructions              |
| taos*stmt2*prepare_total                            | DOUBLE    |         | Count of stmt2 prepares                                  |
| taos*stmt2*prepare_success                          | DOUBLE    |         | Count of successful stmt2 prepares                       |
| taos*stmt2*prepare_fail                             | DOUBLE    |         | Count of failed stmt2 prepares                           |
| taos*stmt2*is*insert*total                          | DOUBLE    |         | Count of insert checks                                   |
| taos*stmt2*is*insert*success                        | DOUBLE    |         | Count of successful insert checks                        |
| taos*stmt2*is*insert*fail                           | DOUBLE    |         | Count of failed insert checks                            |
| taos*stmt2*bind*param*total                         | DOUBLE    |         | Count of stmt2 parameter bindings                        |
| taos*stmt2*bind*param*success                       | DOUBLE    |         | Count of successful stmt2 parameter bindings             |
| taos*stmt2*bind*param*fail                          | DOUBLE    |         | Count of failed stmt2 parameter bindings                 |
| taos*stmt2*exec_total                               | DOUBLE    |         | Count of stmt2 executions                                |
| taos*stmt2*exec_success                             | DOUBLE    |         | Count of successful stmt2 executions                     |
| taos*stmt2*exec_fail                                | DOUBLE    |         | Count of failed stmt2 executions                         |
| taos*stmt2*error_total                              | DOUBLE    |         | Count of stmt2 error checks                              |
| taos*stmt2*error_success                            | DOUBLE    |         | Count of successful stmt2 error checks                   |
| taos*fetch*row_total                                | DOUBLE    |         | Count of sync row fetches                                |
| taos*fetch*row_success                              | DOUBLE    |         | Count of successful sync row fetches                     |
| taos*is*update*query*total                          | DOUBLE    |         | Count of update statement checks                         |
| taos*is*update*query*success                        | DOUBLE    |         | Count of successful update statement checks              |
| taos*affected*rows_total                            | DOUBLE    |         | Count of SQL affected rows fetches                       |
| taos*affected*rows_success                          | DOUBLE    |         | Count of successful SQL affected rows fetches            |
| taos*num*fields_total                               | DOUBLE    |         | Count of field count fetches                             |
| taos*num*fields_success                             | DOUBLE    |         | Count of successful field count fetches                  |
| taos*fetch*fields*e*total                           | DOUBLE    |         | Count of extended field info fetches                     |
| taos*fetch*fields*e*success                         | DOUBLE    |         | Count of successful extended field info fetches          |
| taos*fetch*fields*e*fail                            | DOUBLE    |         | Count of failed extended field info fetches              |
| taos*result*precision_total                         | DOUBLE    |         | Count of precision fetches                               |
| taos*result*precision_success                       | DOUBLE    |         | Count of successful precision fetches                    |
| taos*get*raw*block*total                            | DOUBLE    |         | Count of raw block fetches                               |
| taos*get*raw*block*success                          | DOUBLE    |         | Count of successful raw block fetches                    |
| taos*fetch*raw*block*total                          | DOUBLE    |         | Count of raw block pulls                                 |
| taos*fetch*raw*block*success                        | DOUBLE    |         | Count of successful raw block pulls                      |
| taos*fetch*raw*block*fail                           | DOUBLE    |         | Count of failed raw block pulls                          |
| taos*fetch*lengths_total                            | DOUBLE    |         | Count of field length fetches                            |
| taos*fetch*lengths_success                          | DOUBLE    |         | Count of successful field length fetches                 |
| taos*write*raw*block*with*reqid*total               | DOUBLE    |         | Count of request ID raw block writes                     |
| taos*write*raw*block*with*reqid*success             | DOUBLE    |         | Count of successful request ID raw block writes          |
| taos*write*raw*block*with*reqid*fail                | DOUBLE    |         | Count of failed request ID raw block writes              |
| taos*write*raw*block*with*fields*with*reqid*total   | DOUBLE    |         | Count of request ID field raw block writes               |
| taos*write*raw*block*with*fields*with*reqid*success | DOUBLE    |         | Count of successful request ID field raw block writes    |
| taos*write*raw*block*with*fields*with*reqid*fail    | DOUBLE    |         | Count of failed request ID field raw block writes        |
| tmq*write*raw_total                                 | DOUBLE    |         | Count of TMQ raw data writes                             |
| tmq*write*raw_success                               | DOUBLE    |         | Count of successful TMQ raw data writes                  |
| tmq*write*raw_fail                                  | DOUBLE    |         | Count of failed TMQ raw data writes                      |
| taos*stmt*prepare_total                             | DOUBLE    |         | Count of stmt prepares                                   |
| taos*stmt*prepare_success                           | DOUBLE    |         | Count of successful stmt prepares                        |
| taos*stmt*prepare_fail                              | DOUBLE    |         | Count of failed stmt prepares                            |
| taos*stmt*is*insert*total                           | DOUBLE    |         | Count of stmt insert checks                              |
| taos*stmt*is*insert*success                         | DOUBLE    |         | Count of successful stmt insert checks                   |
| taos*stmt*is*insert*fail                            | DOUBLE    |         | Count of failed stmt insert checks                       |
| taos*stmt*set*tbname*total                          | DOUBLE    |         | Count of stmt table name sets                            |
| taos*stmt*set*tbname*success                        | DOUBLE    |         | Count of successful stmt table name sets                 |
| taos*stmt*set*tbname*fail                           | DOUBLE    |         | Count of failed stmt table name sets                     |
| taos*stmt*set*tags*total                            | DOUBLE    |         | Count of stmt tag sets                                   |
| taos*stmt*set*tags*success                          | DOUBLE    |         | Count of successful stmt tag sets                        |
| taos*stmt*set*tags*fail                             | DOUBLE    |         | Count of failed stmt tag sets                            |
| taos*stmt*bind*param*batch_total                    | DOUBLE    |         | Count of stmt batch parameter bindings                   |
| taos*stmt*bind*param*batch_success                  | DOUBLE    |         | Count of successful stmt batch parameter bindings        |
| taos*stmt*bind*param*batch_fail                     | DOUBLE    |         | Count of failed stmt batch parameter bindings            |
| taos*stmt*add*batch*total                           | DOUBLE    |         | Count of stmt batch additions                            |
| taos*stmt*add*batch*success                         | DOUBLE    |         | Count of successful stmt batch additions                 |
| taos*stmt*add*batch*fail                            | DOUBLE    |         | Count of failed stmt batch additions                     |
| taos*stmt*execute_total                             | DOUBLE    |         | Count of stmt executions                                 |
| taos*stmt*execute_success                           | DOUBLE    |         | Count of successful stmt executions                      |
| taos*stmt*execute_fail                              | DOUBLE    |         | Count of failed stmt executions                          |
| taos*stmt*num*params*total                          | DOUBLE    |         | Count of stmt parameter count fetches                    |
| taos*stmt*num*params*success                        | DOUBLE    |         | Count of successful stmt parameter count fetches         |
| taos*stmt*num*params*fail                           | DOUBLE    |         | Count of failed stmt parameter count fetches             |
| taos*stmt*get*param*total                           | DOUBLE    |         | Count of stmt parameter fetches                          |
| taos*stmt*get*param*success                         | DOUBLE    |         | Count of successful stmt parameter fetches               |
| taos*stmt*get*param*fail                            | DOUBLE    |         | Count of failed stmt parameter fetches                   |
| taos*stmt*errstr_total                              | DOUBLE    |         | Count of stmt error info fetches                         |
| taos*stmt*errstr_success                            | DOUBLE    |         | Count of successful stmt error info fetches              |
| taos*stmt*affected*rows*once_total                  | DOUBLE    |         | Count of stmt affected rows fetches                      |
| taos*stmt*affected*rows*once_success                | DOUBLE    |         | Count of successful stmt affected rows fetches           |
| taos*stmt*use*result*total                          | DOUBLE    |         | Count of stmt result set uses                            |
| taos*stmt*use*result*success                        | DOUBLE    |         | Count of successful stmt result set uses                 |
| taos*stmt*use*result*fail                           | DOUBLE    |         | Count of failed stmt result set uses                     |
| taos*select*db_total                                | DOUBLE    |         | Count of database selections                             |
| taos*select*db_success                              | DOUBLE    |         | Count of successful database selections                  |
| taos*select*db_fail                                 | DOUBLE    |         | Count of failed database selections                      |
| taos*get*tables*vgId*total                          | DOUBLE    |         | Count of table vgroup ID fetches                         |
| taos*get*tables*vgId*success                        | DOUBLE    |         | Count of successful table vgroup ID fetches              |
| taos*get*tables*vgId*fail                           | DOUBLE    |         | Count of failed table vgroup ID fetches                  |
| taos*options*connection_total                       | DOUBLE    |         | Count of connection option sets                          |
| taos*options*connection_success                     | DOUBLE    |         | Count of successful connection option sets               |
| taos*options*connection_fail                        | DOUBLE    |         | Count of failed connection option sets                   |
| taos*validate*sql_total                             | DOUBLE    |         | Count of SQL validations                                 |
| taos*validate*sql_success                           | DOUBLE    |         | Count of successful SQL validations                      |
| taos*validate*sql_fail                              | DOUBLE    |         | Count of failed SQL validations                          |
| taos*check*server*status*total                      | DOUBLE    |         | Count of server status checks                            |
| taos*check*server*status*success                    | DOUBLE    |         | Count of successful server status checks                 |
| taos*get*current*db*total                           | DOUBLE    |         | Count of current database fetches                        |
| taos*get*current*db*success                         | DOUBLE    |         | Count of successful current database fetches             |
| taos*get*current*db*fail                            | DOUBLE    |         | Count of failed current database fetches                 |
| taos*get*server*info*total                          | DOUBLE    |         | Count of server info fetches                             |
| taos*get*server*info*success                        | DOUBLE    |         | Count of successful server info fetches                  |
| taos*options*total                                  | DOUBLE    |         | Count of option sets                                     |
| taos*options*success                                | DOUBLE    |         | Count of successful option sets                          |
| taos*options*fail                                   | DOUBLE    |         | Count of failed option sets                              |
| taos*set*conn*mode*total                            | DOUBLE    |         | Count of connection mode sets                            |
| taos*set*conn*mode*success                          | DOUBLE    |         | Count of successful connection mode sets                 |
| taos*set*conn*mode*fail                             | DOUBLE    |         | Count of failed connection mode sets                     |
| taos*reset*current*db*total                         | DOUBLE    |         | Count of current database resets                         |
| taos*reset*current*db*success                       | DOUBLE    |         | Count of successful current database resets              |
| taos*set*notify*cb*total                            | DOUBLE    |         | Count of notification callback sets                      |
| taos*set*notify*cb*success                          | DOUBLE    |         | Count of successful notification callback sets           |
| taos*set*notify*cb*fail                             | DOUBLE    |         | Count of failed notification callback sets               |
| taos*errno*total                                    | DOUBLE    |         | Count of error code fetches                              |
| taos*errno*success                                  | DOUBLE    |         | Count of successful error code fetches                   |
| taos*errstr*total                                   | DOUBLE    |         | Count of error message fetches                           |
| taos*errstr*success                                 | DOUBLE    |         | Count of successful error message fetches                |
| tmq*consumer*poll_total                             | DOUBLE    |         | Count of TMQ consumer polls                              |
| tmq*consumer*poll_success                           | DOUBLE    |         | Count of successful TMQ consumer polls                   |
| tmq*consumer*poll_fail                              | DOUBLE    |         | Count of failed TMQ consumer polls                       |
| tmq*subscription*total                              | DOUBLE    |         | Count of TMQ subscription info fetches                   |
| tmq*subscription*success                            | DOUBLE    |         | Count of successful TMQ subscription info fetches        |
| tmq*subscription*fail                               | DOUBLE    |         | Count of failed TMQ subscription info fetches            |
| tmq*list*append_total                               | DOUBLE    |         | Count of TMQ list appends                                |
| tmq*list*append_success                             | DOUBLE    |         | Count of successful TMQ list appends                     |
| tmq*list*append_fail                                | DOUBLE    |         | Count of failed TMQ list appends                         |
| tmq*list*get*size*total                             | DOUBLE    |         | Count of TMQ list size fetches                           |
| tmq*list*get*size*success                           | DOUBLE    |         | Count of successful TMQ list size fetches                |
| tmq*err2str*total                                   | DOUBLE    |         | Count of TMQ error code to string conversions            |
| tmq*err2str*success                                 | DOUBLE    |         | Count of successful TMQ error code to string conversions |
| tmq*conf*set_total                                  | DOUBLE    |         | Count of TMQ config sets                                 |
| tmq*conf*set_success                                | DOUBLE    |         | Count of successful TMQ config sets                      |
| tmq*conf*set_fail                                   | DOUBLE    |         | Count of failed TMQ config sets                          |
| tmq*get*res*type*total                              | DOUBLE    |         | Count of TMQ resource type fetches                       |
| tmq*get*res*type*success                            | DOUBLE    |         | Count of successful TMQ resource type fetches            |
| tmq*get*topic*name*total                            | DOUBLE    |         | Count of TMQ topic name fetches                          |
| tmq*get*topic*name*success                          | DOUBLE    |         | Count of successful TMQ topic name fetches               |
| tmq*get*vgroup*id*total                             | DOUBLE    |         | Count of TMQ vgroup ID fetches                           |
| tmq*get*vgroup*id*success                           | DOUBLE    |         | Count of successful TMQ vgroup ID fetches                |
| tmq*get*vgroup*offset*total                         | DOUBLE    |         | Count of TMQ vgroup offset fetches                       |
| tmq*get*vgroup*offset*success                       | DOUBLE    |         | Count of successful TMQ vgroup offset fetches            |
| tmq*get*db*name*total                               | DOUBLE    |         | Count of TMQ database name fetches                       |
| tmq*get*db*name*success                             | DOUBLE    |         | Count of successful TMQ database name fetches            |
| tmq*get*table*name*total                            | DOUBLE    |         | Count of TMQ table name fetches                          |
| tmq*get*table*name*success                          | DOUBLE    |         | Count of successful TMQ table name fetches               |
| tmq*get*connect_total                               | DOUBLE    |         | Count of TMQ connection fetches                          |
| tmq*get*connect_success                             | DOUBLE    |         | Count of successful TMQ connection fetches               |
| tmq*commit*sync_total                               | DOUBLE    |         | Count of TMQ sync commits                                |
| tmq*commit*sync_success                             | DOUBLE    |         | Count of successful TMQ sync commits                     |
| tmq*commit*sync_fail                                | DOUBLE    |         | Count of failed TMQ sync commits                         |
| tmq*fetch*raw*block*total                           | DOUBLE    |         | Count of TMQ raw block fetches                           |
| tmq*fetch*raw*block*success                         | DOUBLE    |         | Count of successful TMQ raw block fetches                |
| tmq*fetch*raw*block*fail                            | DOUBLE    |         | Count of failed TMQ raw block fetches                    |
| tmq*get*topic*assignment*total                      | DOUBLE    |         | Count of TMQ topic assignment fetches                    |
| tmq*get*topic*assignment*success                    | DOUBLE    |         | Count of successful TMQ topic assignment fetches         |
| tmq*get*topic*assignment*fail                       | DOUBLE    |         | Count of failed TMQ topic assignment fetches             |
| tmq*offset*seek_total                               | DOUBLE    |         | Count of TMQ offset seeks                                |
| tmq*offset*seek_success                             | DOUBLE    |         | Count of successful TMQ offset seeks                     |
| tmq*offset*seek_fail                                | DOUBLE    |         | Count of failed TMQ offset seeks                         |
| tmq*committed*total                                 | DOUBLE    |         | Count of TMQ committed offset fetches                    |
| tmq*committed*success                               | DOUBLE    |         | Count of successful TMQ committed offset fetches         |
| tmq*commit*offset*sync*fail                         | DOUBLE    |         | Count of failed TMQ sync offset commits                  |
| tmq*position*total                                  | DOUBLE    |         | Count of TMQ current position fetches                    |
| tmq*position*success                                | DOUBLE    |         | Count of successful TMQ current position fetches         |
| tmq*commit*offset*sync*total                        | DOUBLE    |         | Count of TMQ sync offset commits                         |
| tmq*commit*offset*sync*success                      | DOUBLE    |         | Count of successful TMQ sync offset commits              |
| endpoint                                            | NCHAR     | TAG     | Request endpoint                                         |

</details>

## Changes after upgrading httpd to taosAdapter

In TDengine server version 2.2.x.x or earlier, the taosd process included an embedded HTTP service(httpd). As mentioned earlier, taosAdapter is a standalone software managed by systemd, having its own process. Moreover, there are some differences in configuration parameters and behaviors between the two, as shown in the table below:

| **#** | **embedded httpd**  | **taosAdapter**                                            | **comment**                                                                                                                                                                                                                                        |
|-------|---------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1     | httpEnableRecordSql | --logLevel=debug                                           |                                                                                                                                                                                                                                                    |
| 2     | httpMaxThreads      | n/a                                                        | taosAdapter automatically manages the thread pool, this parameter is not needed                                                                                                                                                                    |
| 3     | telegrafUseFieldNum | Please refer to taosAdapter telegraf configuration methods |                                                                                                                                                                                                                                                    |
| 4     | restfulRowLimit     | restfulRowLimit                                            | The embedded httpd defaults to outputting 10240 rows of data, with a maximum allowable value of 102400. taosAdapter also provides restfulRowLimit but does not impose a limit by default. You can configure it according to actual scenario needs. |
| 5     | httpDebugFlag       | Not applicable                                             | httpdDebugFlag does not affect taosAdapter                                                                                                                                                                                                         |
| 6     | httpDBNameMandatory | Not applicable                                             | taosAdapter requires the database name to be specified in the URL                                                                                                                                                                                  |
