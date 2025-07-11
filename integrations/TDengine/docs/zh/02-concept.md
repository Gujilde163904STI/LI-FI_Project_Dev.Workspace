---
sidebar_label: 时序数据基础
title: 时序数据基础
description: 时序数据基础概念
toc*max*heading_level: 4
---

## 什么是时序数据？

时序数据，即时间序列数据（Time-Series Data），它们是一组按照时间发生先后顺序进行排列的序列数据。日常生活中，设备、传感器采集的数据就是时序数据，证券交易的记录也是时序数据。因此时序数据的处理并不陌生，特别在是工业自动化以及证券金融行业，专业的时序数据处理软件早已存在，比如工业领域的 PI System 以及金融行业的 KDB。

这些时序数据是周期、准周期产生的，或事件触发产生的，有的采集频率高，有的采集频率低。一般被发送至服务器进行汇总并进行实时分析和处理，对系统的运行做出实时监测或预警，对股市行情进行预测。这些数据也可以被长期保存下来，用以进行离线数据分析。比如统计时间区间内设备的运行节奏与产出，分析如何进一步优化配置来提升生产效率；统计一段时间内生产过程中的成本分布，分析如何降低生产成本；统计一段时间内的设备异常值，结合业务分析潜在的安全隐患，以降低故障时长等等。

过去的二十年，随着数据通讯成本的急剧下降，以及各种传感技术和智能设备的出现，特别是物联网与工业 4.0 的推动，工业、物联网企业为了监测设备、环境、生产线及整个系统的运行状态，在各个关键点都配有传感器，采集各种数据。从手环、共享出行、智能电表、环境监测设备到电梯、数控机床、挖掘机、工业生产线等都在源源不断的产生海量的实时数据，时序数据的体量正指数级的增长。以智能电表为例，智能电表每隔 15 分钟采集一次数据，每天会自动生成 96 条记录。现在全中国已经有超过 10 亿台智能电表，一天就产生 960 亿条时序数据。一台联网的汽车往往每隔 10 到 15 秒采集一次数据发到云端，那么一天下来就很容易产生 1000 条记录。假设中国有 2 亿车辆联网，它们每天将产生总计 2000 亿条甚至更多的时序数据。

由于数据量指数级的增长，而且对分析和实时计算的需求越来越多，特别是在人工智能的时代，传统的时序数据处理工具难以满足需求，对每天高达 10TB 级别的海量时序大数据如何进行实时的存储、分析和计算，成为一个技术挑战，因此海量时序大数据的高效处理在过去的十年获得全球工业界的高度关注。

## 时序数据的十大特征

相对于普通的互联网的应用数据，时序数据有着很多明显的特征。涛思数据的创始人陶建辉先生早在 2017 年，就对此进行了充分地归纳分析，总结了时序数据本身以及时序数据应用的十大特征：

1. 数据是时序的，一定带有时间戳：联网的设备按照设定的周期，或受外部的事件触发，源源不断地产生数据，每条记录都是在一个时间点产生的，其时间戳必须记录，否则记录的值没有任何意义。

2. 数据是结构化的：物联网、工业设备产生的数据以及证券交易数据往往是结构化的，而且绝大多数都是数值型的，比如智能电表采集的电流、电压就可以用 4 字节的标准的浮点数来表示。

3. 一个数据采集点就是一个数据流：一个设备采集的数据、以及一支股票的交易数据，与另外一个设备采集的数据或股票是完全独立的。一台设备的数据一定是这台设备产生的，不可能是人工或其他设备产生的。一台设备产生的数据或一支股票的交易数据只有一个生产者，也就是说数据源是唯一的。

4. 数据较少有更新删除操作：对于一个典型的信息化或互联网应用，记录可能是经常需要修改或删除的。但对于设备或交易产生的数据正常情况下不会去更新/删除。

5. 数据不依赖于事务：在设备产生的数据中，具体的单条数据价值相对不高，数据的完整性和一致性并不像传统关系型数据库那样严格，大家关心的是趋势，所以不需要引入复杂的事务机制。

6. 相对互联网应用，写多读少：对于互联网应用，一条数据记录，往往是一次写，很多次读。比如一条微博或一篇微信公共号文章，一次写，但有可能上百万人读。但工业、物联网设备产生的数据不一样，一般是计算、分析程序自动读，且次数不多，只有遇到事故、人们才会主动读取原始数据。

7. 用户关注的是一段时间的趋势：对于一条银行交易记录，或者一条微博、微信，对于它的用户而言，每一条都很重要。但对于物联网、工业时序数据，每个数据点与数据点的变化并不大，大家关心的更多是一段时间，比如过去五分钟、一小时数据变化的趋势，不会只针对一个时间点进行。

8. 数据是有保留期限的：采集的数据一般都有基于时长的保留策略，比如仅仅保留一天、一周、一个月、一年甚至更长时间，该类数据的价值往往是由时间段决定的，因此对于不在重要时间段内的数据，都是可以被视为过期数据整块删除的。

9. 需要实时分析计算操作：对于大部分互联网大数据应用，更多的是离线分析，即使有实时分析，但要求并不高。比如用户画像、可以积累一定的用户行为数据后进行，早一天晚一天画不会特别影响结果。但是对于工业、物联网的平台应用以及交易系统，对数据的实时计算要求就往往很高，因为需要根据计算结果进行实时报警、监控，从而避免事故的发生、决策时机的错过。

10. 流量平稳、可预测：给定工业、物联网设备数量、数据采集频次，就可以较为准确的估算出所需要的带宽、流量、存储等数字，以及每天新生成的数据大小。而不是像电商，在双 11 期间，淘宝、天猫、京东等流量是几十倍的涨幅。也不像 12306 网站，春节期间，网站流量是几十倍的增长。

上述的特征使时序数据的处理具有着独特的需求和挑战。但是反过来说，对于一个高效的时序数据处理平台，它也必然充分利用这十大特征来提升它的处理能力。

## 时序数据的典型应用场景

时序数据应用的细分场景有很多，这里简单列举一些

1. 电力能源领域：电力能源领域范围较大，不论是在发电、输电、配电、用电还是其他环节中，各种电力设备都会产生大量时序数据，以风力发电为例，风电机作为大型设备，拥有可能高达数百的数据采集点，因此每日所产生的时序数据量极其之大，对这些数据的监控分析是确保发电环节准确无误的必要工作。在用电环节，对智能电表实时采集回来的电流、电压等数据进行快速计算，实时了解最新的用电总量、尖、峰、平、谷用电量，判断设备是否正常工作。有些时候，电力系统可能需要拉取历史上某一年的全量数据，通过机器学习等技术分析用户的用电习惯、进行负荷预测、节能方案设计、帮助电力公司合理规划电力的供应。或者拉取上个月的尖峰平谷用电量，根据不同价位进行周期性的电费结算，以上都是时序数据在电力能源领域的典型应用。

2. 车联网/轨道交通领域：车辆的 GPS、速度、油耗、故障信息等，都是典型的时序数据，通过科学合理地数据分析，可以为车辆管理和优化提供强有力的支持。但是，不同车型采集的点位信息从数百点到数千点之间不一而同，随着联网的交通设备数量越来越多，这些海量的时序数据如何安全上传、数据存储、查询和分析，成为了一个亟待解决的行业问题。对于交通工具的本身，科学合理地处理时序数据可以实现车辆轨迹追踪、无人驾驶、故障预警等功能。对于交通工具的整体配套服务，也可以提供良好的支持。比如，在新一代的智能地铁管理系统中，通过地铁站中各种传感器的时序数据采集分析，可以在站中实时展示各个车厢的拥挤度、温度、舒适度等数据，让用户可以自行选择体验度最佳的出行方案，对于地铁运营商，也可以更好地实现乘客流量的调度管理。

3. 智能制造领域：过去的十几年间，许多传统工业企业的数字化得到了长足的发展，单个工厂从传统的几千个数据采集点，到如今数十万点、上百万点，部分远程运维场景面临上万设备、千万点的数据采集存储的需求，这些数据都属于典型的时序数据。就整个工业大数据系统而言，时序数据的处理是相当复杂的。以烟草行业的数据采集为例，设备的工业数据协议各式各样、数据采集单位随着设备类型的不同而不同。数据的实时处理能力随着数据采集点的持续增加而难以跟上，与此同时还要兼顾数据的高性能、高可用、可拓展性等等诸多特性。但从另一个角度来看，如果大数据平台能够解决以上困难，满足企业对于时序数据存储分析的需求，就可以帮助企业实现更加智能化、自动化的生产模式，从而完成质的飞升。

4. 智慧油田：智慧油田也称为数字油田或智能油田，是指利用先进的信息技术和装备，实现油气田层析图和动态生产数据实时更新，提升油气田的开发效率和经济效益的一种油田开发模式。在长期的建设和探索中，钻井、录井、测井、开发生产等勘探开发业务，产生了来自油井、水井、气井等数十种设备的大量时序数据。为了实现统一以油气生产指挥中心为核心的油气生产信息化智能管控模式，满足科学高效智能的油气生产管理需求。该系统需要确保油田几万口油气水井、阀组、加热炉等设备的实时数据处理，做到高效的写入和查询、节省存储空间、基于业务灵活水平扩展、系统简单易用、数据安全可靠。更有一些大型的智慧油田项目，还会把全国各个地区的油田的生产数据实时同步汇总到总部的云端平台，依靠“边云协同”的方式完成“数据入湖”的统一筹划管理模式。

5. IT 运维领域：IT 领域中，基础设施（如服务器、网络设备、存储设备）、应用程序运行的过程中会产生大量的时序数据。通过对这些时序数据的监控，可以很快地发现基础设施/应用的运行状态和服务可用性，包括系统是否在线、服务是否正常响应等；也能看到具体到某一个具体的点位的性能指标：如 CPU 利用率、内存利用率、磁盘空间利用率、网络带宽利用率等；还可以监控系统产生的错误日志和异常事件，包括入侵检测、安全事件日志、权限控制等，最终通过设置报警规则，及时通知管理员或运维人员具体的情况，从而及时发现问题、预防故障，并优化系统性能，确保系统稳定可靠地运行。

6. 金融领域：金融领域目前正经历着数据管理的一场革命，行情数据属于典型的时序数据，由于保留行情数据的储存期限往往需长达 5 至 10 年，甚至超过 30 年，而且可能全世界各个国家/地区的主流金融市场的交易数据都需要全量保存，因此行情数据的总量数据体量庞大，会轻松达到 TB 级别，造成存储、查询等等各方面的瓶颈。在金融领域中，量化交易平台是最能凸显时序数据处理重要性的革命性应用之一：通过对大量时序行情数据的读取分析来及时响应市场变化，帮助交易者把握投资机会，同时规避不必要的风险，实现资产的稳健增长。可以实现包括但不限于：资产管理、情绪监控、股票回测、交易信号模拟、报表自动生成等等诸多功能。

## 处理时序数据所需要的工具

如果想要高效地处理时序数据，一个完整的时序数据处理平台一定要准备好以下几个核心模块。

1. 数据库（Database）：数据库提供时序数据的高效存储和读取能力。在工业、物联网场景，由设备所产生的时序数据量是十分惊人的。从存储数据的角度来说，数据库需要把这些数据持久化到硬盘上并最大程度地压缩，从而降低存储成本。从读取数据的角度来说，数据库需要保证实时查询，以及历史数据的查询效率。比较传统的存储方案是使用 MySql、Oracle 等关系型数据库，也有 Hadoop 体系的 HBase，专用的时序数据库则有 InfluxDB、OpenTSDB、Prometheus 等。

2. 数据订阅（Data Subscription）：很多时序数据应用都需要在第一时间订阅到业务所需的实时数据，从而及时了解被监测对象的最新状态，用 AI 或其他工具做实时的数据分析。同时，由于数据的隐私以及安全，你只能允许应用订阅他有权限访问的数据。因此，一个时序数据处理平台一定需要具备数据订阅的能力，帮助应用实时获取最新数据。

3. ETL（Extract，Transform，Load）：在实际的物联网、工业场景中，时序数据的采集需要特定的 ETL 工具进行数据的提取、清洗和转换操作，才能把数据写入数据库中，以保证数据的质量。因为不同数据采集系统往往使用不同的标准，比如采集的温度的物理单位不一致，有的用摄氏度，有的用华氏度；系统之间所在的时区不一致，要进行转换；时间分辨率也可能不统一，因此这些从不同系统汇聚来的数据需要进行转换才能写入数据库。

4. 流计算（Stream computing）：物联网、工业、金融应用需要对时序数据流进行高效快速计算，通过所得到的计算结果来满足实时业务的需求。比如，面对实时采集到的每个智能电表的电流和电压数据，需要立刻算出各个电表的有功功率、无功功率。因此时序数据处理平台通常会选择一些比如 Apache Spark、Apache Flink 等等的流处理框架。

5. 缓存（Cache）：物联网、工业、金融应用需要实时展示一些设备或股票的最新状态，因此平台需要缓存技术提供快速的数据访问。原因是：由于时序数据体量极大，如果不使用缓存技术，而是进行常规的读取、筛选，那么对于监控设备最新状态之类的计算是十分困难的，将会导致很大的延迟，从而失去“实时”的意义。因此，缓存技术是时序数据处理平台不可缺少的一环，Redis 就是这样一种常用的缓存工具。

处理时序数据需要一系列模块的协同作业，从数据采集到存储、计算、分析与可视化，再到专用的时序数据算法库，每个环节都有相应的工具支持。这些工具的选择取决于具体的业务需求和数据特点，合理地选用和搭配才能做到高效地处理各种类型的时序数据，挖掘数据背后的价值。

## 专用时序数据处理工具的必要性

在时序数据的十大特征一节中提到，对于一个优秀的时序大数据处理平台来说，必然需要具备处理时序数据十大特征的能力。在处理时序数据所需要的工具一节中介绍了时序大数据平台处理时序数据所需要的主要模块/组件。结合这两节的内容与实际情况，可以发现：处理海量时序数据，其实是一个很庞大复杂的系统。

早些年，为处理日益增长的互联网数据，众多的工具开始出现，最流行的便是 Hadoop 体系。除使用大家所熟悉的 Hadoop 组件如 HDFS、MapReduce、HBase 和 Hive 外，通用的大数据处理平台往往还使用 Kafka 或其他消息队列工具，Redis 或其他缓存软件，Flink 或其他实时流式数据处理软件。存储上也有人选用 MongoDB、Cassandra 或其他 NoSQL 数据库。这样一个典型的大数据处理平台基本上能很好的处理互联网行业的应用，比如典型的用户画像、舆情分析等。

因此很自然，在工业、物联网大数据兴起后，大家仍然想到的是使用这套通用的大数据处理平台来处理时序数据。现在市场上流行的物联网、车联网等大数据平台几乎无一例外是这类架构，这套方法被证明完全可以工作，但效果仍然有很多不足：

1. 开发效率低：因为不是单一软件，需要集成至少 4 个以上模块，而且很多模块都不是标准的 POSIX 或 SQL 接口，都有自己的开发工具、开发语言、配置，需要一定的学习成本。而且由于数据从一个模块流动到另外一个模块，数据一致性容易受到破坏。同时，这些模块基本上都是开源软件，难免遇到各种 BUG，即使有技术论坛、社区的支持，一旦被一技术问题卡住，总要耗费工程师不少时间。总的来讲，需要搭建一个还不错的团队才能将这些模块顺利的组装起来，因此需要耗费较大的人力资源。

2. 运行效率低：现有的这些开源软件主要用来处理互联网上的非结构化数据，比如文本、视频、图片数据等，但是通过物联网采集来的数据都是时序的、结构化的。用非结构化数据处理技术来处理结构化数据，无论是存储还是计算，消费的资源都大很多。

3. 运维成本高：每个模块，无论是 Kafka、HBase、HDFS 还是 Redis，都有自己的管理后台，都需要单独管理。在传统的信息系统中，数据库管理员只要学会管理 MySQL 或是 Oracle 就可以了，但现在数据库管理员需要学会管理、配置、优化很多模块，工作量大了很多。由于模块数过多，定位一个问题就变得更为复杂。比如，用户发现有一条采集的数据丢失了，至于是 Kafka、HBase、Spark 丢失的，还是应用程序丢失的，则无法迅速定位，往往需要花很长时间，只有将各模块的日志关联起来才能找到原因。而且模块越多，系统整体的稳定性就越低。

4. 产品推出慢、利润低：由于源软件研发效率低，运维成本高，导致将产品推向市场的时间变长，让企业丧失商机。而且这些开源软件都在演化中，要同步使用最新的版本也需要耗费一定的人力。除互联网头部公司外，中小型公司在通用大数据平台上花费的人力资源成本一般都远超过专业公司的产品或服务费用。

5. 对于小数据量场景，私有化部署太重：在物联网、车联网场景中，因为涉及到生产经营数据的安全，很多还是采取私有化部署。而每个私有化部署，处理的数据量有很大的区别，从几百台联网设备到数千万台设备不等。对于数据量小的场景，通用的大数据解决方案就显得过于臃肿，投入产出不成正比。因此有的平台提供商往往有两套方案，一套针对大数据场景，使用通用的大数据平台，一套针对小数据规模场景，就使用 MySQL 或其他数据库来搞定一切，但是随着历史数据的累积，或接入设备量的增长，关系型数据库性能不足、运维复杂、扩展性差等缺点都会逐渐暴露出来，终究不是长久之计。

由于存在这些根本性的缺陷，导致高速增长的时序大数据市场一直没有一个简单好用而又高效的工具。于是，近些年一批专注时序数据处理的企业杀入了这个赛道，比如美国的 InfluxData，其产品 InfluxDB 在 IT 运维监测方面有相当的市场占有率。开源社区也十分活跃，比如基于 HBase 开发的 OpenTSDB，中国国内，阿里、百度、华为都有基于 OpenTSDB 的产品，涛思数据不依赖任何第三方，推出了自主研发而且开源的 TDengine。

由于数据量巨大且应用方式特殊，对时序数据的处理具有相当大的技术挑战，因此要使用专业的大数据平台。对实时时序数据的科学合理地高效处理能够帮助企业实时监控生产与经营过程，对历史时序数据的分析有助于对资源的使用和生产配置做出科学的决策。

## 选择时序数据处理工具的标准

毫无疑问，我们需要一个优秀的时序大数据平台来处理设备、交易产生的海量数据。那么，这个大数据平台需要具备哪些能力？与通用的大数据平台相比，它需要具备什么样的特征呢？

1. 必须是分布式系统：首先，由工业、物联网设备产生的海量数据，是任何一台单独的服务器都无能力处理的，因此处理系统必须是可分布式的、水平扩展的。这个平台在设计层面就必须能够高效地处理高基数难题：以智能电表为例，每个设备都有自己的设备 ID、城市 ID、厂商 ID 和模型 ID 等标签。几百个城市，百万级设备，再加上不同的厂商、模型。相乘之下，基数轻松超过百亿级。假如想找到某一个设备的数据，需要在百亿级的基数中筛选过滤，难度可想而知，这便是时序数据领域经典的“高基数”难题。即便是很多中小型项目，过亿的基数也是十分常见的。所以，对于时序数据工具的选型，一定要看它的架构模型能否撑得起你的业务基数。一个能够通过分布式的架构来处理“高基数”难题，才能让平台足以支撑业务的增长，才可以说是一个真正意义上的时序大数据平台。

2. 必须是高性能：“高性能”是一个相对的概念，它描述的是一款产品与其他产品相比而来的性能表现。不同大数据平台的硬件规模和需求都是不一致的，但是一个好的大数据平台绝对不应该依赖于“大硬件”，而是应该拥有强悍的单点工作能力，用更少的资源达到更好的性能，这样才是真正的做到“降本”和“增效”。如果专用的时序大数据处理平台不能在存储、读取、分析这些方面做到“高性能”，那么为什么不采用通用的大数据平台呢？

3. 必须是满足实时计算的系统：互联网大数据处理，大家所熟悉的场景是用户画像、推荐系统、舆情分析等等，这些场景并不需要什么实时性，批处理即可。但是对于物联网场景，需要基于采集的数据做实时预警、决策，延时要控制在秒级以内。如果计算没有实时性，物联网的商业价值就大打折扣。

4. 必须拥有运营商级别的高可靠服务：工业、物联网系统对接的往往是生产、经营系统，如果数据处理系统宕机，直接导致停产，产生经济有损失、导致对终端消费者的服务无法正常提供。比如智能电表，如果系统出问题，直接导致的是千家万户无法正常用电。因此工业、物联网大数据系统必须是高可靠的，必须支持数据实时备份，必须支持异地容灾，必须支持软件、硬件在线升级，必须支持在线 IDC 机房迁移，否则服务一定有被中断的可能。

5. 必须拥有高效的缓存功能：绝大部分场景，都需要能快速获取设备当前状态或其他信息，用以报警、大屏展示或其他。系统需要提供一高效机制，让用户可以获取全部、或符合过滤条件的部分设备的最新状态。

6. 必须拥有实时流式计算：各种实时预警或预测已经不是简单的基于某一个阈值进行，而是需要通过将一个或多个设备产生的数据流进行实时聚合计算，不只是基于一个时间点、而是基于一个时间窗口进行计算。不仅如此，计算的需求也相当复杂，因场景而异，应允许用户自定义函数进行计算。

7. 必须支持数据订阅：与通用大数据平台比较一致，同一组数据往往有很多应用都需要，因此系统应该提供订阅功能，只要有新的数据更新，就应该实时提醒应用。由于数据隐私和安全，而且这个订阅也应该是个性化的，只能订阅有权查看的数据，比如仅仅能订阅每小时的平均功率，而不能订阅原始的电流、电压值。

8. 必须保证数据能持续稳定写入：对于联网设备产生的数据，数据流量往往是平稳的，因此数据写入所需要的资源往往是可以估算的。但是变化的是查询、分析，特别是即席查询，有可能耗费很大的系统资源，不可控。因此系统必须保证分配足够的资源以确保数据能够写入系统而不被丢失。准确的说，系统必须是一个写优先系统。

9. 必须保证实时数据和历史数据的处理合二为一：实时数据在缓存里，历史数据在持久化存储介质里，而且可能依据时长，保留在不同存储介质里。系统应该隐藏背后的存储，给用户和应用呈现的是同一个接口和界面。无论是访问新采集的数据还是十年前的老数据，除输入的时间参数不同之外，其余应该是一样的。

10. 必须支持灵活的多维度分析：对于联网设备产生的数据，需要进行各种维度的统计分析，比如从设备所处的地域进行分析，从设备的型号、供应商进行分析，从设备所使用的人员进行分析等等。而且这些维度的分析是无法事先想好的，是在实际运营过程中，根据业务发展的需求定下来的。因此时序大数据系统需要一个灵活的机制增加某个维度的分析。

11. 需要支持即席分析和查询。为提高大数据分析师的工作效率，系统应该提供一命令行工具或允许用户通过其他工具，执行 SQL 查询，而不是非要通过编程接口。查询分析的结果可以很方便的导出，再制作成各种图表。

12. 必须支持数据降频、插值、特殊函数计算等操作。原始数据的采集频次可能很高，但具体分析往往不需要对原始数据执行，而是数据降频之后。系统需要提供高效的数据降频操作。设备是很难同步的，不同设备采集数据的时间点是很难对齐的，因此分析一个特定时间点的值，往往需要插值才能解决，系统需要提供线性插值、设置固定值等多种插值策略才行。工业互联网里，除通用的统计操作之外，往往还需要支持一些特殊函数，比如时间加权平均、累计求和、差值等。

13. 必须提供灵活的数据管理策略。一个大的系统，采集的数据种类繁多，而且除采集的原始数据外，还有大量的衍生数据。这些数据各自有不同的特点，有的采集频次高，有的要求保留时间长，有的需要多个副本以保证更高的安全性，有的需要能快速访问。因此物联网大数据平台必须提供多种策略，让用户可以根据特点进行选择和配置，而且各种策略并存。

14. 必须是开放的。系统需要支持业界流行的标准 SQL，提供各种语言开发接口，包括 C/C++、Java、Go、Python、RESTful 等接口，也需要支持 Spark、R、Matlab 等工具，方便集成各种机器学习、人工智能算法或其他应用，让大数据处理平台能够不断扩展，而不是成为一个孤岛。

15. 必须支持异构环境。大数据平台的搭建是一个长期的工作，每个批次采购的服务器和存储设备都会不一样，系统必须支持自己可以和各种档次、配置的服务器和存储设备并存。

16. 必须支持边云协同。要有一套灵活的机制将边缘计算节点的数据上传到云端，根据具体需要，可以将原始数据，或加工计算后的数据，或仅仅符合过滤条件的数据同步到云端，而且随时可以取消，更改策略。这样才能更好的汇聚数据，统筹业务，从而做出更好的业务决策。

17. 需要统一的后台管理系统。便于查看系统运行状态、管理集群、用户、各种系统资源等，而且系统能够与第三方 IT 运维监测平台无缝集成。

18. 需要支持私有化部署。因为很多企业出于安全以及各种因素的考虑，希望采用私有化部署。而传统的企业往往没有很强的 IT 运维团队，因此在安装、部署、运维等方面需要做到简单、快捷，可维护性强。

总之，时序大数据平台应具备高效、可扩展、实时、可靠、灵活、开放、简单、易维护等特点。近年来，众多企业纷纷将时序数据从传统大数据平台或关系型数据库迁移到专用时序大数据平台，以保障海量时序数据得到快速和有效处理，支撑相关业务的持续增长。
