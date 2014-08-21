#!/usr/bin/perl

use strict;
use warnings;
use WWW::Curl::Easy;

# ------ Change the lines below ------
my $environment = "http://stream-sandbox.oanda.com";
my $accounts = "<accountId>";
my $accessToken = "<ACCESS-TOKEN>";
my $showHeartBeats = 1;
# ------------------------------------

# ------------------------------------
# The environment variable should be:
# 
# For Sandbox    -> http://stream-sandbox.oanda.com
# For fxPractice -> https://stream-fxpractice.oanda.com
# For fxTrade    -> https://stream-fxtrade.oanda.com
# ------------------------------------

# read response and print transactions
sub callback {
    my ($line) = @_;
    if ($showHeartBeats==1)
    {
        print $line;
    }
    elsif ($line!~/heartbeat/)
    {
        print $line;
    }
    return length($line);
}

my $curl = WWW::Curl::Easy->new;

# don't print header
$curl->setopt(CURLOPT_HEADER,0);

if ($environment=~/fxpractice/ || $environment=~/fxtrade/)
{
    # send access token in header for practice of trade environments
    my @header = ('Authorization: Bearer '.$accessToken);
    $curl->setopt(CURLOPT_HTTPHEADER, \@header);
}

# set url
$curl->setopt(CURLOPT_URL, $environment."/v1/events?accountIds=".$accounts);
# set callback function to print transactions
$curl->setopt(CURLOPT_WRITEFUNCTION,\&callback);

# Starts the actual request
my $retcode = $curl->perform;

# Looking at the results...
if ($retcode == 0) {
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        if ($response_code != 200)
        {
            print "bad request, HTTP code: ".$response_code."\n";
        }
} else {
        # Error code, type of error, error message
        print("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
}
