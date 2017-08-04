#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-prefix-lines"
    . "$WICK_DIR/lib/wick-log"
    . "$WICK_DIR/lib/wick-array-join"
    . "$WICK_DIR/lib/wick-debug"
    . "$WICK_DIR/lib/wick-get-arguments"
    . "$WICK_DIR/lib/wick-get-argument"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-get-iface-ip"

    DEFAULT_IFACE=

    wickGetDefaultIface() {
        if [[ -n "$DEFAULT_IFACE" ]]; then
            local "$1" && wickIndirect "$1" "$DEFAULT_IFACE"

            return 0
        fi

        return 1
    }
}

#
# ifconfig on GNU
#

@test "lib/wick-get-iface-ip: ifconfig (gnu) - one iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    wickGetIfaceIp RESULT lo
    [ "$RESULT" == $'127.0.0.1' ]
}

@test "lib/wick-get-iface-ip: ifconfig (gnu) - auto iface (eth0)" {
    local RESULT

    DEFAULT_IFACE=eth0
    mock-command ifconfig wick-get-iface-ip/ifconfig-gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    wickGetIfaceIp RESULT
    [ "$RESULT" == "172.18.42.1" ]
}

@test "lib/wick-get-iface-ip: ifconfig (gnu) - auto iface (can't detect)" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    wickGetIfaceIp RESULT
    [ "$RESULT" == "172.17.42.1" ]
}

@test "lib/wick-get-iface-ip: ifconfig (gnu) - bad iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    ! wickGetIfaceIp RESULT asdf
}

@test "lib/wick-get-iface-ip: ifconfig (gnu) - iface without ip" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-gnu
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-no-ip
    ! wickGetIfaceIp RESULT noip
}

#
# ifconfig on BSD
#

@test "lib/wick-get-iface-ip: ifconfig bsd - one iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    wickGetIfaceIp RESULT re1
    [ "$RESULT" == "192.168.0.103" ]
}

@test "lib/wick-get-iface-ip: ifconfig bsd - auto iface (eth1)" {
    local RESULT

    DEFAULT_IFACE=eth1
    mock-command ifconfig wick-get-iface-ip/ifconfig-bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    wickGetIfaceIp RESULT
    [ "$RESULT" == "201.6.5.4" ]
}

@test "lib/wick-get-iface-ip: ifconfig bsd - auto iface (can't detect)" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    wickGetIfaceIp RESULT
    [ "$RESULT" == "192.168.0.103" ]
}

@test "lib/wick-get-iface-ip: ifconfig bsd - bad iface" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    ! wickGetIfaceIp RESULT asdf
}

@test "lib/wick-get-iface-ip: ifconfig bsd - iface without ip" {
    local RESULT

    mock-command ifconfig wick-get-iface-ip/ifconfig-bsd
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ifconfig
    ! wickGetIfaceIp RESULT noip
}

#
# ip
#

@test "lib/wick-get-iface-ip: ip - auto iface (wlx7cdd909eef58)" {
    local result

    DEFAULT_IFACE=wlx7cdd909eef58
    mock-command ip wick-get-iface-ip/ip
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ip

    wickGetIfaceIp result

    [[ "$result" == 192.168.0.80 ]]
}

# Really weird scenario
@test "lib/wick-get-iface-ip: ip - auto iface (can't find?)" {
    local result

    mock-command ip wick-get-iface-ip/ip
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ip

    wickGetIfaceIp result

    [[ "$result" == 127.0.0.1 ]]
}

@test "lib/wick-get-iface-ip: ip - eth0 iface" {
    local result

    mock-command ip wick-get-iface-ip/ip
    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-ip

    wickGetIfaceIp result eth0

    [[ "$result" == 192.168.70.238 ]]
}

#
# No working commands
#

@test "lib/wick-get-iface-ip: No commands found to get ips" {
    local result

    mock-command wickCommandExists wick-get-iface-ip/wick-command-exists-none
    ! wickGetIfaceIp result tun0
}
