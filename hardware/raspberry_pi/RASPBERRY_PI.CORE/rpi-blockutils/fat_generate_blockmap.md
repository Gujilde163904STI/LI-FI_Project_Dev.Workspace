# FAT\*GENERATE\*BLOCKMAP(1)

## NAME
fat\*generate\*blockmap - Creates blockmaps for FAT32 disk images

## SYNOPSIS
fat\*generate\*blockmap

## DESCRIPTION
Generates a blockmap for a FAT32 disk image by searching for unused clusters.

## EXAMPLES
`fat*generate*blockmap bootfs.img > bootfs.blockmap`

## SEE ALSO
`blockmap_img2simg`(1)
`fatcat`(1)
`extract*fat*as_hex`(1)
`ascii*fat*to_blockmap`(1)
