# ABSTRACT: Plack middleware to set X-Frame-Options.

package Plack::Middleware::XFrameOptions::All;

use strict;
use warnings;

use parent 'Plack::Middleware';

use Plack::Util;
use Plack::Util::Accessor qw/policy/;

sub call {
    my ($self, $env) = @_;

    my $res = $self->app->($env);
    Plack::Util::response_cb($res, sub {
	my $res = shift;

	my $h = Plack::Util::headers($res->[1]);

	# Only process text/html.
	return unless $h->get('Content-Type') =~ qr{text/html};

	$h->set('X-Frame-Options', $self->policy);
    });
}

sub prepare_app {
    my $self = shift;
    $self->policy('sameorigin') unless defined $self->policy;
}

=head1 AUTHOR

Gea-Suan Lin, C<< <gslin at gslin.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Gea-Suan Lin.

This software is released under 3-clause BSD license. See
L<http://www.opensource.org/licenses/bsd-license.php> for more
information.

=cut

1;
