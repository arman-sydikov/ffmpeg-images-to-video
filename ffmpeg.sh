# Define a function
imgToMp4 () {
  # change directory
  cd $1;

  # clear file
  > input.txt;

  # print filenames
  for f in *.jpg;
  do
    echo "file $f" >> input.txt;
    if [ "IMG_20230101_000000.jpg" = $f ]
    then
      echo "duration 2" >> input.txt;
    else
      echo "duration 0.5" >> input.txt;
      # format date to: yyyy-MM-dd HH:mm:ss
      gmtDate=$(mdls -raw -name kMDItemContentCreationDate $f);
      utcDate=$(date -f '%F %T %z' -j "$gmtDate" '+%F %T');
      echo "file_packet_meta date '$utcDate'" >> input.txt;
    fi
  done

  # Due to a quirk, the last image has to be specified twice - the 2nd time without any duration directive
  echo "file $f" >> input.txt;

  # create video
  ffmpeg -y -f concat -i input.txt \
    -vf "fps=25,format=yuv420p,drawtext=text='%{metadata\:date}': fontfile=/System/Library/Fonts/Supplemental/Courier New Bold.ttf: fontcolor=white: fontsize=(h/20): box=1: boxcolor=black@0.5: x=20: y=20: boxborderw=20,scale=-1:720" \
    -c:v libx264 output.mp4;

  # change directory back
  cd ../;
}

imgToMp4 left
imgToMp4 right