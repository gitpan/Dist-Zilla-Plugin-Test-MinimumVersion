use strict;
use warnings;
use Test::More 0.96 tests => 2;
use Test::Output;
use Test::DZil;
use Moose::Autobox;

my $tzil;

stderr_like(
    sub {
        $tzil = Builder->from_config(
            { dist_root => 'corpus/DZ1' },
            { add_files => {
                'source/dist.ini' => simple_ini('GatherDir', 'MinimumVersionTests')
                }
            },
        );
    },
    qr/^!!!.*deprecate/m,
    'Got a deprecation warning'
);
$tzil->build;

my @xtests = map $_->name =~ m{^xt/} ? $_->name : (), $tzil->files->flatten;
ok(
    (grep { $_ eq 'xt/release/minimum-version.t' } @xtests),
    'minimum-version.t exists'
) or diag explain \@xtests;
