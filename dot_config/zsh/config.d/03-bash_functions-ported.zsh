# Convert a unix timestamp to a readable format (like date12h in .bash_aliases)
dateFromEpoch()
{
    #date +'%a %b %d %I:%M:%S %p %Z %Y' -d "@${1}"
    date -r "${1}"
}
