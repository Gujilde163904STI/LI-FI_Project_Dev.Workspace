# Function placement in IRAM section

The heap component is compiled and linked in a way that minimizes the utilization of the IRAM section of memory without impacting the performance of its core functionalities. For this reason, the heap component API provided through [esp*heap*caps.h](./include/esp*heap*caps.h) and [esp*heap*caps*init.h](./include/esp*heap*caps*init.h) can be sorted into two sets of functions.

1. The performance related functions placed into the IRAM by using the `IRAM*ATTR` defined in [esp*attr.h](./../../components/esp*common/include/esp*attr.h) (e.g., `heap*caps*malloc`, `heap*caps*free`, `heap*caps*realloc`, etc.)

2. The functions that does not require the best of performance placed in the flash (e.g., `heap*caps*print*heap*info`, `heap*caps*dump`, `heap*caps*dump_all`, etc.)

With that in  mind, all the functions defined in [multi*heap.c](./multi*heap.c), [multi*heap*poisoning.c](./multi*heap*poisoning.c) and [tlsf.c](./tlsf/tlsf.c) that are directly or indirectly called from one of the heap component API functions placed in IRAM have to also be placed in IRAM. Symmetrically, the functions directly or indirectly called from one of the heap component API functions placed in flash will also be placed in flash.