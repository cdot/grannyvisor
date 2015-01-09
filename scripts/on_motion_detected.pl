#!/usr/bin/perl
# Run by motion when an event is detected
# Generate web page with latest videos and JPGs from last motion
use strict;

use CGI;
use constant TRACE => 0;

our %config;

# Load shared configuration file
die "No .config/grannyvisor" unless
    open(F, '<', "$ENV{HOME}/.config/grannyvisor");
$/ = undef;
eval(<F>);
die $@ if $@;
close(F);

my $mot_dir = "$ENV{HOME}/motion";
die "Could not open $mot_dir: $!" unless opendir(D, $mot_dir);
my @files = reverse sort grep { /^\d{14}.*\.(swf|jpg)$/ } readdir(D);
closedir(D);
print STDERR "$#files images in $mot_dir\n" if TRACE;

my $latest = $files[0] || 'UNKNOWN';
$latest =~ s/^(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d).*$/$4:$5:$6 $3.$2.$1/;

open(R, '<', "$mot_dir/template.html") || die "Failed to open template";
my $html = <R>;
close(R);

open(W, '>', "$mot_dir/index.html") || die "Failed to write index";

$html =~ s/{{latest}}/$latest/gs;

foreach my $ext ( qw( jpg swf )) {
    $html =~ /\{\{start $ext\}\}(.*?)\{\{end $ext\}\}/s;
    my $tmpl = $1;
    my $i = $config{KEEP}->{$ext} || 12;
    my $all = '';
    foreach my $f (grep { /\.$ext$/ } @files) {
	if ($i-- > 0) {
	    my $x = $tmpl;
	    $x =~ s/\{\{file\}\}/$f/gs;
	    $all .= $x;
	} else {
	    unlink("$mot_dir/$f");
	}
    }
    $html =~ s/\{\{start $ext\}\}.*?\{\{end $ext\}\}/$all/s;
}

print W $html;
close(W);

1;
__END__

