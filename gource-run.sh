#!/usr/bin/env bash
gource --key --user-image-dir avatars --seconds-per-day .15 combinedlog.txt --hide dirnames,filenames --logo ../BitBucket/simpleltc-logo.png --loop --caption-file captions.log --caption-offset -1% --caption-duration 3
