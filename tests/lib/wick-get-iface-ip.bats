#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-prefix-lines"
    . "$WICK_DIR/lib/wick-log"
    . "$WICK_DIR/lib/wick-array-join"
    . "$WICK_DIR/lib/wick-error"
    . "$WICK_DIR/lib/wick-debug-extreme"
    . "$WICK_DIR/lib/wick-command-exists"
    . "$WICK_DIR/lib/wick-get-arguments"
    . "$WICK_DIR/lib/wick-get-argument"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-get-iface-ip"
    . "$WICK_DIR/lib/wick-strict-run"
}

@test "lib/wick-get-iface-ip: gnu - first iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp RESULT

    [ "$RESULT" == "172.17.42.1" ]
}

@test "lib/wick-get-iface-ip: gnu - all ifaces" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp RESULT '*'
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "172.17.42.1" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.0.32" ]
}

@test "lib/wick-get-iface-ip: gnu - bad iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    ! wickGetIfaceIp RESULT asdf
}

@test "lib/wick-get-iface-ip: gnu - one iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp RESULT lo
    [ "$RESULT" == $'127.0.0.1' ]
}

@test "lib/wick-get-iface-ip: gnu - iface without ip" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    ! wickGetIfaceIp RESULT noip
}

@test "lib/wick-get-iface-ip: bsd - first iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp RESULT
    [ "$RESULT" == "192.168.0.103" ]
}

@test "lib/wick-get-iface-ip: bsd - all ifaces" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp RESULT '*'
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "192.168.0.103" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.254.9" ]
}

@test "lib/wick-get-iface-ip: bsd - bad iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    ! wickGetIfaceIp RESULT asdf
}

@test "lib/wick-get-iface-ip: bsd - one iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp RESULT re1
    [ "$RESULT" == "192.168.0.103" ]
}

@test "lib/wick-get-iface-ip: bsd - iface without ip" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    ! wickGetIfaceIp RESULT noip
}

@test "lib/wick-get-iface-ip: ip command - All interfaces" {
    local result

    mock-command ip wick-get-iface-ip/ip
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ifconfig

    wickGetIfaceIp result '*'

    [[ "${#result[@]}" == 3 ]]
    [[ "${result[0]}" == 127.0.0.1 ]]
    [[ "${result[1]}" == 192.168.70.238 ]]
    [[ "${result[2]}" == 10.3.254.2 ]]
}

@test "lib/wick-get-iface-ip: ip command - Get first" {
    local result

    mock-command ip wick-get-iface-ip/ip
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ifconfig

    wickGetIfaceIp result

    [[ "$result" == 127.0.0.1 ]]
}

@test "lib/wick-get-iface-ip: ip command - eth0" {
    local result

    mock-command ip wick-get-iface-ip/ip
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ifconfig

    wickGetIfaceIp result eth0

    [[ "$result" == 192.168.70.238 ]]
}

@test "lib/wick-get-iface-ip: No commands found to get ips" {
    local result

    mock-command ifconfig wick-get-iface-ip/bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-commands
    ! wickGetIfaceIp result tun0
}

# This should only be the case temporarily.  It is affecting
# the way it was being used because ifconfig orders the interfaces
# differently than ip.
@test "lib/wick-get-iface-ip: ifconfig is favored" {
    local result

    mock-command ifconfig wick-get-iface-ip/gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    wickGetIfaceIp result

    [ "$result" == "172.17.42.1" ]
}
