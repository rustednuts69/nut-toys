#!/bin/bash

# this checks if apps are installed
check_depends () {
  command -v "$1" >/dev/null 2>&1
}

# make sure yad and zenity are there  
if ! check_depends yad || ! check_depends zenity || ! check_depends yt-dlp || ! check_depends mpv; then
    echo "Error: mpv, yad, zenity, and yt-dlp must be installed."
    notify-send "Error: mpv, yad, zenity, and yt-dlp must be installed."
    exit 1
fi

#warn the user if xdg-open doesn't work.  the app can still run without it
if ! check_depends xdg-open; then
  notify-send "Warning: can't find xdg-open. The app will still work, but I can't open your destination folder automatically if you download anything."
fi

# download and play, with audio Only
download_no_video () {
    yt-dlp -x "$vidlink" &
    mpv --no-video "$vidlink"
}

#download and play, with video
download_with_video () {
  yt-dlp "$vidlink" &
  mpv "$vidlink"
}

#this dialog gets the video link, and whether or not the user wants audio only or download
args=$(yad --form --title="Play Video In MPV" \
    --field="Video Link" \
    --field="Audio Only:CHK" \
    --field="Download:CHK")

#this turns the "args" into variables that can be used later
vidlink=$(echo "$args" | cut -d'|' -f1)
audioonly=$(echo "$args" | cut -d'|' -f2)
downloadvideo=$(echo "$args" | cut -d'|' -f3)

#if you're not downloading, just play the content
if [ "$downloadvideo" = "FALSE" ]; then

  if [ "$audioonly" = "TRUE" ]; then
    echo "Playing Audio Without Downloading!"
    mpv --no-video "$vidlink" &
    yad --title="Audio Player" --text="Playing audio..." --button="Cancel:1"
    pkill mpv
  fi

  if [ "$audioonly" = "FALSE" ]; then
    echo "Playing Video Without Downloading!"
    mpv "$vidlink" #no pkill here, since mpv itself is accessible by the user
  fi

fi

#if you're downloading, play and download the content at the same time
if [ "$downloadvideo" = "TRUE" ]; then

  videodest=$(zenity --file-selection --directory --title="Where should the file be saved?")
  cd "$videodest"

  if [ "$audioonly" = "TRUE" ]; then
    download_no_video &
    yad --title="Audio Player" --text="Playing audio and downloading..." --button="Cancel:1"
    pkill mpv #same as playing audio only, but both yt-dlp and mpv are killed
              #if the user closes the yad dialog
    pkill yt-dlp
     
  fi
  
  if [ "$audioonly" = "FALSE" ]; then
    download_with_video &
    yad --title="Video Player" --text="Playing video and downloading..." --button="Cancel:1"
    pkill mpv #same as the audio only one.  even though mpv can be accessed by
              #the user, we still need a way to kill yt-dlp if the user
              #wants to cancel the operation
    pkill yt-dlp
  fi

  xdg-open "$videodest"
fi

