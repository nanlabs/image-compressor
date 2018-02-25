#!/bin/bash

jpgCompressionArgs=${JPG_COMPRESSION_ARGS:-"-strip -quality 90 -interlace JPEG -colorspace sRGB"}
pngCompressionArgs=${PNG_COMPRESSION_ARGS:-"-strip"}
expectedCompressionRatio=${EXPECTED_COMPRESSION_RATIO:-"15"}

sourceDirPath="/source"
targetDirPath="/target"
backupDirPath="/backup"
function getCompressArgs {

  case "$1" in
        "jpg")
            echo $jpgCompressionArgs
            ;;

        "png")
            echo $pngCompressionArgs
            ;;

  esac
}

find $sourceDirPath -type f |grep -E "*.jpg|*.png"  | while read sourceFilePath; do
    originSize=`du  "$sourceFilePath" |cut -f1`
    fileName=`echo "$sourceFilePath" |rev |cut -d '/' -f1 |rev`
    extension=`echo $fileName | sed -E "s/.*\.(.*)/\1/g" `

    relativePath=`echo $sourceFilePath | sed -E "s|$sourceDirPath||g" | sed -E "s|$fileName||g" | sed -E "s|//|/|g"`

    targetFilePath=`echo "$targetDirPath/$relativePath/$fileName" | sed -E "s|//|/|g" | sed -E "s|//|/|g"`
    compressArgs=$( getCompressArgs "$extension")

    mkdir -p "$targetDirPath/$relativePath"
    mkdir -p "$backupDirPath/$relativePath"
    convert $sourceFilePath -verbose -strip -quality 90 -interlace JPEG -colorspace sRGB $targetFilePath

    targetSize=`du "$targetFilePath" |cut -f1`

    sizeDifference=$(( ( ($originSize-$targetSize)*100 )/$originSize ))

    if [[ $sizeDifference > $expectedCompressionRatio ]];
    then
          echo "+++++++++++: $fileName => $originSize:$targetSize => $sizeDifference%  "
          cp $sourceFilePath "$backupDirPath/$relativePath/$fileName"
          mv $targetFilePath $sourceFilePath
        else
          echo "-----------: $fileName => $originSize:$targetSize => $sizeDifference% "
        fi
done

