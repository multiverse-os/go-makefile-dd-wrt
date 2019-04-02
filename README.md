# Building Go Programs For DD-WRT Routers

Having a difficult time finding an obvious solution I read through relevant Go development forums and pieced together a working solution that allows one to build Go binaries that work on DD-WRT routers. I used an ASUS RT-AC66U, so this method is confirmed working with Broadcom (BCM) routers running the DD-WRT software. Frustrated with the annoying responses to people asking for help, typically being told to just use different software, specifically Open-WRT, a solution that does not work work out of the box for the router I'm currently working with. So I put together this package to help explain how a development environment for developing Go programs can be setup, and how to quickly use this project as a scaffold to compile your own programs. 

## Starting from scratch
One will need to start by installing Go, because Go is needed to build modern versions of Go, so once you installed Golang 1.8 from `apt-get` using the command:

```bash
    apt-get install golang
```

Once you have Go installed, you can start the process of building a DD-WRT Go development environment by building a patched version of Go 1.8 with mips32 with FPU support.

```bash
    # Create the project folder
    mkdir project && cd project

    git clone https://go.googlesource.com/go go-mips32
    cd go-mips32
    git reset --hard 26e726c3092264584053a4f81714dcc8c91d2153
    git pull https://go.googlesource.com/go refs/changes/58/37958/1
    cd src
    GOROOT_BOOTSTRAP=/usr/local/go ./make.bash

    # Return to the project folder
    cd ../..
```

If there are no errors, you are very close to being able to build Go software that works on a BCM DD-WRT router, next is building the binary, which we will simplify with a Makefile.

Before we create the Makefile, we will start by enabling SSH on the router, building a very simple "hello world" application and pushing it to the router to test if this will work before making the effort to create the Makefile. 

```bash
    # Confirm everything is working before creating a Makefile
    GOOS=linux GOARCH=mipsle GOMIPS=mips32r2,soft-float go-mips32/bin/go build -a -ldflags '-s -w' main.go
    scp main.go root@router:~/
    ssh root@router
    ./main
```

If everything is working, you should see the "hello world" message appear in your terminal. Now you can build a Makefile utilizing the new patched Go binary, so all one will have to do to compile is type `make`.

```bash
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
```

## Using this project as foundation
Once you have a handle on how this project was created, one may wish to avoid any extra work and simply use it as foundation for creating their own Go based DD-WRT binaries. 

```bash
    git clone (this project)
    # Modify the makefile to match your binary name
    make
    # Then work on the main.go file
```

## Credits
Thanks to the Go developers for creating the patches and the curious users who provided an explanation which saved me a lot of time. I hope others frustrated with some of the answers on forums find this project and help them get directly to the creative bits. 


