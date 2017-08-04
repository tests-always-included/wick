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
    . "$WICK_DIR/lib/wick-get-iface-for-ip"
}

@test "lib/wick-get-iface-for-ip: ip" {
    local RESULT

    mock-command wickCommandExists wick-get-iface-for-ip/wick-command-exists-ip
    mock-command ip wick-get-iface-for-ip/ip
    wickGetIfaceForIp RESULT 192.0.0.8
    [ "$RESULT" == eth0 ]
}

@test "lib/wick-get-iface-for-ip: route (BSD)" {
    local RESULT

    mock-command wickCommandExists wick-get-iface-for-ip/wick-command-exists-route
    mock-command route wick-get-iface-for-ip/route-bsd
    wickGetIfaceForIp RESULT 192.0.0.8
    [ "$RESULT" == utun2 ]
}

@test "lib/wick-get-iface-for-ip: route (Linux)" {
    local RESULT

    mock-command wickCommandExists wick-get-iface-for-ip/wick-command-exists-route
    mock-command route wick-get-iface-for-ip/route-linux
    RESULT=unchanged
    wickGetIfaceForIp RESULT 192.0.0.8 && return 1
    [[ "$RESULT" == unchanged ]]
}
