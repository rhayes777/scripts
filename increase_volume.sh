#!/bin/bash

for x in *.wav; do 
  t=$(echo $x | sed 's/\.wav$/_volume.wav/'); 
  sox -v 1.5 $x $t
done
