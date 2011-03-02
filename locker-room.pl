#!/usr/bin/perl

use strict;
use WWW::Mechanize;
use JSON -support_by_pp;

my $user = 'simplebits'; # Your dribbble username, like 'bruce', 'frogandcode'...
  
my $browser = WWW::Mechanize->new();

my $pages = 2;
my $page = 1;

while ($pages >= $page) {
    print "|"; # Every page
    
    my $json_url = "http://api.dribbble.com/players/$user/shots/likes?page=$page&per_page=30";
    $browser->get($json_url);
    my $content = $browser->content();

    my $json = new JSON;
    my $json_text = $json->allow_nonref->utf8->relaxed->escape_slash->loose->allow_singlequote->allow_barekey->decode($content);

    foreach my $shot(@{$json_text->{shots}}) {	
    	print "."; # Every shot
    	
		system ("wget -q $shot->{image_url}");
    }
    
    $pages = $json_text->{pages};
    $page = $json_text->{page} + 1;
}


