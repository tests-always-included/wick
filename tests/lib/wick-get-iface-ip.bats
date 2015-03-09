#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-get-iface-ip"
    FLAVOR=""
}

ifconfig() {
    local ARG FIXTURE

    FIXTURE="wick-get-iface-ip/$FLAVOR/ifconfig"
    for ARG in "$@"; do
        FIXTURE="${FIXTURE}_$ARG"
    done
    . "$FIXTURE"
}

@test "gnu - first iface" {
    local RESULT

    FLAVOR=gnu
    wick-get-iface-ip RESULT
    [ "$RESULT" == "172.17.42.1" ]
}

@test "gnu - all ifaces" {
    local RESULT

    FLAVOR=gnu
    wick-get-iface-ip RESULT '*'
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "172.17.42.1" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.0.32" ]
}

@test "gnu - bad iface" {
    local RESULT

    FLAVOR=gnu
    ! wick-get-iface-ip RESULT asdf
}

@test "gnu - one iface" {
    local RESULT

    FLAVOR=gnu
    wick-get-iface-ip RESULT lo
    [ "$RESULT" == $'127.0.0.1' ]
}

@test "gnu - iface without ip" {
    local RESULT

    FLAVOR=gnu
    ! wick-get-iface-ip RESULT noip
}

@test "bsd - first iface" {
    local RESULT

    FLAVOR=bsd
    wick-get-iface-ip RESULT
    [ "$RESULT" == "192.168.0.103" ]
}

@test "bsd - all ifaces" {
    local RESULT

    FLAVOR=bsd
    wick-get-iface-ip RESULT '*'
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "192.168.0.103" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.254.9" ]
}

@test "bsd - bad iface" {
    skip "Unknown BSD output"
}

@test "bsd - one iface" {
    local RESULT
    FLAVOR=bsd
    wick-get-iface-ip RESULT re1
    [ "$RESULT" == "192.168.0.103" ]
}

@test "bsd - iface without ip" {
    local RESULT

    FLAVOR=bsd
    ! wick-get-iface-ip RESULT noip
}
