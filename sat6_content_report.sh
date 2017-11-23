#!/bin/bash
(
date >>$0.result

HAMMERCMD="hammer"

$HAMMERCMD content-view list  --organization "Default Organization" >cv
for item in $(cat cv|grep -v "CONTENT VIEW"|grep [a-z]|awk '{ print $1 }'); do
        echo "### CV: $item";
        $HAMMERCMD content-view info --id $item --organization "Default Organization" >$item.cv;

        for cv_verid in $(grep -B3 "Components:" $item.cv|grep ID|cut -d: -f2|sed -e 's/[ \t]*//'); do
                $HAMMERCMD package list --content-view-id $item --content-view-version-id $cv_verid >$item.cv.packages
                $HAMMERCMD erratum list --content-view-id $item --content-view-version-id $cv_verid >$item.cv.erratum
        done
        echo "Number of repositories: $(grep Label $item.cv|sed -n '1!p'|wc -l)"
        echo "Number of packages: $(cat $item.cv.packages|wc -l)"
        echo "Number of versions: $(grep Version $item.cv|sed -n '1!p'|wc -l)"
        echo "Number of errata: $(cat $item.cv.erratum|wc -l)"
done
$HAMMERCMD content-host list >content-hosts
echo "Number of content hosts: $(cat content-hosts|wc -l)"
) >>$0.result
