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
package WatchesCheck;

use base qw(Check GenerateComment);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking checking sysctl inotify max_user_watches";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	my $caller = ref($self);

	if (`cat /proc/sys/fs/inotify/max_user_watches` < 524288)
	{
		$self->{RESULTKIND} = "not good";
		$self->{RESULT} = "< 524288";
		$self->{COMMENT} = GenerateComment->execute($caller);
	} else {
		$self->{RESULTKIND} = "good";
		$self->{RESULT} = ">= 524288";
		$self->{COMMENT} = undef;
	}
}

1;
