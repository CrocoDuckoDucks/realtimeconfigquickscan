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
package GenerateComment;

use base qw(IdentifyDistribution);

sub execute
{
	my $self = shift;
	my $caller = shift;
	my $addstr = shift;

	my $distro_ID = IdentifyDistribution->execute();

	my $defcomm = "";
	my $addcomm = "";

	if ($distro_ID) {
		$addcomm = "\nFor your Distribution, see also: ";
	}

	if ($caller eq "GovernorCheck") {

		$defcomm = "Set CPU Governors to 'performance' with 'cpufreq-set -c <cpunr> -g performance'\n" .
			"See also: http://linuxmusicians.com/viewtopic.php?f=27&t=844";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/CPU_frequency_scaling";
		}
        
        elsif ($distro_ID eq 'debian') {
            $addcomm = $addcomm. "https://wiki.debian.org/HowTo/CpuFrequencyScaling";
        }

		elsif ($distro_ID eq 'fedora') {
			$addcomm = $addcomm. "https://docs.fedoraproject.org/en-US/Fedora/20/html/Power_Management_Guide/cpufreq_governors.html";
		}

		else {
			$addcomm = "";
		}

	}

	elsif ($caller eq "SwappinessCheck") {

		$defcomm = "** vm.swappiness is larger than 10\n" .
			"set it with '/sbin/sysctl -w vm.swappiness=10'\n".
			"See also: http://linuxmusicians.com/viewtopic.php?f=27&t=452&start=30#p8916";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Swap#Swappiness";
		}

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "BackgroundCheck") {

		$defcomm = "See also: http://wiki.linuxaudio.org/wiki/system_configuration#disabling_resource-intensive_daemons_services_and_processes";
		$addcomm = "";
	}

	elsif ($caller eq "WatchesCheck") {

		$defcomm = "increase max_user_watches by adding 'fs.inotify.max_user_watches = 524288' to /etc/sysctl.conf and rebooting\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#sysctlconf";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#System_Configuration";
		}

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "HpetCheck") {

		$defcomm = "/dev/hpet found, but not readable.\n".
			"make /dev/hpet readable by the 'audio' group\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#hardware_timers";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#System_Configuration";
		}

		else {
			$addcomm = "";
		}

	}

	elsif ($caller eq "RtcCheck") {

		$defcomm = "$addstr found, but not readable.\n".
			"make $addstr readable by the 'audio' group\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#hardware_timers";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#System_Configuration";
		}

		else {
			$addcomm = "";
		}

	}

	elsif ($caller eq "AudioGroupCheck") {

		$defcomm = "add yourself to the audio group with 'adduser \$USER audio'\n";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#System_Configuration";
		}
        
        elsif ($distro_ID eq 'debian') {
            $addcomm = $addcomm. "https://wiki.debian.org/SoundConfiguration";
        }

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "RtprioCheck") {

		$defcomm = "Could not assign a 80 rtprio value. Set up limits.conf.\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#limitsconfaudioconf";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#System_Configuration";
		}

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "HighResTimersCheck") {

		$defcomm = "Try enabling high-resolution timers (CONFIG_HIGH_RES_TIMERS under 'Processor type and features')\n";
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#installing_a_real-time_kernel\n".
			"http://irc.esben-stien.name/mediawiki/index.php/Setting_Up_Real_Time_Operation_on_GNU/Linux_Systems#Kernel";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#Realtime_Kernel";
		}
        
        if ($distro_ID eq 'debian') {
            $addcomm = $adcomm. "https://wiki.debian.org/DebianMultimedia#Realtime_kernel";
        }

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "PreemptRtCheck") {

		$defcomm = "Kernel without real-time capabilities found\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#installing_a_real-time_kernel";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#Realtime_Kernel";
		}
        
        if ($distro_ID eq 'debian') {
            $addcomm = $adcomm. "https://wiki.debian.org/DebianMultimedia#Realtime_kernel";
        }

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "Hz1000Check") {

		$defcomm = "Try setting CONFIG_HZ to 1000\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#installing_a_real-time_kernel\n".
			"http://www.rosegardenmusic.com/wiki/frequently_asked_questions#what_does_system_timer_resolution_is_too_low_mean\n".
			"http://irc.esben-stien.name/mediawiki/index.php/Setting_Up_Real_Time_Operation_on_GNU/Linux_Systems#Kernel";

		if ($distro_ID eq 'arch') {
			$addcomm = $addcomm. "https://wiki.archlinux.org/index.php/Pro_Audio#Realtime_Kernel";
		}
        
        if ($distro_ID eq 'debian') {
            $addcomm = $adcomm. "https://wiki.debian.org/DebianMultimedia#Realtime_kernel";
        }

		else {
			$addcomm = "";
		}
	}

	elsif ($caller eq "NoHzCheck") {

		$defcomm = "Try enabling tickless timer support (CONFIG_NO_HZ_IDLE, or CONFIG_NO_HZ in older kernels)\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#installing_a_real-time_kernel\n".
			"http://irc.esben-stien.name/mediawiki/index.php/Setting_Up_Real_Time_Operation_on_GNU/Linux_Systems#Kernel";
		$addcomm = "";
	}

	my $comment = $defcomm. $addcomm;
	return $comment;
}

1;
