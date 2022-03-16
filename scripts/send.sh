#!/bin/bash
set -e

SA="$(basename "${GOOGLE_APPLICATION_CREDENTIALS}")"
GDRIVE="./gdrive"

FILE_ID="$("${GDRIVE}" --service-account "${SA}" -c . \
  list -q "'""${PARENT_ID}""' in parents" | \
    sed "1d" | grep "${DEST_FILE_NAME}" | head -n 1 | cut -d" " -f1)"

if test -z "${FILE_ID}" ; then
  "${GDRIVE}" --service-account "${SA}"  -c . \
    upload --no-progress --parent "${PARENT_ID}" --name "${DEST_FILE_NAME}" "${SRC_FILE_NAME}"
else
  "${GDRIVE}" --service-account "${SA}"  -c . \
    update --no-progress "${FILE_ID}" --name "${DEST_FILE_NAME}" "${SRC_FILE_NAME}"
fi
