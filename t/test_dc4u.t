#!/usr/bin/env perl

use strict;
use warnings;
use v5.32;

use Test::More tests => 20;
use FindBin;
use lib "$FindBin::Bin/../lib";

# Test DC4U modules
use_ok('DC4U');
use_ok('DC4U::Lexer');
use_ok('DC4U::Parser');
use_ok('DC4U::Generator');
use_ok('DC4U::Template');
use_ok('DC4U::Config');
use_ok('DC4U::Logger');

# Test Lexer
my $lexer = DC4U::Lexer->new();
ok($lexer, 'Lexer created successfully');

my $test_input = '`PDF`<John Doe; S1234567A; Chinese; 30; M; Singaporean>[Theft; 01/01/2023; stole a wallet]@s379 Penal Code@{Officer Smith; IO, CID; 02/01/2023}';
my $tokens = $lexer->tokenize($test_input);
ok($tokens, 'Tokens generated successfully');
ok(@$tokens > 0, 'Tokens array not empty');

# Test Parser
my $parser = DC4U::Parser->new();
ok($parser, 'Parser created successfully');

my $parsed = $parser->parse($tokens);
ok($parsed, 'Parsing completed');
ok($parsed->{output_format} eq 'PDF', 'Output format parsed correctly');
ok($parsed->{suspect_info}->{name} eq 'John Doe', 'Suspect name parsed correctly');
ok($parsed->{charge_info}->{title} eq 'Theft', 'Charge title parsed correctly');

# Test Generator
my $generator = DC4U::Generator->new();
ok($generator, 'Generator created successfully');

my $config = DC4U::Config->new();
ok($config, 'Config created successfully');

my $html_output = $generator->generate($parsed, 'HTML', $config);
ok($html_output, 'HTML generation successful');
ok($html_output =~ /John Doe/, 'Generated HTML contains suspect name');

# Test Template
my $template = DC4U::Template->new();
ok($template, 'Template created successfully');

# Test Logger
my $logger = DC4U::Logger->new('INFO');
ok($logger, 'Logger created successfully');

# Test error handling
my $invalid_tokens = [
    { type => 'OUTPUT_FORMAT', value => '`' },
    { type => 'WORD', value => 'INVALID' }
];

my $invalid_parsed = $parser->parse($invalid_tokens);
ok($invalid_parsed->{error}, 'Error handling works correctly');

# Test configuration
ok($config->get('jurisdiction') eq 'singapore', 'Default jurisdiction is Singapore');
ok($config->get('singapore.court_name') eq 'State Courts of Singapore', 'Singapore court name correct');

print "All tests passed!\n";
