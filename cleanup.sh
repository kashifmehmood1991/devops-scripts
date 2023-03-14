#!/bin/bash
while getopts 'f:m:r:h' OPTION; do
  case "$OPTION" in
    f)
      folder_path="$OPTARG"
      echo "folder path: $folder_path "
      ;;
    m)
      max_folder_count="$OPTARG"
      echo "max_folder_count: $max_folder_count"
      ;;
    r)
      max_folder_age=$(echo "$OPTARG * 24 * 60 * 60" |bc )
      echo "max_folder_age: $max_folder_age"
      ;;
    h)
      echo "script usage:"
      echo "cleanup.sh [-f backup foler path] [-m max_folder_count ] [-r  max_folder_age]" >&2
      exit 1
      ;;
  esac
done

cd "$folder_path" || exit 1 # change directory to folder path or exit if it fails

# count the number of folders in the folder path
folder_count=$(find . -maxdepth 1 -type d -not -name "." | wc -l)

# check if the folder count is greater than the maximum allowed
if (( folder_count > max_folder_count )); then
  # loop over all folders in the folder path
  while IFS= read -r folder; do
    # calculate the age of the folder in seconds
    folder_age=$(( $(date +%s) - $(stat -c %Y "$folder") ))

    # check if the folder age is greater than the maximum allowed
    if (( folder_age > max_folder_age )); then
      # remove the folder
     # rm -rf "$folder"
     if [[ -d $folder ]] ; then
      rm -rf "$folder"
      echo "Removed folder: $folder"
     fi
    fi
  done < <(find . -maxdepth 1 -type d -not -name "." -printf '%P\n' | sort)
fi
