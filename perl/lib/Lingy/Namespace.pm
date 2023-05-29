use strict; use warnings;
package Lingy::Namespace;

use Lingy::Common;

use base 'Exporter';

use Sub::Name 'subname';

our @EXPORT = (
    'fn',
);

sub NAME {
    my ($self) = @_;
    $self->{' NAME'} // '';
}

sub new {
    my ($class, %args) = @_;

    my $self = bless {}, __PACKAGE__;

    my $name = $self->{' NAME'} = $args{name} // $class->NAME;

    if (my $refer_list = $args{refer}) {
        $refer_list = [$refer_list]
            unless ref($refer_list) eq 'ARRAY';
        my $refer_map = $Lingy::Main::refer{$name} //= {};
        for my $ns (@$refer_list) {
            my $ns_name = $ns->NAME;
            map $refer_map->{$_} = $ns_name,
                grep /^\S/, keys %$ns;
        }
    }

    no strict 'refs';
    no warnings 'once';
    if (%{"${class}::ns"}) {
        %$self = (
            %$self,
            %{"${class}::ns"},
        );
    }

    $Lingy::Main::ns{$name} = $self;

    return $self;
}

sub current {
    my ($self) = @_;
    my $name = $self->NAME or die;
    $Lingy::Main::ns = $name;
    $Lingy::Main::ns{$name} = $self;
    $Lingy::Main::env->{space} = $self;
    $Lingy::Main::ns{'lingy.core'}{'*ns*'} = $self;
    return $self;
}

sub names {
    my ($self) = @_;
    my %names;
    map {$names{$_} = 1}
        grep {not /^ /}
        keys(%$self),
        keys(%Lingy::Main::ns),
        keys(%{$Lingy::Main::refer{$self->NAME}});
    return keys %names;
}

sub fn {
    my ($name, %functions) = @_;
    (
        $name,
        subname "fn::$name" => sub {
            my $arity = @_;
            my $function =
                $functions{$arity} ||
                $functions{'*'}
                    or err "Wrong number of args ($arity) passed to function";
            $function->(@_);
        }
    );
}

sub getName {
    symbol($_[0]->NAME);
}

sub getImports {
    XXX @_, 'TODO - getImports';
}

sub getInterns {
    my $map = {
        %{$_[0]},
    };
    delete $map->{' NAME'};
    hash_map([ %$map ]);
}

sub getMappings {
    my $map = {
        %{$_[0]},
    };
    my $name = delete $map->{' NAME'};
    my $refer = Lingy::Main->refer->{$name} // {};
    for my $key (keys %$refer) {
        my $ns = $refer->{$key};
        $map->{$key} =
            $Lingy::Main::ns{$ns}->{$key} //
            $Lingy::Main::ns{$key};
    }
    hash_map([ %$map ]);
}

1;
