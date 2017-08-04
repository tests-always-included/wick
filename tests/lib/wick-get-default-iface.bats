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
    . "$WICK_DIR/lib/wick-get-default-iface"
}

disableWickGetIfaceForIp() {
    wickGetIfaceForIp() {
        return 1
    }
}

@test "lib/wick-get-default-iface: wickGetIfaceForIp" {
    local RESULT

    wickGetIfaceForIp() {
        local "$1" && wickIndirect "$1" "wlan0"
    }
    wickGetDefaultIface RESULT
    [ "$RESULT" == wlan0 ]
}

@test "lib/wick-get-default-iface: route (Linux)" {
    local RESULT

    disableWickGetIfaceForIp
    mock-command wickCommandExists wick-get-default-iface/wick-command-exists-route
    mock-command route wick-get-default-iface/route-linux
    wickGetDefaultIface RESULT
    [ "$RESULT" == eth0 ]
}

@test "lib/wick-get-default-iface: route (BSD)" {
    local RESULT

    disableWickGetIfaceForIp
    mock-command wickCommandExists wick-get-default-iface/wick-command-exists-route
    mock-command route wick-get-iface-for-ip/route-bsd
    RESULT=unchanged
    wickGetDefaultIface RESULT && return 1
    [[ "$RESULT" == unchanged ]]
}

@test "lib/wick-default-iface: netstat (Linux)" {
    local RESULT

    disableWickGetIfaceForIp
    mock-command wickCommandExists wick-get-default-iface/wick-command-exists-netstat
    mock-command netstat wick-get-default-iface/netstat-linux
    wickGetDefaultIface RESULT
    [[ "$RESULT" == "wlx7cdd909eef58" ]]
}

@test "lib/wick-default-iface: netstat (BSD)" {
    local RESULT

    disableWickGetIfaceForIp
    mock-command wickCommandExists wick-get-default-iface/wick-command-exists-netstat
    mock-command netstat wick-get-default-iface/netstat-bsd
    wickGetDefaultIface RESULT
    [[ "$RESULT" == "en0" ]]
}
