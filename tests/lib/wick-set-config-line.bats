#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-set-config-line"
    . "$WICK_DIR/lib/wick-indirect"
    mkdir /tmp/wick-set-config-line_$$
}

teardown() {
    rm -rf /tmp/wick-set-config-line_$$
}

# Override wickTempDir
wickTempDir() {
    DIR=/tmp/wick-set-config-line_$$/temp
    mkdir "$DIR"
    local "$1" && wickIndirect "$1" "$DIR"
}

@test "lib/wick-set-config-line: missing file" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
some-line yes
EOF
    wickSetConfigLine actual "some-line yes"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: file exists with newline at end" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
Line 1
Additional line
EOF
    cat >> actual <<'EOF'
Line 1
EOF
    wickSetConfigLine actual "Additional line"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: file exists without newline at end" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected << 'EOF'
This line has no newline
Additional line
EOF
    echo -n "This line has no newline" >> actual
    wickSetConfigLine actual "Additional line"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: line already exists" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
LineOne 1
LineTwo 2
LineFour 4
LineFive 5
LineThree three
EOF
    cat >> actual <<'EOF'
LineOne 1
LineTwo 2
LineThree 3
LineFour 4
LineFive 5
EOF
    wickSetConfigLine actual "LineThree three"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: key parsing with space" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
First line
Last line
A correct
EOF
    cat >> actual <<'EOF'
First line
A 1
Last line
EOF
    wickSetConfigLine actual "A correct"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: key parsing with colon" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
First line
Last line
A: correct
EOF
    cat >> actual <<'EOF'
First line
A:3
Last line
EOF
    wickSetConfigLine actual "A: correct"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: key parsing with equals" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
First line
Last line
A=correct
EOF
    cat >> actual <<'EOF'
First line
A=2
Last line
EOF
    wickSetConfigLine actual "A=correct"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: keys must have = or space or : after" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
asdf
not replaced
EOF
    cat >> actual <<'EOF'
asdf
EOF
    wickSetConfigLine actual "not replaced" "asdf"
    diff -U5 expected actual
}

@test "lib/wick-set-config-line: specifying a key" {
    cd /tmp/wick-set-config-line_$$
    cat >> expected <<'EOF'
asdf
replaced
EOF
    cat >> actual <<'EOF'
asdf
fdsa=something
EOF
    wickSetConfigLine actual "replaced" "fdsa"
    diff -U5 expected actual
}
