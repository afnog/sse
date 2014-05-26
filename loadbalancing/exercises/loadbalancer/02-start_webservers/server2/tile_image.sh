#!/bin/sh
# set -w
OUT_DIR="tiles"
IMAGE=./african_landscape_1024_768.jpg
GEOMETRY=$(identify $IMAGE | egrep -o " [0-9]+x[0-9]+ " | sed -e "s/ //g")
LENGTH=$(echo $GEOMETRY | awk -Fx '{print $1}')
WIDTH=$(echo $GEOMETRY | awk -Fx '{print $2}')


# LETs keep it simple... Stick to square numbers
TILES=16
# Sans bc, no easy way to do this in bash
SQRT_TILES=$(python -c "print '%d'%${TILES}**0.5")
PERC_CROP=$((100/$SQRT_TILES))

echo " [i] will store tiles in $OUT_DIR"
echo "TILE GRID will be $SQRT_TILES x $SQRT_TILES"

# Prep environment
mkdir -p $OUT_DIR
echo " [i] will store tiles in $OUT_DIR"

i=0
while [ $i -lt $SQRT_TILES ];
do
    j=0
    while [ $j -lt $SQRT_TILES ];
    do
        IMG_IDX=$(($i*SQRT_TILES + $j))
        TILE_CMD="convert -crop ${PERC_CROP}%x+$(($j * $LENGTH/$SQRT_TILES))+$(($i * $WIDTH/$SQRT_TILES)) $IMAGE $OUT_DIR/tile-${IMG_IDX}.jpg"
        echo " [i] generating image $IMG_IDX of $TILES tiles for tile @ grid $i,$j.."
        echo "  [d] command: $TILE_CMD"
        $TILE_CMD
        j=$(($j+1))
    done
    i=$(($i+1))
    echo 
done

echo " [i] Generating index.html for the tiles...."
echo "<html><body bgcolor=#ffffff alink=#0000be><b>Africa in $SQRT_TILES x $SQRT_TILES tiles!</b><br>" > index.html
echo "<table border=0>" >> index.html
i=0
while [ $i -lt $SQRT_TILES ];
do
    j=0
    echo "<tr>" >> index.html
    while [ $j -lt $SQRT_TILES ];
    do
        IMG_IDX=$(($i*SQRT_TILES + $j))
        echo "<td><img src="$OUT_DIR/tile-${IMG_IDX}.jpg"></td>" >> index.html
        j=$(($j+1))
    done
    echo "</tr>" >> index.html
    i=$(($i+1))
done
echo "</table></html>" >> index.html
