#!/bin/sh
cd /run/media/hd1;
/usr/bin/rsync -av --delete cpan-rsync.perl.org::CPAN CPAN
