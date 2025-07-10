#!/bin/sh

docker image list --format '{{json . }}' | jq -sc '.[] | {Repository, Tag, Size}' \
| jq -s 'map(. + {"originalSize": .Size})' \
| jq -r '
    map(
        if .Size | endswith("GB") then
            .Size |= (gsub("GB"; "") | tonumber * 1024 * 1024 * 1024)
        else
            if .Size | endswith("MB") then
                .Size |= (gsub("MB"; "") | tonumber * 1024 * 1024)
            else
                if .Size | endswith("KB") then
                    .Size |= (gsub("KB"; "") | tonumber * 1024)
                else
                  if .Size | endswith("kB") then
                    .Size |= (gsub("kB"; "") | tonumber * 1024)
                  else
                    .Size | tonumber
                  end
                end
            end
        end
    )' \
| jq 'sort_by(.Size)' \
| jq -r 'map([.originalSize, "\(.Repository):\(.Tag)"] | @tsv)[]'
