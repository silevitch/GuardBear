#!/bin/perl

use strict;
use warnings;

use Test::More tests => 16;
use Test::WWW::Mechanize;

my $url = 'http://localhost:8080';
my $echo_headers = $url . '/echo_headers';
my $cookie_flag_prefix = 'pb_';
my $test_cookies = ['Test1', 'Test2'];
my $cookie_domain = 'localhost';

{
	note('Make a request with a cookie that is not flagged to be sent to the origin and make sure it is not sent');	
	my $mech = Test::WWW::Mechanize->new;
	$mech->add_header('Cookie' => 'foobar=1;');
	$mech->get_ok($echo_headers);
	$mech->content_lacks('Cookie: foobar=1');

	note('Make a request with a cookie that is flagged to be sent to the origin and make sure it is sent');	
	$mech->add_header('Cookie' => 'foobar=1; ' . $cookie_flag_prefix . 'foobar=1');
	$mech->get_ok($echo_headers);
	$mech->content_contains('Cookie: foobar=1');

}
# Cookies sent from origin get flag cookie added if no mapping

{
	my $mech = Test::WWW::Mechanize->new;
	$mech->get_ok($echo_headers);
	my $headers = $mech->response->headers_as_string;
	foreach my $cookie ( @{ $test_cookies } ) {
		like ( $headers, qr/Set-Cookie: $cookie.*domain=$cookie_domain/, "Cookie $cookie get domain rewritten");
		my $cookie_flag_name = $cookie_flag_prefix . $cookie;
		like ( $headers, qr/Set-Cookie: $cookie_flag_name.*domain=$cookie_domain/, "Cookie flag $cookie_flag_name is set");
	}
}

{
	note('This will make sure that we are masking client IPs sent in X-Forwarded-For header sent to the origin');
	my $mech = Test::WWW::Mechanize->new;
	$mech->get_ok($echo_headers);
	$mech->content_contains('X-Forwarded-For: 0.0.');
	note('Let us pass in a XFF');
	my $xff = '1.2.2.2';
	$mech->add_header('X-Forwarded-For' => $xff);
	$mech->get_ok($echo_headers);
	$mech->content_contains('X-Forwarded-For: ' . $xff . ', 0.0.');
}

{
	note('This will make sure that we are scrubbing Referer headers that are sent to the origin');
	my $mech = Test::WWW::Mechanize->new;
	my $referer_domain = 'https://www.google.com/';
	my $full_referer = $referer_domain . 'a/b/c/d';
	$mech->add_header('Referer' => $full_referer);
	$mech->get_ok($echo_headers);
	$mech->content_contains('Referer: ' . $referer_domain);
	$mech->content_lacks('Referer: ' . $full_referer);
}

