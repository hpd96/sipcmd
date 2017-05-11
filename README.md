# sipcmd
#### A command line SIP/H.323/RTP softphone
  
This repo is a fork of [tmakkonen/sipcmd]()https://github.com/tmakkonen/sipcmd 

To see what changed from the original repo, please refer to [CHANGELOG.md](CHANGELOG.md).

## Description

`sipcmd` is a command line softphone that can originate and accept phone calls, enter DTMF digits and record and play back WAV files.  
It is meant primarily as testing tool for VoIP systems, it only runs on Linux, and it is in no way stable or production ready.  

## Requirements

`sipcmd` requires the [Opal](http://wiki.opalvoip.org/) Voip Library.

## Compile & Install

The build system relies on CMake.

On a typical Ubuntu environment, you can build and install doing the following:

```shell
apt-get install -y git cmake libopal-dev 
git clone https://github.com/stefanotorresi/sipcmd
mkdir -p sipcmd/build
cd sipcmd/build
cmake ..
make -j
sudo make install
```

This will install the binary on `/usr/local/bin/sipcmd`.  

## Usage

These are the command line options:

```
-u --user           <name>  username (required)
-c --password       <pass>  password for registration
-a --alias          <name>  username alias
-l --localaddress   <addr>  local address to listen on
-o --opallog        <file>  enable extra opal library logging to file
-p --listenport     <port>  the port to listen on
-P --protocol       <proto> sip/h323/rtp (required)
-r --remoteparty    <nmbr>  the party to call to
-x --execute        <prog>  program to follow
-d --audio-prefix   <prfx>  recorded audio filename prefix
-f --file           <file>  the name of played sound file
-g --gatekeeper     <addr>  gatekeeper to use
-w --gateway        <addr>  gateway to use
```

**Caveats:**
  
`-l` or `-p` without `-x` assume answer mode. Additional `-r` forces caller id checking. `-r` without `-l`, `-p` or `-x` assumes call mode.  
To register to a gateway, specify `-c`, `-g` and `-w`
  
**Example:**

`sipcmd -P sip -u johndoe -c secret -w example.com -x "c555123456;w200;d12345"`

**WAV file requirements:**
  
*   mono
*   8 kHz sampling rate
*   16 bits sample size

**The EBNF definition of the program syntax:**

```
prog	 :=  cmd ';' <prog>|
cmd	     :=  call | answer | hangup | dtmf | voice | record | wait | setlabel | loop
call	 :=  'c' remoteparty
answer	 :=  'a' [ expectedremoteparty ]
hangup	 :=  'h'
dtmf	 :=  'd' digits
voice	 :=  'v' audiofile
record	 :=  'r' [ append ] [ silence ] [ iter ] millis audiofile
append	 :=  'a'
silence	 :=  's'
closed   :=  'c'
iter     :=  'i'
activity :=  'a'
wait	 :=  'w' [ activity | silence ] [ closed ] millis
setlabel :=  'l' label
loop	 :=  'j' [ how-many-times ] [ 'l' label ]
```

**Example:**  

`"l4;c333;ws3000;d123;w200;lthrice;ws1000;vaudio;rsi4000f.out;j3lthrice;h;j4"`  

Parses to the following:

1.  do this four times:
    1.  call to 333
    2.  wait until silent (max 3000 ms)
    3.  send dtmf digits 123
    4.  wait 200 ms
    5.  do this three times:
        1.  wait until silent (max 1000 ms)
        2.  send sound file 'audio'
        3.  record until silent (max 4000 ms) to files 'f-[0-3]-[0-2].out'
    6.  hangup
