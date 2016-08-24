#!../../../bats/bats

path="formulas/wick-base/functions/wick-service-get-name-argument-systemd"
setup() {
    load ../../../wick-test-base
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-get-arguments"
    . "$WICK_DIR/lib/wick-get-argument"
    . "$WICK_DIR/$path"
}

@test "$path: No extension provided" {
    local seriveName

    wickServiceGetNameArgumentSystemd serviceName 0 thing

    [[ "$serviceName" == thing.service ]]
}

@test "$path: No extension but the name ends in service" {
    local serviceName

    wickServiceGetNameArgumentSystemd serviceName 0 my-service

    [[ "$serviceName" == my-service.service ]]
}

@test "$path: Target extension provided" {
    local serviceName

    wickServiceGetNameArgumentSystemd serviceName 1 whatever thing.target

    [[ "$serviceName" == thing.target ]]
}

@test "$path: Timer extension provided" {
    local serviceName

    wickServiceGetNameArgumentSystemd serviceName 0 thing.timer

    [[ "$serviceName" == thing.timer ]]
}

@test "$path: Service extension provided" {
    local serviceName

    wickServiceGetNameArgumentSystemd serviceName 0 thing.timer

    [[ "$serviceName" == thing.timer ]]
}
