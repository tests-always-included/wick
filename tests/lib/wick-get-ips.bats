#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-prefix-lines"
    . "$WICK_DIR/lib/wick-log"
    . "$WICK_DIR/lib/wick-array-join"
    . "$WICK_DIR/lib/wick-error"
    . "$WICK_DIR/lib/wick-get-arguments"
    . "$WICK_DIR/lib/wick-get-argument"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-get-ips"
}

@test "lib/wick-get-ips: gnu - all ifaces" {
    local RESULT

    mock-command ifconfig wick-get-ips/gnu
    mock-command wickCommandExists wick-get-ips/wick-command-exists-no-ip
    wickGetIps RESULT
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "172.17.42.1" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.0.32" ]
}

@test "lib/wick-get-ips: bsd - all ifaces" {
    local RESULT

    mock-command ifconfig wick-get-ips/bsd
    mock-command wickCommandExists wick-get-ips/wick-command-exists-no-ip
    wickGetIps RESULT
    [ "${#RESULT[@]}" -eq 3 ]
    [ "${RESULT[0]}" == "192.168.0.103" ]
    [ "${RESULT[1]}" == "127.0.0.1" ]
    [ "${RESULT[2]}" == "192.168.254.9" ]
}

@test "lib/wick-get-ips: ip command - All interfaces" {
    local result

    mock-command ip wick-get-ips/ip
    mock-command wickCommandExists wick-get-ips/wick-command-exists-no-ifconfig

    wickGetIps result

    [[ "${#result[@]}" == 3 ]]
    [[ "${result[0]}" == 127.0.0.1 ]]
    [[ "${result[1]}" == 192.168.70.238 ]]
    [[ "${result[2]}" == 10.3.254.2 ]]
}

@test "lib/wick-get-ips: No commands found to get ips" {
    local result

    mock-command ifconfig wick-get-ips/bsd
    mock-command ip wick-get-ips/ip
    mock-command wickCommandExists wick-get-ips/wick-command-exists-no-commands
    ! wickGetIps result tun0
}
