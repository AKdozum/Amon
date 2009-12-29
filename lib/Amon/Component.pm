package Amon::Component;
use strict;
use warnings;
use base 'Exporter';
our @EXPORT = qw/config model/;
use Amon::Util;

sub config ()  { Amon->context->config    }
sub model  ($) { Amon->context->model(@_) }

1;
__END__

=head1 NAME

Amon::Component - Amon Component Class

=head1 SYNOPSIS

    use Amon::Component;

=head1 DESCRIPTION

=head1 FUNCTIONS

=over 4

=item config()

get configuration from context object.

=item model($model)

get the model class name.

=back

=head1 SEE ALSO

L<Amon>

=cut

