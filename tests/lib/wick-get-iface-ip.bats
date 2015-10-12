#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-get-iface-ip"
}

@test "lib/wick-get-iface-ip: gnu - first iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    wickGetIfaceIp RESULT
    [ "$RESULT" == "172.17.42.1" ]
}

@test "lib/wick-get-iface-ip: gnu - all ifaces" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    wickGetIfaceIp RESULT '*'
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "172.17.42.1" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.0.32" ]
}

@test "lib/wick-get-iface-ip: gnu - bad iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    ! wickGetIfaceIp RESULT asdf
}

@test "lib/wick-get-iface-ip: gnu - one iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    wickGetIfaceIp RESULT lo
    [ "$RESULT" == $'127.0.0.1' ]
}

@test "lib/wick-get-iface-ip: gnu - iface without ip" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    ! wickGetIfaceIp RESULT noip
}

@test "lib/wick-get-iface-ip: bsd - first iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    wickGetIfaceIp RESULT
    [ "$RESULT" == "192.168.0.103" ]
}

@test "lib/wick-get-iface-ip: bsd - all ifaces" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    wickGetIfaceIp RESULT '*'
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "192.168.0.103" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.254.9" ]
}

@test "lib/wick-get-iface-ip: bsd - bad iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    ! wickGetIfaceIp RESULT asdf
}

@test "lib/wick-get-iface-ip: bsd - one iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    wickGetIfaceIp RESULT re1
    [ "$RESULT" == "192.168.0.103" ]
}

@test "lib/wick-get-iface-ip: bsd - iface without ip" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    ! wickGetIfaceIp RESULT noip
}
