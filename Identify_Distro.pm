#   Copyright 2010 Arnout Engelen
#
#     This file is part of realtimeconfigquickscan.
#
#    realtimeconfigquickscan is free software: you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    realtimeconfigquickscan is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with realtimeconfigquickscan.
#    If not, see <http://www.gnu.org/licenses/>.
package Identify_Distro;

sub execute
{

	my $distro_ID = undef;

	my $release_targetfile = undef;

	# Check os-release files, if any.

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

# Check lsb-release files, if any.

	unless ($distro_ID) {

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

# Search for distro specific files, if any.

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

1;
