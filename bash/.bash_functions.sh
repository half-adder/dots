#!/usr/bin/env bash

# Download from LongLeaf using good default rsync flags
dl_ll () {
    rsync seanjohn@longleaf.unc.edu:$1 $2
}

# Upload to LongLeaf using good default rsync flags
ul_ll () {
    rsync $1 seanjohn@longleaf.unc.edu:$2
}
