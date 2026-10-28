#!/usr/bin/env bash
# Report typographic "AI tells" (long dashes, smart quotes, single-char ellipsis,
# invisible or non-breaking spaces) in UTF-8 text files. Exit 1 if any are found.
# Usage: find-ai-tells.sh <file> [file...]
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: $0 <file> [file...]" >&2
  exit 2
fi

# perl keeps this independent of the shell's locale and bash version.
perl -CSD -ne '
  BEGIN { $found = 0 }
  if (/[\x{2013}\x{2014}\x{2015}\x{2018}\x{2019}\x{201A}\x{201C}\x{201D}\x{201E}\x{2026}\x{00A0}\x{00AD}\x{200B}\x{200C}\x{200D}\x{202F}\x{2060}\x{FEFF}]/) {
    $found = 1;
    my $line = $_;
    $line =~ s/([\x{2013}-\x{2015}\x{2018}-\x{201E}\x{2026}\x{00A0}\x{00AD}\x{200B}-\x{200D}\x{202F}\x{2060}\x{FEFF}])/sprintf("[U+%04X]", ord($1))/ge;
    print "$ARGV:$.: $line";
  }
  close ARGV if eof;
  END {
    if ($found) {
      print STDERR "AI tells found. Long dash -> , : ( ) or -; smart quotes -> plain quotes; ellipsis -> ...; special spaces -> space.\n";
      exit 1;
    }
    print "clean\n";
  }
' "$@"
