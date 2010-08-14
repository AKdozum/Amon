use strict;
use warnings;
use Test::More;
use Test::Requires 'HTML::FillInForm::Lite';
use File::Spec;
use File::Temp qw/tempdir/;

BEGIN {
    $INC{'MyApp/Web/Dispatcher.pm'} = __FILE__;
    $INC{'MyApp.pm'} = __FILE__;
}

my $tmp = tempdir(CLEANUP => 1);

{
    package MyApp;
    use parent qw/Amon2/;

    __PACKAGE__->config({
        'Text::MicroTemplate::File' => {
            include_path => [$tmp],
        },
    });

    package MyApp::Web;
    use parent qw/MyApp Amon2::Web/;
    __PACKAGE__->setup(
        view_class => 'Text::MicroTemplate::File',
    );
    __PACKAGE__->load_plugins(
        'Web::FillInFormLite' => {},
    );
}

my $c = MyApp::Web->bootstrap();

{
    open my $fh, '>', File::Spec->catfile($tmp, 'hoge.mt') or die $!;
    print $fh <<'...';
<html>
<head>
</head>
<body>
<form action="/" method="post">
<input type="text" name="body" />
<input type="submit" name="post" />
</form>
</body>
</html>
...
    close $fh;
}

my $res = $c->render('hoge.mt')->fillin_form({body => "hello"});
like $res->body(), qr{<input type="text" name="body" value="hello" />};
done_testing;