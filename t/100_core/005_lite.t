use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
    $INC{'MyApp.pm'}++;
    $INC{'MyApp/V/MT.pm'}++;
}

{
    package MyApp;
    use Amon -base;

    package MyApp::V::MT;

    package MyApp::Web;
    use Amon::Web::Lite -base => (
        default_view_class => 'MT',
    );

    get '/' => sub {
        res(200, [], ['ok'])
    };
    get '/hello/:name' => sub {
        my ($c, $args) = @_;
        res(200, [], ["hi, $args->{name}"])
    };
}

my $app = MyApp::Web->to_app();
{
    my $ret = $app->({
        PATH_INFO      => '/',
        REQUEST_METHOD => 'GET',
    });
    is $ret->[2]->[0], 'ok';
}
{
    my $ret = $app->({
        PATH_INFO      => '/hello/tokuhirom',
        REQUEST_METHOD => 'GET',
    });
    is $ret->[2]->[0], 'hi, tokuhirom';
}

