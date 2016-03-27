sub Identify_Distro {

# Try to detect which distribution we are running on. Search for /etc/os-release
# first, then for /usr/lib/os-release (fallback option). As a second option,
# search for /etc/lsb-release. If they are not found, search for distro specific
# files.

# Initialize distro identifier:
my $distro_ID = undef;

# Initialize target release file variable:
my $release_targetfile = undef;

# Check os-release files, if any ###############################################

if (-e '/etc/os-release') {
	$release_targetfile = '/etc/os-release';
} elsif (-e '/etc/lib/os-release') {
	$release_targetfile = '/etc/lib/os-release';
}

if ($release_targetfile) {
	open(my $in, "<", $release_targetfile);
	my @inarr = <$in>;
	close $in;

	chomp @inarr;
	foreach (@inarr[0..($#inarr - 1)]){ # Last elment is a newline
		(my $key) = $_ =~ /(.*)?\=/;
		(my $value) = $_ =~ /=(.*)$/;

		if ($key eq "ID"){
			$distro_ID = lc $value; # Force Lowercase
		}
	}
}

# Check lsb-release files, if any ##############################################

unless ($distro_ID) { # Execute only if distro has not been detected yet.

	if (-e '/etc/lsb-release') {
		$release_targetfile = 'etc/lsb-release';
	}

	if ($release_targetfile) {
		open(my $in, "<", $release_targetfile);
		my @inarr = <$in>;
		close $in;

		chomp @inarr;
		foreach (@inarr[0..($#inarr - 1)]) {
			(my $key) = $_ =~ /(.*)?\=/;
			(my $value) = $_ =~ /=(.*)$/;

			if ($key eq "DISTRIB_ID") {
				$distro_ID = lc $value;
			}
		}
	}
}

# If distro was not detected, search for distro specific files #################

unless ($distro_ID) {

	my @distarr = ( # These distros can have specific files.
		'arch',
		'debian',
		'fedora',
		'gentoo',
		'knoppix',
		'lfs',
		'mageia',
		'pld',
		'redhat',
		'slackware',
		'opensuse',
		'turbolinux'
		);

	foreach (@distarr) {

		if ($_ eq 'opensuse') {
			if (
			-e '/etc/SuSE-release' ||
			-e '/etc/novell-release' ||
			-e '/etc/sles-release' ||
			-e '/etc/nld-release'
			) {
				$distro_ID = $_;
			}
		} else {
			if (
			-e "/etc/$_-release" ||
			-e "/etc/$_-version" ||
			-e "/etc/$_".'_release' ||
			-e "/etc/$_".'_version'
			) {
				$distro_ID = $_;
			}
		}
	}
}

return $distro_ID;

}
