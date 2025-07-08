---
title: "taosAdapter 参考手册"
sidebar_label: "taosAdapter"
toc*max*heading_level: 4
---

import Prometheus from "./_prometheus.mdx"
import CollectD from "./_collectd.mdx"
import StatsD from "./_statsd.mdx"
import Icinga2 from "./_icinga2.mdx"
import TCollector from "./_tcollector.mdx"

taosAdapter 是一个 TDengine 的配套工具，是 TDengine 集群和应用程序之间的桥梁和适配器。它提供了一种易于使用和高效的方式来直接从数据收集代理软件（如 Telegraf、StatsD、collectd 等）摄取数据。它还提供了 InfluxDB/OpenTSDB 兼容的数据摄取接口，允许 InfluxDB/OpenTSDB 应用程序无缝移植到 TDengine。
TDengine 的各语言连接器通过 WebSocket 接口与 TDengine 进行通信，因此必须安装 taosAdapter。

架构图如下：

![TDengine Database taosAdapter Architecture](taosAdapter-architecture.webp)

## 功能列表

taosAdapter 提供了以下功能：

- WebSocket 接口：
  支持通过 WebSocket 协议执行 SQL、无模式数据写入、参数绑定和数据订阅功能。
- InfluxDB v1 数据写入：
  [https://docs.influxdata.com/influxdb/v2.0/reference/api/influxdb-1x/write/](https://docs.influxdata.com/influxdb/v2.0/reference/api/influxdb-1x/write/)
- 兼容 OpenTSDB JSON 和 telnet 格式写入：
  - [http://opentsdb.net/docs/build/html/api*http/put.html](http://opentsdb.net/docs/build/html/api*http/put.html)
  - [http://opentsdb.net/docs/build/html/api*telnet/put.html](http://opentsdb.net/docs/build/html/api*telnet/put.html)
- collectd 数据写入：
  collectd 是一个系统统计收集守护程序，请访问 [https://collectd.org/](https://collectd.org/) 了解更多信息。
- StatsD 数据写入：
  StatsD 是一个简单而强大的统计信息汇总的守护程序。请访问 [https://github.com/statsd/statsd](https://github.com/statsd/statsd) 了解更多信息。
- icinga2 OpenTSDB writer 数据写入：
  icinga2 是一个收集检查结果指标和性能数据的软件。请访问 [https://icinga.com/docs/icinga-2/latest/doc/14-features/#opentsdb-writer](https://icinga.com/docs/icinga-2/latest/doc/14-features/#opentsdb-writer) 了解更多信息。
- TCollector 数据写入：
  TCollector 是一个客户端进程，从本地收集器收集数据，并将数据推送到 OpenTSDB。请访问 [http://opentsdb.net/docs/build/html/user*guide/utilities/tcollector.html](http://opentsdb.net/docs/build/html/user*guide/utilities/tcollector.html) 了解更多信息。
- node_exporter 采集写入：
  node*export 是一个机器指标的导出器。请访问 [https://github.com/prometheus/node*exporter](https://github.com/prometheus/node_exporter) 了解更多信息。
- Prometheus remote*read 和 remote*write：
  remote*read 和 remote*write 是 Prometheus 数据读写分离的集群方案。请访问 [https://prometheus.io/blog/2019/10/10/remote-read-meets-streaming/#remote-apis](https://prometheus.io/blog/2019/10/10/remote-read-meets-streaming/#remote-apis) 了解更多信息。
- RESTful 接口：
  [RESTful API](../../connector/rest-api)

### WebSocket 接口

各语言连接器通过 taosAdapter 的 WebSocket 接口，能够实现 SQL 执行、无模式写入、参数绑定和数据订阅功能。参考 [开发指南](../../../develop/connect/#websocket-连接)。

### InfluxDB v1 数据写入

您可以使用任何支持 HTTP 协议的客户端访问 Restful 接口地址 `http://<fqdn>:6041/influxdb/v1/write` 来写入 InfluxDB 兼容格式的数据到 TDengine。

支持 InfluxDB 参数如下：

- `db` 指定 TDengine 使用的数据库名
- `precision` TDengine 使用的时间精度
- `u` TDengine 用户名
- `p` TDengine 密码
- `ttl` 自动创建的子表生命周期，以子表的第一条数据的 TTL 参数为准，不可更新。更多信息请参考 [创建表文档](../../taos-sql/table/#创建表)的 TTL 参数。

注意：目前不支持 InfluxDB 的 token 验证方式，仅支持 Basic 验证和查询参数验证。
示例：

```shell
curl --request POST http://127.0.0.1:6041/influxdb/v1/write?db=test --user "root:taosdata" --data-binary "measurement,host=host1 field1=2i,field2=2.0 1577836800000000000"
```

### OpenTSDB JSON 和 telnet 格式写入

您可以使用任何支持 HTTP 协议的客户端访问 Restful 接口地址 `http://<fqdn>:6041/<APIEndPoint>` 来写入 OpenTSDB 兼容格式的数据到 TDengine。EndPoint 如下：

```text
/opentsdb/v1/put/json/<db>
/opentsdb/v1/put/telnet/<db>
```

### collectd 数据写入

<CollectD />

### StatsD 数据写入

<StatsD />

### icinga2 OpenTSDB writer 数据写入

<Icinga2 />

### TCollector 数据写入

<TCollector />

### node_exporter 采集写入

Prometheus 使用的由 \*NIX 内核暴露的硬件和操作系统指标的输出器

- 启用 taosAdapter 的配置 node_exporter.enable
- 设置 node_exporter 的相关配置
- 重新启动 taosAdapter

### Prometheus remote*read 和 remote*write

<Prometheus />

### RESTful 接口

您可以使用任何支持 HTTP 协议的客户端通过访问 RESTful 接口地址 `http://<fqdn>:6041/rest/sql` 来写入数据到 TDengine 或从 TDengine 中查询数据。细节请参考 [REST API 文档](../../connector/rest-api/)。

## 安装

taosAdapter 是 TDengine 服务端软件 的一部分，如果您使用 TDengine server 您不需要任何额外的步骤来安装 taosAdapter。您可以从 [涛思数据官方网站](https://docs.taosdata.com/releases/tdengine/) 下载 TDengine server 安装包。如果需要将 taosAdapter 分离部署在 TDengine server 之外的服务器上，则应该在该服务器上安装完整的 TDengine 来安装 taosAdapter。如果您需要使用源代码编译生成 taosAdapter，您可以参考 [构建 taosAdapter](https://github.com/taosdata/taosadapter/blob/3.0/BUILD-CN.md) 文档。

安装完成后使用命令 `systemctl start taosadapter` 可以启动 taosAdapter 服务。

## 配置

taosAdapter 支持通过命令行参数、环境变量和配置文件来进行配置。默认配置文件是 /etc/taos/taosadapter.toml，可用过 `-c` 或 `--config` 命令行参数指定配置文件。

命令行参数优先于环境变量优先于配置文件，命令行用法是 arg=val，如 taosadapter -p=30000 --debug=true。

示例配置文件参见 [example/config/taosadapter.toml](https://github.com/taosdata/taosadapter/blob/3.0/example/config/taosadapter.toml)。

### 基础配置

taosAdapter 的基础配置参数如下：

- **`debug`**：是否启用调试模式（pprof）
  - **设置为 `true` 时**：（默认值）启用 go pprof 调试模式，允许使用 `http://<fqdn>:<port>/debug/pprof` 访问调试信息。
  - **设置为 `false` 时**：关闭调试模式，不允许访问调试信息。
- **`instanceId`**：taosAdapter 实例 id，用于区分不同 taosAdapter 的日志，默认值：32。
- **`port`**：taosAdapter 对外提供 HTTP/WebSocket 服务的端口，默认值：6041。
- **`taosConfigDir`**：TDengine 的配置文件目录，默认值：`/etc/taos`。该目录下的 `taos.cfg` 文件将被加载。

从 **3.3.4.0 版本** 开始，taosAdapter 支持设置调用 C 方法并发调用数：

- **`maxAsyncConcurrentLimit`**

  设置 C 异步方法的最大并发调用数（0 表示使用 CPU 核心数）。

- **`maxSyncConcurrentLimit`**

  设置 C 同步方法的最大并发调用数（0 表示使用 CPU 核心数）。

### 跨域配置

使用浏览器进行接口调用时，请根据实际情况设置如下跨域（CORS）参数：

- **`cors.allowAllOrigins`**：是否允许所有来源访问，默认为 `true`。
- **`cors.allowOrigins`**：允许跨域访问的来源列表，支持多个来源，以逗号分隔。
- **`cors.allowHeaders`**：允许跨域访问的请求头列表，支持多个请求头，以逗号分隔。
- **`cors.exposeHeaders`**：允许跨域访问的响应头列表，支持多个响应头，以逗号分隔。
- **`cors.allowCredentials`**：是否允许跨域请求包含用户凭证，如 cookies、HTTP 认证信息或客户端 SSL 证书。
- **`cors.allowWebSockets`**：是否允许 WebSockets 连接。

如果不通过浏览器进行接口调用无需关心这几项配置。

以上配置对以下接口生效：

- RESTful 接口请求
- WebSocket 接口请求
- InfluxDB v1 写接口
- OpenTSDB HTTP 写入接口

关于 CORS 协议细节请参考：[https://www.w3.org/wiki/CORS*Enabled](https://www.w3.org/wiki/CORS*Enabled) 或 [https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS)。

### 连接池配置

taosAdapter 使用连接池管理与 TDengine 的连接，以提高并发性能和资源利用率。连接池配置对以下接口生效，且以下接口共享一个连接池：

- RESTful 接口请求
- InfluxDB v1 写接口
- OpenTSDB JSON 和 telnet 格式写入
- Telegraf 数据写入
- collectd 数据写入
- StatsD 数据写入
- 采集 node_exporter 数据写入
- Prometheus remote*read 和 remote*write

连接池的配置参数如下：

- **`pool.maxConnect`**：连接池允许的最大连接数，默认值为 2 倍 CPU 核心数。建议保持默认设置。
- **`pool.maxIdle`**：连接池中允许的最大空闲连接数，默认与 `pool.maxConnect` 相同。建议保持默认设置。
- **`pool.idleTimeout`**：连接空闲超时时间，默认永不超时。建议保持默认设置。
- **`pool.waitTimeout`**：从连接池获取连接的超时时间，默认设置为 60 秒。如果在超时时间内未能获取连接，将返回 HTTP 状态码 503。该参数从版本 3.3.3.0 开始提供。
- **`pool.maxWait`**：连接池中等待获取连接的请求数上限，默认值为 0，表示不限制。当排队请求数超过此值时，新的请求将返回 HTTP 状态码 503。该参数从版本 3.3.3.0 开始提供。

### HTTP 返回码配置

taosAdapter 通过参数 `httpCodeServerError` 来控制当底层 C 接口返回错误时，是否在 RESTful 接口请求中返回非 200 的 HTTP 状态码。当设置为 `true` 时，taosAdapter 会根据 C 接口返回的错误码映射为相应的 HTTP 状态码。具体映射规则请参考 [HTTP 响应码](../../connector/rest-api/#http-响应码)。

该配置只会影响 **RESTful 接口**。

**参数说明**

- **`httpCodeServerError`**：
  - **设置为 `true` 时**：根据 C 接口返回的错误码映射为相应的 HTTP 状态码。
  - **设置为 `false` 时**：无论 C 接口返回什么错误，始终返回 HTTP 状态码 `200`（默认值）。

### 内存限制配置

taosAdapter 将监测自身运行过程中内存使用率并通过两个阈值进行调节。有效值范围为 1 到 100 的整数，单位为系统物理内存的百分比。

该配置只会影响以下接口：

- RESTful 接口请求
- InfluxDB v1 写接口
- OpenTSDB HTTP 写入接口
- Prometheus remote*read 和 remote*write 接口

**参数说明**

- **`pauseQueryMemoryThreshold`**：
  - 当内存使用超过此阈值时，taosAdapter 将停止处理查询请求。
  - 默认值：`70`（即 70% 的系统物理内存）。
- **`pauseAllMemoryThreshold`**：
  - 当内存使用超过此阈值时，taosAdapter 将停止处理所有请求（包括写入和查询）。
  - 默认值：`80`（即 80% 的系统物理内存）。

当内存使用回落到阈值以下时，taosAdapter 会自动恢复相应功能。

**HTTP 返回内容：**

- **超过 `pauseQueryMemoryThreshold` 时**：
  - HTTP 状态码：`503`
  - 返回内容：`"query memory exceeds threshold"`
- **超过 `pauseAllMemoryThreshold` 时**：
  - HTTP 状态码：`503`
  - 返回内容：`"memory exceeds threshold"`

**状态检查接口：**

可以通过以下接口检查 taosAdapter 的内存状态：
- **正常状态**：`http://<fqdn>:6041/-/ping` 返回 `code 200`。
- **内存超过阈值**：
  - 如果内存超过 `pauseAllMemoryThreshold`，返回 `code 503`。
  - 如果内存超过 `pauseQueryMemoryThreshold`，且请求参数包含 `action=query`，返回 `code 503`。

**相关配置参数：**

- **`monitor.collectDuration`**：内存监控间隔，默认值为 `3s`，环境变量为 `TAOS*MONITOR*COLLECT_DURATION`。
- **`monitor.incgroup`**：是否在容器中运行（容器中运行设置为 `true`），默认值为 `false`，环境变量为 `TAOS*MONITOR*INCGROUP`。
- **`monitor.pauseQueryMemoryThreshold`**：查询请求暂停的内存阈值（百分比），默认值为 `70`，环境变量为 `TAOS*MONITOR*PAUSE*QUERY*MEMORY_THRESHOLD`。
- **`monitor.pauseAllMemoryThreshold`**：查询和写入请求暂停的内存阈值（百分比），默认值为 `80`，环境变量为 `TAOS*MONITOR*PAUSE*ALL*MEMORY_THRESHOLD`。

您可以根据具体项目应用场景和运营策略进行相应调整，并建议使用运营监控软件及时进行系统内存状态监控。负载均衡器也可以通过这个接口检查 taosAdapter 运行状态。

### 无模式写入创建 DB 配置

从 **3.0.4.0 版本** 开始，taosAdapter 提供了参数 `smlAutoCreateDB`，用于控制在 schemaless 协议写入时是否自动创建数据库（DB）。

`smlAutoCreateDB` 参数只会影响以下接口：

- InfluxDB v1 写接口
- OpenTSDB JSON 和 telnet 格式写入
- Telegraf 数据写入
- collectd 数据写入
- StatsD 数据写入
- node_exporter 数据写入

**参数说明**

- **`smlAutoCreateDB`**：
  - **设置为 `true` 时**：在 schemaless 协议写入时，如果目标数据库不存在，taosAdapter 会自动创建该数据库。
  - **设置为 `false` 时**：用户需要手动创建数据库，否则写入会失败（默认值）。

### 结果返回条数配置

taosAdapter 提供了参数 `restfulRowLimit`，用于控制 HTTP 接口返回的结果条数。

`restfulRowLimit` 参数只会影响以下接口的返回结果：

- RESTful 接口
- Prometheus remote_read 接口

**参数说明**

- **`restfulRowLimit`**：
  - **设置为正整数时**：接口返回的结果条数将不超过该值。
  - **设置为 `-1` 时**：接口返回的结果条数无限制（默认值）。

### 日志配置

配置参数如下：

- **`log.path`**

  指定日志存储路径（默认值：`"/var/log/taos"`）。

- **`log.level`**

  设置日志级别（默认值：`"info"`）。

- **`log.keepDays`**

  日志保留天数（正整数，默认值：`30`）。

- **`log.rotationCount`**

  日志文件轮转数量（默认值：`30`）。

- **`log.rotationSize`**

  单个日志文件最大大小（支持 KB/MB/GB 单位，默认值：`"1GB"`）。

- **`log.compress`**

  是否压缩旧日志文件（默认值：`false`）。

- **`log.rotationTime`**

  日志轮转时间（已弃用，固定 24 小时轮转）。

- **`log.reservedDiskSize`**

  为日志目录保留的磁盘空间（支持 KB/MB/GB 单位，默认值：`"1GB"`）。

- **`log.enableRecordHttpSql`**

  是否记录 HTTP SQL 请求（默认值：`false`）。

- **`log.sqlRotationCount`**

  SQL 日志轮转数量（默认值：`2`）。

- **`log.sqlRotationSize`**

  单个 SQL 日志文件最大大小（支持 KB/MB/GB 单位，默认值：`"1GB"`）。

- **`log.sqlRotationTime`**

  SQL 日志轮转时间（默认值：`24h`）。

1. 可以通过设置 --log.level 参数或者环境变量 TAOS*ADAPTER*LOG_LEVEL 来设置 taosAdapter 日志输出详细程度。有效值包括：panic、fatal、error、warn、warning、info、debug 以及 trace。
2. 从 **3.3.5.0 版本** 开始，taosAdapter 支持通过 HTTP 接口动态修改日志级别。用户可以通过发送 HTTP PUT 请求到 /config 接口，动态调整日志级别。该接口的验证方式与 /rest/sql 接口相同，请求体中需传入 JSON 格式的配置项键值对。

以下是通过 curl 命令将日志级别设置为 debug 的示例：

```shell
curl --location --request PUT 'http://127.0.0.1:6041/config' \
-u root:taosdata \
--data '{"log.level": "debug"}'
```

### 第三方数据源配置

#### Collectd 配置参数

- **`collectd.enable`**

  启用或禁用 collectd 协议支持（默认值：`false`）。

- **`collectd.port`**

  指定 collectd 服务监听端口（默认值：`6045`）。

- **`collectd.db`**

  设置 collectd 数据写入的目标数据库名称（默认值：`"collectd"`）。

- **`collectd.user`**

  配置连接数据库使用的用户名（默认值：`"root"`）。

- **`collectd.password`**

  设置连接数据库使用的密码（默认值：`"taosdata"`）。

- **`collectd.ttl`**

  定义 collectd 数据的生存时间（默认值：`0`，表示无超时）。

- **`collectd.worker`**

  配置 collectd 写入工作线程数量（默认值：`10`）。

#### InfluxDB 配置参数

- **`influxdb.enable`**

  启用或禁用 InfluxDB 协议支持（布尔值，默认值：`true`）。

#### node_exporter 配置参数

- **`node_exporter.enable`**

  是否启用 node_exporter 数据采集（默认值：`false`）。

- **`node_exporter.db`**

  指定 node*exporter 数据写入的数据库名称（默认值：`"node*exporter"`）。

- **`node_exporter.urls`**

  配置 node_exporter 服务地址（默认值：`["http://localhost:9100"]`）。

- **`node_exporter.gatherDuration`**

  设置数据采集间隔时间（默认值：`5s`）。

- **`node_exporter.responseTimeout`**

  配置请求超时时间（默认值：`5s`）。

- **`node_exporter.user`**

  设置数据库连接用户名（默认值：`"root"`）。

- **`node_exporter.password`**

  设置数据库连接密码（默认值：`"taosdata"`）。

- **`node_exporter.ttl`**

  配置采集数据的生存时间（默认值：`0`，表示无超时）。

- **`node_exporter.httpUsername`**

  配置 HTTP 基本认证用户名（可选）。

- **`node_exporter.httpPassword`**

  配置 HTTP 基本认证密码（可选）。

- **`node_exporter.httpBearerTokenString`**

  配置 HTTP Bearer Token 认证（可选）。

- **`node_exporter.insecureSkipVerify`**

  是否跳过 SSL 证书验证（默认值：`true`）。

- **`node_exporter.certFile`**

  指定客户端证书文件路径（可选）。

- **`node_exporter.keyFile`**

  指定客户端证书密钥文件路径（可选）。

- **`node_exporter.caCertFile`**

  指定 CA 证书文件路径（可选）。

#### OpenTSDB 配置参数

- **`opentsdb.enable`**

  是否启用 OpenTSDB HTTP 协议支持（默认值：`true`）。

- **`opentsdb_telnet.enable`**

  是否启用 OpenTSDB Telnet 协议支持（警告：无认证机制，默认值：`false`）。

- **`opentsdb_telnet.ports`**

  配置 OpenTSDB Telnet 监听端口（默认值：`[6046,6047,6048,6049]`）。

- **`opentsdb_telnet.dbs`**

  指定 OpenTSDB Telnet 数据写入的数据库（默认值：`["opentsdb*telnet","collectd*tsdb","icinga2*tsdb","tcollector*tsdb"]`）。

- **`opentsdb_telnet.user`**

  设置数据库连接用户名（默认值：`"root"`）。

- **`opentsdb_telnet.password`**

  设置数据库连接密码（默认值：`"taosdata"`）。

- **`opentsdb_telnet.ttl`**

  配置数据生存时间（默认值：`0`，表示无超时）。

- **`opentsdb_telnet.batchSize`**

  设置批量写入大小（默认值：`1`）。

- **`opentsdb_telnet.flushInterval`**

  配置刷新间隔时间（默认值：`0s`）。

- **`opentsdb_telnet.maxTCPConnections`**

  设置最大 TCP 连接数（默认值：`250`）。

- **`opentsdb_telnet.tcpKeepAlive`**

  是否启用 TCP KeepAlive（默认值：`false`）。

#### StatsD 配置参数

- **`statsd.enable`**

  是否启用 StatsD 协议支持（默认值：`false`）。

- **`statsd.port`**

  设置 StatsD 服务监听端口（默认值：`6044`）。

- **`statsd.protocol`**

  指定 StatsD 传输协议（可选：tcp/udp/tcp4/udp4，默认值：`"udp4"`）。

- **`statsd.db`**

  配置 StatsD 数据写入的目标数据库（默认值：`"statsd"`）。

- **`statsd.user`**

  设置数据库连接用户名（默认值：`"root"`）。

- **`statsd.password`**

  设置数据库连接密码（默认值：`"taosdata"`）。

- **`statsd.ttl`**

  配置数据生存时间（默认值：`0`，表示无超时）。

- **`statsd.gatherInterval`**

  设置数据采集间隔（默认值：`5s`）。

- **`statsd.worker`**

  配置写入工作线程数（默认值：`10`）。

- **`statsd.allowPendingMessages`**

  设置允许挂起的消息数量（默认值：`50000`）。

- **`statsd.maxTCPConnections`**

  配置最大 TCP 连接数（默认值：`250`）。

- **`statsd.tcpKeepAlive`**

  是否启用 TCP KeepAlive（默认值：`false`）。

- **`statsd.deleteCounters`**

  是否在采集后删除计数器缓存（默认值：`true`）。

- **`statsd.deleteGauges`**

  是否在采集后删除测量值缓存（默认值：`true`）。

- **`statsd.deleteSets`**

  是否在采集后删除集合缓存（默认值：`true`）。

- **`statsd.deleteTimings`**

  是否在采集后删除计时器缓存（默认值：`true`）。

#### Prometheus 配置参数

- **`prometheus.enable`**

  是否启用 Prometheus 协议支持（默认值：`true`）。

### 上报指标配置

taosAdapter 将指标上报到 taosKeeper 进行统一管理，参数如下：

- **`uploadKeeper.enable`**

  是否启用向 taoKeeper 上报监控指标（默认值：`true`）。

- **`uploadKeeper.url`**

  配置 taosKeeper 服务地址（默认值：`http://127.0.0.1:6043/adapter_report` ）。

- **`uploadKeeper.interval`**

  设置上报间隔时间（默认值：`15s`）。

- **`uploadKeeper.timeout`**

  配置上报超时时间（默认值：`5s`）。

- **`uploadKeeper.retryTimes`**

  设置失败重试次数（默认值：`3`）。

- **`uploadKeeper.retryInterval`**

  配置重试间隔时间（默认值：`5s`）。

### 环境变量

配置项与环境变量对应如下表：

<details>
<summary>详细信息</summary>

| 参数                                    | 环境变量                                                  |
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

## 服务管理

### 启动/停止 taosAdapter

在 Linux 系统上 taosAdapter 服务默认由 systemd 管理。使用命令 `systemctl start taosadapter` 可以启动 taosAdapter 服务。使用命令 `systemctl stop taosadapter` 可以停止 taosAdapter 服务。使用命令 `systemctl status taosadapter` 来检查 taosAdapter 运行状态。

### 升级 taosAdapter

taosAdapter 和 TDengine server 需要使用相同版本。请通过升级 TDengine server 来升级 taosAdapter。
与 taosd 分离部署的 taosAdapter 必须通过升级其所在服务器的 TDengine server 才能得到升级。

### 移除 taosAdapter

使用命令 rmtaos 可以移除包括 taosAdapter 在内的 TDengine server 软件。

## IPv6 支持

taosAdapter 自 **3.3.7.0** 版本起支持 IPv6，用户无需进行任何额外配置。
taosAdapter 将自动检测系统的 IPv6 支持情况，并在系统支持时自动启用 IPv6，且同时监听 IPv4 和 IPv6 地址。

## taosAdapter 监控指标

taosAdapter 目前仅采集 RESTful/WebSocket 相关请求的监控指标，其他接口暂无监控指标。

taosAdapter 将监控指标上报给 taosKeeper，这些监控指标会被 taosKeeper 写入监控数据库，默认是 `log` 库，可以在 taosKeeper 配置文件中修改。以下是这些监控指标的详细介绍。

`adapter_requests` 表记录 taosAdapter 监控数据：

<details>
<summary>详细信息</summary>

| field              | type         | is\_tag | comment                     |
|:-------------------|:-------------|:--------|:----------------------------|
| ts                 | TIMESTAMP    |         | 数据采集时间戳                     |
| total              | INT UNSIGNED |         | 总请求数                        |
| query              | INT UNSIGNED |         | 查询请求数                       |
| write              | INT UNSIGNED |         | 写入请求数                       |
| other              | INT UNSIGNED |         | 其他请求数                       |
| in\_process        | INT UNSIGNED |         | 正在处理请求数                     |
| success            | INT UNSIGNED |         | 成功请求数                       |
| fail               | INT UNSIGNED |         | 失败请求数                       |
| query\_success     | INT UNSIGNED |         | 查询成功请求数                     |
| query\_fail        | INT UNSIGNED |         | 查询失败请求数                     |
| write\_success     | INT UNSIGNED |         | 写入成功请求数                     |
| write\_fail        | INT UNSIGNED |         | 写入失败请求数                     |
| other\_success     | INT UNSIGNED |         | 其他成功请求数                     |
| other\_fail        | INT UNSIGNED |         | 其他失败请求数                     |
| query\*in\*process | INT UNSIGNED |         | 正在处理查询请求数                   |
| write\*in\*process | INT UNSIGNED |         | 正在处理写入请求数                   |
| endpoint           | VARCHAR      |         | 请求端点                        |
| req\_type          | NCHAR        | TAG     | 请求类型：0 为 REST，1 为 WebSocket |

</details>

`adapter_status` 表记录 taosAdapter 状态数据：

<details>
<summary>详细信息</summary>

| field                     | type      | is\_tag | comment                                  |
|:--------------------------|:----------|:--------|:-----------------------------------------|
| _ts                       | TIMESTAMP |         | 数据采集时间戳                                  |
| go*heap*sys               | DOUBLE    |         | Go 运行时系统分配的堆内存大小（字节）                     |
| go*heap*inuse             | DOUBLE    |         | Go 运行时正在使用的堆内存大小（字节）                     |
| go*stack*sys              | DOUBLE    |         | Go 运行时系统分配的栈内存大小（字节）                     |
| go*stack*inuse            | DOUBLE    |         | Go 运行时正在使用的栈内存大小（字节）                     |
| rss                       | DOUBLE    |         | 进程实际占用的物理内存大小（字节）                        |
| ws*query*conn             | DOUBLE    |         | `/rest/ws` 接口当前 WebSocket 连接数            |
| ws*stmt*conn              | DOUBLE    |         | `/rest/stmt` 接口当前 WebSocket 连接数          |
| ws*sml*conn               | DOUBLE    |         | `/rest/schemaless` 接口当前 WebSocket 连接数    |
| ws*ws*conn                | DOUBLE    |         | `/ws` 接口当前 WebSocket 连接数                 |
| ws*tmq*conn               | DOUBLE    |         | `/rest/tmq` 接口当前 WebSocket 连接数           |
| async*c*limit             | DOUBLE    |         | C 同步接口并发限制总数                             |
| async*c*inflight          | DOUBLE    |         | C 同步接口当前并发数                              |
| sync*c*limit              | DOUBLE    |         | C 异步接口并发限制总数                             |
| sync*c*inflight           | DOUBLE    |         | C 异步接口当前并发数                              |
| ws*query*conn_inc         | DOUBLE    |         | /rest/ws 接口新增连接（3.3.6.10 及以上）            |
| ws*query*conn_dec         | DOUBLE    |         | /rest/ws 接口减少连接（3.3.6.10 及以上）            |
| ws*stmt*conn_inc          | DOUBLE    |         | /rest/stmt 接口新增连接（3.3.6.10 及以上）          |
| ws*stmt*conn_dec          | DOUBLE    |         | /rest/stmt 接口减少连接（3.3.6.10 及以上）          |
| ws*sml*conn_inc           | DOUBLE    |         | /rest/schemaless 接口新增连接（3.3.6.10 及以上）    |
| ws*sml*conn_dec           | DOUBLE    |         | /rest/schemaless 接口减少连接（3.3.6.10 及以上）    |
| ws*ws*conn_inc            | DOUBLE    |         | /ws 接口新增连接（3.3.6.10 及以上）                 |
| ws*ws*conn_dec            | DOUBLE    |         | /ws 接口减少连接（3.3.6.10 及以上）                 |
| ws*tmq*conn_inc           | DOUBLE    |         | /rest/tmq 接口新增连接（3.3.6.10 及以上）           |
| ws*tmq*conn_dec           | DOUBLE    |         | /rest/tmq 接口减少连接（3.3.6.10 及以上）           |
| ws*query*sql*result*count | DOUBLE    |         | /rest/ws 接口当前持有 SQL 查询结果数量（3.3.6.10 及以上） |
| ws*stmt*stmt_count        | DOUBLE    |         | /rest/stmt 接口当前持有 stmt 数量（3.3.6.10 及以上）  |
| ws*ws*sql*result*count    | DOUBLE    |         | /ws 接口当前持有 SQL 查询结果数量（3.3.6.10 及以上）      |
| ws*ws*stmt_count          | DOUBLE    |         | /ws 接口当前持有 stmt 数量（3.3.6.10 及以上）         |
| ws*ws*stmt2_count         | DOUBLE    |         | /ws 接口当前持有 stmt2 数量（3.3.6.10 及以上）        |
| endpoint                  | NCHAR     | TAG     | 请求端点                                     |

</details>

`adapter*conn*pool` 表记录 taosAdapter 连接池监控数据：

<details>
<summary>详细信息</summary>

| field            | type      | is\_tag | comment       |
|:-----------------|:----------|:--------|:--------------|
| _ts              | TIMESTAMP |         | 数据采集时间戳       |
| conn*pool*total  | DOUBLE    |         | 连接池的最大连接数限制   |
| conn*pool*in_use | DOUBLE    |         | 连接池当前正在使用的连接数 |
| endpoint         | NCHAR     | TAG     | 请求端点          |
| user             | NCHAR     | TAG     | 连接池所属的用户名     |

</details>

从 **3.3.6.10** 版本开始新增 `adapter*c*interface` 表记录 taosAdapter 调用 C 接口次数数据：

<details>
<summary>详细信息</summary>

| field                                               | type      | is\_tag | comment                |
|:----------------------------------------------------|:----------|:--------|:-----------------------|
| _ts                                                 | TIMESTAMP |         | 数据采集时间戳                |
| taos*connect*total                                  | DOUBLE    |         | 尝试建立连接的总次数             |
| taos*connect*success                                | DOUBLE    |         | 成功建立连接的次数              |
| taos*connect*fail                                   | DOUBLE    |         | 建立连接失败的次数              |
| taos*close*total                                    | DOUBLE    |         | 尝试关闭连接的总次数             |
| taos*close*success                                  | DOUBLE    |         | 成功关闭连接的次数              |
| taos*schemaless*insert_total                        | DOUBLE    |         | schemaless 插入操作的总次数    |
| taos*schemaless*insert_success                      | DOUBLE    |         | schemaless 插入成功的次数     |
| taos*schemaless*insert_fail                         | DOUBLE    |         | schemaless 插入失败的次数     |
| taos*schemaless*free*result*total                   | DOUBLE    |         | schemaless 释放结果集的总次数   |
| taos*schemaless*free*result*success                 | DOUBLE    |         | schemaless 成功释放结果集的次数  |
| taos*query*total                                    | DOUBLE    |         | 执行同步 SQL 的总次数          |
| taos*query*success                                  | DOUBLE    |         | 执行同步 SQL 成功的次数         |
| taos*query*fail                                     | DOUBLE    |         | 执行同步 SQL 失败的次数         |
| taos*query*free*result*total                        | DOUBLE    |         | 释放同步 SQL 结果集的总次数       |
| taos*query*free*result*success                      | DOUBLE    |         | 成功释放同步 SQL 结果集的次数      |
| taos*query*a_with*reqid*total                       | DOUBLE    |         | 带请求 ID 的异步 SQL 总次数     |
| taos*query*a_with*reqid*success                     | DOUBLE    |         | 带请求 ID 的异步 SQL 成功次数    |
| taos*query*a_with*reqid*callback_total              | DOUBLE    |         | 带请求 ID 的异步 SQL 回调总次数   |
| taos*query*a_with*reqid*callback_success            | DOUBLE    |         | 带请求 ID 的异步 SQL 回调成功次数  |
| taos*query*a_with*reqid*callback_fail               | DOUBLE    |         | 带请求 ID 的异步 SQL 回调失败次数  |
| taos*query*a_free*result*total                      | DOUBLE    |         | 异步 SQL 释放结果集的总次数       |
| taos*query*a_free*result*success                    | DOUBLE    |         | 异步 SQL 成功释放结果集的次数      |
| tmq*consumer*poll*result*total                      | DOUBLE    |         | 消费者 poll 有数据的总次数       |
| tmq*free*result_total                               | DOUBLE    |         | 释放 TMQ 数据的总次数          |
| tmq*free*result_success                             | DOUBLE    |         | 成功释放 TMQ 数据的次数         |
| taos*stmt2*init_total                               | DOUBLE    |         | stmt2 初始化的总次数          |
| taos*stmt2*init_success                             | DOUBLE    |         | stmt2 初始化成功的次数         |
| taos*stmt2*init_fail                                | DOUBLE    |         | stmt2 初始化失败的次数         |
| taos*stmt2*close_total                              | DOUBLE    |         | stmt2 关闭的总次数           |
| taos*stmt2*close_success                            | DOUBLE    |         | stmt2 关闭成功的次数          |
| taos*stmt2*close_fail                               | DOUBLE    |         | stmt2 关闭失败的次数          |
| taos*stmt2*get*fields*total                         | DOUBLE    |         | stmt2 获取字段的总次数         |
| taos*stmt2*get*fields*success                       | DOUBLE    |         | stmt2 成功获取字段的次数        |
| taos*stmt2*get*fields*fail                          | DOUBLE    |         | stmt2 获取字段失败的次数        |
| taos*stmt2*free*fields*total                        | DOUBLE    |         | stmt2 释放字段的总次数         |
| taos*stmt2*free*fields*success                      | DOUBLE    |         | stmt2 成功释放字段的次数        |
| taos*stmt*init*with*reqid_total                     | DOUBLE    |         | 带请求 ID 的 stmt 初始化总次数   |
| taos*stmt*init*with*reqid_success                   | DOUBLE    |         | 带请求 ID 的 stmt 初始化成功次数  |
| taos*stmt*init*with*reqid_fail                      | DOUBLE    |         | 带请求 ID 的 stmt 初始化失败次数  |
| taos*stmt*close_total                               | DOUBLE    |         | stmt 关闭的总次数            |
| taos*stmt*close_success                             | DOUBLE    |         | stmt 关闭成功的次数           |
| taos*stmt*close_fail                                | DOUBLE    |         | stmt 关闭失败的次数           |
| taos*stmt*get*tag*fields_total                      | DOUBLE    |         | stmt 获取 tag 字段的总次数     |
| taos*stmt*get*tag*fields_success                    | DOUBLE    |         | stmt 成功获取 tag 字段的次数    |
| taos*stmt*get*tag*fields_fail                       | DOUBLE    |         | stmt 获取 tag 字段失败的次数    |
| taos*stmt*get*col*fields_total                      | DOUBLE    |         | stmt 获取列字段的总次数         |
| taos*stmt*get*col*fields_success                    | DOUBLE    |         | stmt 成功获取列字段的次数        |
| taos*stmt*get*col*fields_fail                       | DOUBLE    |         | stmt 获取列字段失败的次数        |
| taos*stmt*reclaim*fields*total                      | DOUBLE    |         | stmt 释放字段的总次数          |
| taos*stmt*reclaim*fields*success                    | DOUBLE    |         | stmt 成功释放字段的次数         |
| tmq*get*json*meta*total                             | DOUBLE    |         | tmq 获取 JSON 元数据的总次数    |
| tmq*get*json*meta*success                           | DOUBLE    |         | tmq 成功获取 JSON 元数据的次数   |
| tmq*free*json*meta*total                            | DOUBLE    |         | tmq 释放 JSON 元数据的总次数    |
| tmq*free*json*meta*success                          | DOUBLE    |         | tmq 成功释放 JSON 元数据的次数   |
| taos*fetch*whitelist*a*total                        | DOUBLE    |         | 异步获取白名单的总次数            |
| taos*fetch*whitelist*a*success                      | DOUBLE    |         | 异步成功获取白名单的次数           |
| taos*fetch*whitelist*a*callback_total               | DOUBLE    |         | 异步获取白名单回调总次数           |
| taos*fetch*whitelist*a*callback_success             | DOUBLE    |         | 异步成功获取白名单回调次数          |
| taos*fetch*whitelist*a*callback_fail                | DOUBLE    |         | 异步获取白名单回调失败次数          |
| taos*fetch*rows*a*total                             | DOUBLE    |         | 异步获取行的总次数              |
| taos*fetch*rows*a*success                           | DOUBLE    |         | 异步成功获取行的次数             |
| taos*fetch*rows*a*callback_total                    | DOUBLE    |         | 异步获取行回调总次数             |
| taos*fetch*rows*a*callback_success                  | DOUBLE    |         | 异步成功获取行回调次数            |
| taos*fetch*rows*a*callback_fail                     | DOUBLE    |         | 异步获取行回调失败次数            |
| taos*fetch*raw*block*a_total                        | DOUBLE    |         | 异步获取原始块的总次数            |
| taos*fetch*raw*block*a_success                      | DOUBLE    |         | 异步成功获取原始块的次数           |
| taos*fetch*raw*block*a_callback_total               | DOUBLE    |         | 异步获取原始块回调总次数           |
| taos*fetch*raw*block*a_callback_success             | DOUBLE    |         | 异步成功获取原始块回调次数          |
| taos*fetch*raw*block*a_callback_fail                | DOUBLE    |         | 异步获取原始块回调失败次数          |
| tmq*get*raw_total                                   | DOUBLE    |         | 获取原始数据的总次数             |
| tmq*get*raw_success                                 | DOUBLE    |         | 成功获取原始数据的次数            |
| tmq*get*raw_fail                                    | DOUBLE    |         | 获取原始数据失败的次数            |
| tmq*free*raw_total                                  | DOUBLE    |         | 释放原始数据的总次数             |
| tmq*free*raw_success                                | DOUBLE    |         | 成功释放原始数据的次数            |
| tmq*consumer*new_total                              | DOUBLE    |         | 创建新消费者的总次数             |
| tmq*consumer*new_success                            | DOUBLE    |         | 成功创建新消费者的次数            |
| tmq*consumer*new_fail                               | DOUBLE    |         | 创建新消费者失败的次数            |
| tmq*consumer*close_total                            | DOUBLE    |         | 关闭消费者的总次数              |
| tmq*consumer*close_success                          | DOUBLE    |         | 成功关闭消费者的次数             |
| tmq*consumer*close_fail                             | DOUBLE    |         | 关闭消费者失败的次数             |
| tmq*subscribe*total                                 | DOUBLE    |         | 订阅主题的总次数               |
| tmq*subscribe*success                               | DOUBLE    |         | 成功订阅主题的次数              |
| tmq*subscribe*fail                                  | DOUBLE    |         | 订阅主题失败的次数              |
| tmq*unsubscribe*total                               | DOUBLE    |         | 取消订阅的总次数               |
| tmq*unsubscribe*success                             | DOUBLE    |         | 成功取消订阅的次数              |
| tmq*unsubscribe*fail                                | DOUBLE    |         | 取消订阅失败的次数              |
| tmq*list*new_total                                  | DOUBLE    |         | 创建新主题列表的总次数            |
| tmq*list*new_success                                | DOUBLE    |         | 成功创建新主题列表的次数           |
| tmq*list*new_fail                                   | DOUBLE    |         | 创建新主题列表失败的次数           |
| tmq*list*destroy_total                              | DOUBLE    |         | 销毁主题列表的总次数             |
| tmq*list*destroy_success                            | DOUBLE    |         | 成功销毁主题列表的次数            |
| tmq*conf*new_total                                  | DOUBLE    |         | tmq 创建新配置的总次数          |
| tmq*conf*new_success                                | DOUBLE    |         | tmq 成功创建新配置的次数         |
| tmq*conf*new_fail                                   | DOUBLE    |         | tmq 创建新配置失败的次数         |
| tmq*conf*destroy_total                              | DOUBLE    |         | tmq 销毁配置的总次数           |
| tmq*conf*destroy_success                            | DOUBLE    |         | tmq 成功销毁配置的次数          |
| taos*stmt2*prepare_total                            | DOUBLE    |         | stmt2 准备的总次数           |
| taos*stmt2*prepare_success                          | DOUBLE    |         | stmt2 准备成功的次数          |
| taos*stmt2*prepare_fail                             | DOUBLE    |         | stmt2 准备失败的次数          |
| taos*stmt2*is*insert*total                          | DOUBLE    |         | 检查是否为插入的总次数            |
| taos*stmt2*is*insert*success                        | DOUBLE    |         | 成功检查是否为插入的次数           |
| taos*stmt2*is*insert*fail                           | DOUBLE    |         | 检查是否为插入失败的次数           |
| taos*stmt2*bind*param*total                         | DOUBLE    |         | stmt2 绑定参数的总次数         |
| taos*stmt2*bind*param*success                       | DOUBLE    |         | stmt2 成功绑定参数的次数        |
| taos*stmt2*bind*param*fail                          | DOUBLE    |         | stmt2 绑定参数失败的次数        |
| taos*stmt2*exec_total                               | DOUBLE    |         | stmt2 执行的总次数           |
| taos*stmt2*exec_success                             | DOUBLE    |         | stmt2 执行成功的次数          |
| taos*stmt2*exec_fail                                | DOUBLE    |         | stmt2 执行失败的次数          |
| taos*stmt2*error_total                              | DOUBLE    |         | stmt2 错误检查的总次数         |
| taos*stmt2*error_success                            | DOUBLE    |         | stmt2 成功检查错误的次数        |
| taos*fetch*row_total                                | DOUBLE    |         | 同步获取行的总次数              |
| taos*fetch*row_success                              | DOUBLE    |         | 成功同步获取行的次数             |
| taos*is*update*query*total                          | DOUBLE    |         | 检查是否为更新语句的总次数          |
| taos*is*update*query*success                        | DOUBLE    |         | 成功检查是否为更新语句的次数         |
| taos*affected*rows_total                            | DOUBLE    |         | SQL 获取影响行数的总次数         |
| taos*affected*rows_success                          | DOUBLE    |         | SQL 成功获取影响行数的次数        |
| taos*num*fields_total                               | DOUBLE    |         | 获取字段数量的总次数             |
| taos*num*fields_success                             | DOUBLE    |         | 成功获取字段数量的次数            |
| taos*fetch*fields*e*total                           | DOUBLE    |         | 获取字段信息的扩展总次数           |
| taos*fetch*fields*e*success                         | DOUBLE    |         | 成功获取字段信息的扩展次数          |
| taos*fetch*fields*e*fail                            | DOUBLE    |         | 获取字段信息的扩展失败次数          |
| taos*result*precision_total                         | DOUBLE    |         | 获取结果精度的总次数             |
| taos*result*precision_success                       | DOUBLE    |         | 成功获取结果精度的次数            |
| taos*get*raw*block*total                            | DOUBLE    |         | 获取原始块的总次数              |
| taos*get*raw*block*success                          | DOUBLE    |         | 成功获取原始块的次数             |
| taos*fetch*raw*block*total                          | DOUBLE    |         | 拉取原始块的总次数              |
| taos*fetch*raw*block*success                        | DOUBLE    |         | 成功拉取原始块的次数             |
| taos*fetch*raw*block*fail                           | DOUBLE    |         | 拉取原始块失败的次数             |
| taos*fetch*lengths_total                            | DOUBLE    |         | 获取字段长度的总次数             |
| taos*fetch*lengths_success                          | DOUBLE    |         | 成功获取字段长度的次数            |
| taos*write*raw*block*with*reqid*total               | DOUBLE    |         | 带请求 ID 写入原始块的总次数       |
| taos*write*raw*block*with*reqid*success             | DOUBLE    |         | 带请求 ID 成功写入原始块的次数      |
| taos*write*raw*block*with*reqid*fail                | DOUBLE    |         | 带请求 ID 写入原始块失败的次数      |
| taos*write*raw*block*with*fields*with*reqid*total   | DOUBLE    |         | 带请求 ID 和字段写入原始块的总次数    |
| taos*write*raw*block*with*fields*with*reqid*success | DOUBLE    |         | 带请求 ID 和字段成功写入原始块的次数   |
| taos*write*raw*block*with*fields*with*reqid*fail    | DOUBLE    |         | 带请求 ID 和字段写入原始块失败的次数   |
| tmq*write*raw_total                                 | DOUBLE    |         | 写入原始数据的 TMQ 总次数        |
| tmq*write*raw_success                               | DOUBLE    |         | 成功写入原始数据的 TMQ 次数       |
| tmq*write*raw_fail                                  | DOUBLE    |         | 写入原始数据的 TMQ 失败次数       |
| taos*stmt*prepare_total                             | DOUBLE    |         | stmt 准备的总次数            |
| taos*stmt*prepare_success                           | DOUBLE    |         | stmt 准备成功的次数           |
| taos*stmt*prepare_fail                              | DOUBLE    |         | stmt 准备失败的次数           |
| taos*stmt*is*insert*total                           | DOUBLE    |         | 检查 stmt 是否为插入的总次数      |
| taos*stmt*is*insert*success                         | DOUBLE    |         | 成功检查 stmt 是否为插入的次数     |
| taos*stmt*is*insert*fail                            | DOUBLE    |         | 检查 stmt 是否为插入失败的次数     |
| taos*stmt*set*tbname*total                          | DOUBLE    |         | stmt 设置表名的总次数          |
| taos*stmt*set*tbname*success                        | DOUBLE    |         | stmt 成功设置表名的次数         |
| taos*stmt*set*tbname*fail                           | DOUBLE    |         | stmt 设置表名失败的次数         |
| taos*stmt*set*tags*total                            | DOUBLE    |         | stmt 设置 tag 的总次数       |
| taos*stmt*set*tags*success                          | DOUBLE    |         | stmt 成功设置 tag 的次数      |
| taos*stmt*set*tags*fail                             | DOUBLE    |         | stmt 设置 tag 失败的次数      |
| taos*stmt*bind*param*batch_total                    | DOUBLE    |         | stmt 批量绑定参数的总次数        |
| taos*stmt*bind*param*batch_success                  | DOUBLE    |         | stmt 成功批量绑定参数的次数       |
| taos*stmt*bind*param*batch_fail                     | DOUBLE    |         | stmt 批量绑定参数失败的次数       |
| taos*stmt*add*batch*total                           | DOUBLE    |         | stmt 添加批处理的总次数         |
| taos*stmt*add*batch*success                         | DOUBLE    |         | stmt 成功添加批处理的次数        |
| taos*stmt*add*batch*fail                            | DOUBLE    |         | stmt 添加批处理失败的次数        |
| taos*stmt*execute_total                             | DOUBLE    |         | stmt 执行的总次数            |
| taos*stmt*execute_success                           | DOUBLE    |         | stmt 执行成功的次数           |
| taos*stmt*execute_fail                              | DOUBLE    |         | stmt 执行失败的次数           |
| taos*stmt*num*params*total                          | DOUBLE    |         | stmt 获取参数数量的总次数        |
| taos*stmt*num*params*success                        | DOUBLE    |         | stmt 成功获取参数数量的次数       |
| taos*stmt*num*params*fail                           | DOUBLE    |         | stmt 获取参数数量失败的次数       |
| taos*stmt*get*param*total                           | DOUBLE    |         | stmt 获取参数的总次数          |
| taos*stmt*get*param*success                         | DOUBLE    |         | stmt 成功获取参数的次数         |
| taos*stmt*get*param*fail                            | DOUBLE    |         | stmt 获取参数失败的次数         |
| taos*stmt*errstr_total                              | DOUBLE    |         | stmt 获取 stmt 错误信息的总次数  |
| taos*stmt*errstr_success                            | DOUBLE    |         | stmt 成功获取 stmt 错误信息的次数 |
| taos*stmt*affected*rows*once_total                  | DOUBLE    |         | stmt 获取单次影响行数的总次数      |
| taos*stmt*affected*rows*once_success                | DOUBLE    |         | stmt 成功获取单次影响行数的次数     |
| taos*stmt*use*result*total                          | DOUBLE    |         | stmt 使用结果集的总次数         |
| taos*stmt*use*result*success                        | DOUBLE    |         | stmt 成功使用结果集的次数        |
| taos*stmt*use*result*fail                           | DOUBLE    |         | stmt 使用结果集失败的次数        |
| taos*select*db_total                                | DOUBLE    |         | 选择数据库的总次数              |
| taos*select*db_success                              | DOUBLE    |         | 成功选择数据库的次数             |
| taos*select*db_fail                                 | DOUBLE    |         | 选择数据库失败的次数             |
| taos*get*tables*vgId*total                          | DOUBLE    |         | 获取表 vgroup ID 的总次数     |
| taos*get*tables*vgId*success                        | DOUBLE    |         | 成功获取表 vgroup ID 的次数    |
| taos*get*tables*vgId*fail                           | DOUBLE    |         | 获取表 vgroup ID 失败的次数    |
| taos*options*connection_total                       | DOUBLE    |         | 设置连接选项的总次数             |
| taos*options*connection_success                     | DOUBLE    |         | 成功设置连接选项的次数            |
| taos*options*connection_fail                        | DOUBLE    |         | 设置连接选项失败的次数            |
| taos*validate*sql_total                             | DOUBLE    |         | 验证 SQL 的总次数            |
| taos*validate*sql_success                           | DOUBLE    |         | 成功验证 SQL 的次数           |
| taos*validate*sql_fail                              | DOUBLE    |         | 验证 SQL 失败的次数           |
| taos*check*server*status*total                      | DOUBLE    |         | 检查服务器状态的总次数            |
| taos*check*server*status*success                    | DOUBLE    |         | 成功检查服务器状态的次数           |
| taos*get*current*db*total                           | DOUBLE    |         | 获取当前数据库的总次数            |
| taos*get*current*db*success                         | DOUBLE    |         | 成功获取当前数据库的次数           |
| taos*get*current*db*fail                            | DOUBLE    |         | 获取当前数据库失败的次数           |
| taos*get*server*info*total                          | DOUBLE    |         | 获取服务器信息的总次数            |
| taos*get*server*info*success                        | DOUBLE    |         | 成功获取服务器信息的次数           |
| taos*options*total                                  | DOUBLE    |         | 设置选项的总次数               |
| taos*options*success                                | DOUBLE    |         | 成功设置选项的次数              |
| taos*options*fail                                   | DOUBLE    |         | 设置选项失败的次数              |
| taos*set*conn*mode*total                            | DOUBLE    |         | 设置连接模式的总次数             |
| taos*set*conn*mode*success                          | DOUBLE    |         | 成功设置连接模式的次数            |
| taos*set*conn*mode*fail                             | DOUBLE    |         | 设置连接模式失败的次数            |
| taos*reset*current*db*total                         | DOUBLE    |         | 重置当前数据库的总次数            |
| taos*reset*current*db*success                       | DOUBLE    |         | 成功重置当前数据库的次数           |
| taos*set*notify*cb*total                            | DOUBLE    |         | 设置通知回调的总次数             |
| taos*set*notify*cb*success                          | DOUBLE    |         | 成功设置通知回调的次数            |
| taos*set*notify*cb*fail                             | DOUBLE    |         | 设置通知回调失败的次数            |
| taos*errno*total                                    | DOUBLE    |         | 获取错误码的总次数              |
| taos*errno*success                                  | DOUBLE    |         | 成功获取错误码的次数             |
| taos*errstr*total                                   | DOUBLE    |         | 获取错误信息的总次数             |
| taos*errstr*success                                 | DOUBLE    |         | 成功获取错误信息的次数            |
| tmq*consumer*poll_total                             | DOUBLE    |         | tmq 消费者 poll 的总次数      |
| tmq*consumer*poll_success                           | DOUBLE    |         | tmq 消费者 poll 成功的次数     |
| tmq*consumer*poll_fail                              | DOUBLE    |         | tmq 消费者 poll 失败的次数     |
| tmq*subscription*total                              | DOUBLE    |         | tmq 获取订阅信息的总次数         |
| tmq*subscription*success                            | DOUBLE    |         | tmq 成功获取订阅信息的次数        |
| tmq*subscription*fail                               | DOUBLE    |         | tmq 获取订阅信息失败的次数        |
| tmq*list*append_total                               | DOUBLE    |         | tmq 列表追加的总次数           |
| tmq*list*append_success                             | DOUBLE    |         | tmq 成功列表追加的次数          |
| tmq*list*append_fail                                | DOUBLE    |         | tmq 列表追加失败的次数          |
| tmq*list*get*size*total                             | DOUBLE    |         | tmq 获取列表大小的总次数         |
| tmq*list*get*size*success                           | DOUBLE    |         | tmq 成功获取列表大小的次数        |
| tmq*err2str*total                                   | DOUBLE    |         | tmq 错误码转字符串的总次数        |
| tmq*err2str*success                                 | DOUBLE    |         | tmq 成功将错误码转为字符串的次数     |
| tmq*conf*set_total                                  | DOUBLE    |         | tmq 设置配置的总次数           |
| tmq*conf*set_success                                | DOUBLE    |         | tmq 成功设置配置的次数          |
| tmq*conf*set_fail                                   | DOUBLE    |         | tmq 设置配置失败的次数          |
| tmq*get*res*type*total                              | DOUBLE    |         | tmq 获取资源类型的总次数         |
| tmq*get*res*type*success                            | DOUBLE    |         | tmq 成功获取资源类型的次数        |
| tmq*get*topic*name*total                            | DOUBLE    |         | tmq 获取主题名称的总次数         |
| tmq*get*topic*name*success                          | DOUBLE    |         | tmq 成功获取主题名称的次数        |
| tmq*get*vgroup*id*total                             | DOUBLE    |         | tmq 获取 vgroup ID 的总次数  |
| tmq*get*vgroup*id*success                           | DOUBLE    |         | tmq 成功获取 vgroup ID 的次数 |
| tmq*get*vgroup*offset*total                         | DOUBLE    |         | tmq 获取 vgroup 偏移量的总次数  |
| tmq*get*vgroup*offset*success                       | DOUBLE    |         | tmq 成功获取 vgroup 偏移量的次数 |
| tmq*get*db*name*total                               | DOUBLE    |         | tmq 获取数据库名称的总次数        |
| tmq*get*db*name*success                             | DOUBLE    |         | tmq 成功获取数据库名称的次数       |
| tmq*get*table*name*total                            | DOUBLE    |         | tmq 获取表名称的总次数          |
| tmq*get*table*name*success                          | DOUBLE    |         | tmq 成功获取表名称的次数         |
| tmq*get*connect_total                               | DOUBLE    |         | tmq 获取连接的总次数           |
| tmq*get*connect_success                             | DOUBLE    |         | tmq 成功获取连接的次数          |
| tmq*commit*sync_total                               | DOUBLE    |         | tmq 同步提交的总次数           |
| tmq*commit*sync_success                             | DOUBLE    |         | tmq 同步提交成功的次数          |
| tmq*commit*sync_fail                                | DOUBLE    |         | tmq 同步提交失败的次数          |
| tmq*fetch*raw*block*total                           | DOUBLE    |         | tmq 获取原始块的总次数          |
| tmq*fetch*raw*block*success                         | DOUBLE    |         | tmq 成功获取原始块的次数         |
| tmq*fetch*raw*block*fail                            | DOUBLE    |         | tmq 获取原始块失败的次数         |
| tmq*get*topic*assignment*total                      | DOUBLE    |         | tmq 获取主题分配的总次数         |
| tmq*get*topic*assignment*success                    | DOUBLE    |         | tmq 成功获取主题分配的次数        |
| tmq*get*topic*assignment*fail                       | DOUBLE    |         | tmq 获取主题分配失败的次数        |
| tmq*offset*seek_total                               | DOUBLE    |         | tmq 偏移量定位的总次数          |
| tmq*offset*seek_success                             | DOUBLE    |         | tmq 成功偏移量定位的次数         |
| tmq*offset*seek_fail                                | DOUBLE    |         | tmq 偏移量定位失败的次数         |
| tmq*committed*total                                 | DOUBLE    |         | tmq 获取已提交偏移量的总次数       |
| tmq*committed*success                               | DOUBLE    |         | tmq 成功获取已提交偏移量的次数      |
| tmq*commit*offset*sync*fail                         | DOUBLE    |         | tmq 同步提交偏移量失败的次数       |
| tmq*position*total                                  | DOUBLE    |         | tmq 获取当前位置的总次数         |
| tmq*position*success                                | DOUBLE    |         | tmq 成功获取当前位置的次数        |
| tmq*commit*offset*sync*total                        | DOUBLE    |         | tmq 同步提交偏移量的总次数        |
| tmq*commit*offset*sync*success                      | DOUBLE    |         | tmq 同步提交偏移量成功的次数       |
| endpoint                                            | NCHAR     | TAG     | 请求端点                   |

</details>

## httpd 升级为 taosAdapter 的变化

在 TDengine server 2.2.x.x 或更早期版本中，taosd 进程包含一个内嵌的 http 服务（httpd）。如前面所述，taosAdapter 是一个使用 systemd 管理的独立软件，拥有自己的进程。并且两者有一些配置参数和行为是不同的，请见下表：

| **#** | **embedded httpd**  | **taosAdapter**               | **comment**                                                                                    |
|-------|---------------------|-------------------------------|------------------------------------------------------------------------------------------------|
| 1     | httpEnableRecordSql | --logLevel=debug              |                                                                                                |
| 2     | httpMaxThreads      | n/a                           | taosAdapter 自动管理线程池，无需此参数                                                                      |
| 3     | telegrafUseFieldNum | 请参考 taosAdapter telegraf 配置方法 |                                                                                                |
| 4     | restfulRowLimit     | restfulRowLimit               | 内嵌 httpd 默认输出 10240 行数据，最大允许值为 102400。taosAdapter 也提供 restfulRowLimit 但是默认不做限制。您可以根据实际场景需求进行配置 |
| 5     | httpDebugFlag       | 不适用                           | httpdDebugFlag 对 taosAdapter 不起作用                                                              |
| 6     | httpDBNameMandatory | 不适用                           | taosAdapter 要求 URL 中必须指定数据库名                                                                   |
