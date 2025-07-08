<!--

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

-->
# 0.11.0 -> 0.12.0

## add:

## removed:

debug_state=false

# 0.10.0 -> 0.11.0

## add：
enable*mem*control=true

write*read*schema*free*memory_proportion=4:3:1:2

flush_proportion=0.3

buffered*arrays*memory_proportion=0.6

reject_proportion=0.8

storage*group*report_threshold=16777216

max*deduplicated*path_num=1000

waiting*time*when*insert*blocked=10

max*waiting*time*when*insert_blocked=10000

estimated*series*size=300

compaction*strategy=LEVEL*COMPACTION

seq*file*num*in*each_level=6

seq*level*num=4

unseq*file*num*in*each_level=10

unseq*level*num=1

merge*chunk*point_number=100000

merge*page*point_number=1000

merge*fileSelection*time_budget=30000

compaction*thread*num=10

merge*write*throughput*mb*per_sec=8

frequency*interval*in_minute=1

slow*query*threshold=5000

debug_state=false

enable*discard*out*of*order_data=false

enable*partial*insert=true

enable*mtree*snapshot=false

mtree*snapshot*interval=100000

mtree*snapshot*threshold_time=3600

rpc*selector*thread_num=1

rpc*min*concurrent*client*num=1

## remove：
merge*thread*num=1

time_zone=+08:00

enable*parameter*adapter=true

write*read*free*memory*proportion=6:3:1

## change：
tsfile*size*threshold=0

avg*series*point*number*threshold=10000

