#!/bin/bash

backup_files () {
    echo "Copying Files..."
    notify-send "Copying Files..."
    target_dir="$target_of $(date)"
    cd "$target_of"
    mkdir -p "$target_of"/"$target_dir"
    cp -r "$target_if" "$target_of"/"$target_dir"
  }

select_if () {
    target_if="$(zenity --file-selection --directory --title="Choose a Directory to Back Up")"
    echo "$target_if"
  }

select_of () {
    target_of="$(zenity --file-selection --directory --title="Where do you want these files to go?")"
    echo "$target_of"
  }

select_if
select_of
backup_files
