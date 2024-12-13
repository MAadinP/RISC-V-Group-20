# RISC-V-Group-20 Cache

**This branch implements cache into a fusion architecture of pipelined cpu 2 and main, and executes the entire instruction set.**

## Schematic
The wider schematic to give context to the cache implementation.

![schematic](schematic.png)

Zoomed in schematic.

![caschem](caschem.png)

## Details
We implement a 2-Way Set Associative Cache with a storage capacity of 4096 data bytes.
We went with 2-Way to improve our rates with conflict misses, as in a 2 way cache, each block can map to two locations in the set. 
For cache coherency, we've decided to use a write-back policy, implementing dirty bits to ensure data isn't lost when evicting blocks.

## Proof of function
### [Link to demos](https://www.youtube.com/watch?v=y0XfobdrZcU&list=PLdeaaZuxLlWtO-BnAFKly6QJmn4A7G8WB)

