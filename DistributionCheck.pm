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
package DistributionCheck;

use base qw(Check IdentifyDistribution);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking Linux Distribution";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	my $result = $self;

	my $distro_ID = IdentifyDistribution->execute();

	if ($distro_ID) {

		$result->{RESULT} = $distro_ID;

		if ($distro_ID eq 'arch') {

			$result->{RESULTKIND} = "good";
			$result->{COMMENT} = "Official Pro Audio documentation for $distro_ID: https://wiki.archlinux.org/index.php/Pro_Audio";

		}

		elsif ($distro_ID eq 'fedora') {

			$result->{RESULTKIND} = "good";
			$result->{COMMENT} = "Official Pro Audio documentation for $distro_ID: https://wiki.archlinux.org/index.php/Pro_Audiohttps://fedoraproject.org/wiki/Documentation_for_Musicians";

		}

		else {
			$result ->{RESULTKIND} = "not good";
			$result->{COMMENT} = "Not an actual problem: your distribution does not have an Official Pro Audio Documantation page";
		}
	}

	else {
		$result->{RESULT} = "Unidentified Distribution";
		$result->{RESULTKIND} = "not good";
		$result->{COMMENT} = "Not an actual problem: I cannot supply a link for an Official Pro Audio Documantation page for yor Distribution";
	}

	return $result;
}

1;
