# Golang DD-WRT Makefile
# Compiling for mips32le with FPU support  
# Confirmed working with DD-WRT + Broadcom (BCM)
BINARY=hello

# Go binary
GOBINARY="go-mips32/bin/go"

# Go build flags
GOOS=linux
GOARCH=mipsle
GOMIPS=soft-float,mips32r2

# LDFLAGS
LDFLAGS=-s -w

# GOOS=linux GOARCH=mipsle GOMIPS=soft-float,mips32r2 go-mips32/bin/go build -a -ldflags='-s -w' -o hello -a main.go
all:
	GOOS=${GOOS} GOARCH=${GOARCH} GOMIPS=${GOMIPS} ${GOBINARY} build -a -ldflags='${LDFLAGS}' -o ${BINARY} main.go
