# SIPp
SIPp stress/load testing with asterisk

SIPp
Introduction
This document provides guidelines for using SIPp in order to develop the stress/load testing environment for Asterisk platform in different call scenarios i e Inbound and Outbound.
Requirements:
IMPORTANT: In order to develop and execute the examples, you will need:

SIPp installed on the local system 
Asterisk installed 
What is SIPp:
SIPp is a tool which used to send and receive SIP messages between client (UAC -User agent client) and server (UAS - User agent server).

SIPp Relevant Commands
Installation:
On Linux, SIPp is provided in the form of source code. You will need to compile SIPp to actually use it.
Pre-requisites to compile SIPp are:
C++ Compiler
curses or ncurses library
For TLS support: OpenSSL >= 0.9.8
For pcap play support: libpcap and libnet
For SCTP support: lksctp-tools
For distributed pauses: Gnu Scientific Libraries
You have four options to compile SIPp:
Without TLS (Transport Layer Security), SCTP or PCAP support – this is the recommended setup if you don’t need to handle SCTP, TLS or PCAP:
Source package can be install from  
# wget https://github.com/SIPp/sipp/releases/download/v3.5.0/sipp-3.5.0.tar.gz
# tar -xvzf sipp-xxx.tar 
# cd sipp
# ./configure
# make


With TLS support, you must have installed OpenSSL library (>=0.9.8) (which may come with your system). Building SIPp consists only of adding the --with-openssl option to the configure command:
tar -xvzf sipp-xxx.tar.gz
cd sipp
./configure --with-openssl
make


With PCAP play support:
tar -xvzf sipp-xxx.tar.gz
cd sipp
./configure --with-pcap
make


With SCTP support:
tar -xvzf sipp-xxx.tar.gz
cd sipp
./configure --with-sctp
make


You can also combine these various options, e.g.:
tar -xvzf sipp-xxx.tar.gz
cd sipp
./configure --with-sctp --with-pcap --with-openssl
make
SIPp relevant command line options:
-sf <custom.xml> :-  load a custom scenario file

-sn <built in scenario> :-  Use a built in scenario, e.g (uac , uas)

-d < Durations in mili sec >:- Duration of the calls

-r  < count > :-  Set the call rate (in calls per seconds).

-l  < Max calls >:-  Set the maximum number of simultaneous calls. Once this limit is reached, traffic is decreased until the number of open calls goes down. Default: (3 * call_duration (s) * rate).
-m < calls > :-  Stop the test and exit when 'calls' calls are processed

-s < extension > :-   Set the extension, which user wants to dial when dialing the call.

-i < local ip address > :- local IP address  

-i < local ip address > :- local IP address 

-set <key> <value> :- Set is used to set the parameter which needs to send along with the sip headers.

-trace_msg :- Set SIP messages in a file and set the file name as <sceneriao filename>_<pid>_messages.log

-trace_err :- Set error messages in a file and set the file name as <sceneriao filename>_<pid>_errors.log

-trace_err :- Set error messages in a file and set the file name as <sceneriao filename>_<pid>_errors.log

SIPp scenario file
SIPp scenario file is used to handle the sip messages, which generates when communication establish between UAC and UAS .

Syntax :

<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE scenario SYSTEM "sipp.dtd">

<scenario name="Basic UAS">

// here Need to handle SIP messages by using different scenarios tags.


</scenario>
 
Scenario tags
This section cover the information regarding the tags which used to develop the scenarios to handle the SIP messages.

<send> : send a SIP message or a response. Important attributes are:
retrans : set the T1 timer for this message in milliseconds
lost : show packet loss, value in percentage
<recv> : wait for a SIP message or response. Important attributes are:
response : indicates what SIP message code is expected
request : indicates what SIP message request is expected
optional : Indicates if the message to receive is optional. If optional is set to "global", SIPp will look every previous steps of the scenario
lost : show packet loss, value in percentage
timeout : specify a timeout while waiting for a message. If the message is not received, the call is aborted
ontimeout : specify a label to jump to if the timeout popped regexp_match: boolean. Indicates if 'request' ('response' is not available) is given as a regular expression.
The recv command can also include the action tag defining the action to execute upon the message reception
pause : pause the scenario execution. Important attributes are:
milliseconds : time to pause in milliseconds
variable : scenario variable defining the pause time
nop : the nop action doesn’t do nothing at SIP signalling level, is just a tag containing the action subtag
label : a label is used when you want to branch to specific parts in your scenarios
Scenario Examples
UAC Scenario:

UAC starts with send command as per  syntax mention below :

	  
<send retrans="500">
    <![CDATA[

      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: [service] <sip:[service]@[remote_ip]:[remote_port]>
      Call-ID: [call_id]
      CSeq: 1 INVITE
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Subject: Performance Test_[$mydest] 
      Content-Type: application/sdp
      Content-Length: [len]

      v=0
      o=user1 53655765 2353687637 IN IP[local_ip_type] [local_ip]
      s=-
      c=IN IP[media_ip_type] [media_ip]
      t=0 0
      m=audio [media_port] RTP/AVP 8 101
      a=rtpmap:8 PCMA/8000
      a=rtpmap:101 telephone-event/8000
      a=fmtp:101 0-15
      a=ptime:20

    ]]>
  </send>

2)  Now scenario waits for answer the call from uas side, 100 Trying , 180 Ringing are optional,
but 200 OK is mandatory as after it the sip dialog will be created.

 <recv response="100"
        optional="true">
  </recv>

  <recv response="180" optional="true">
  </recv>

  <recv response="183" optional="true">
  </recv>
                            -->
  <recv response="200" rtd="true">
  </recv>

3) Now After 200 OK, ACK needs to send from UAC to UAS so that the communication between them get establish  and media can transmit.

<send>
    <![CDATA[

      ACK sip:[service]@[remote_ip]:[remote_port] SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: [service] <sip:[service]@[remote_ip]:[remote_port]>[peer_tag_param]
      Call-ID: [call_id]
      CSeq: 1 ACK
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Content-Length: 0

    ]]>
  </send>

4) Now we need to send media in the form of DtMF ie pcap file for different digits.

<nop>
    <action>
        <exec play_pcap_audio="../pcap/dtmf_2833_1.pcap"/>
    </action>
 </nop>

  <pause milliseconds="3000"/>

  <nop>
    <action>
        <exec play_pcap_audio="../pcap/dtmf_2833_2.pcap"/>
    </action>
 </nop>

  <pause milliseconds="3000"/>
 
5) At last we need to send BYE to hang up the call and receive its acknowledgement from UAS
side.

 <send retrans="500" crlf="true"> 
    <![CDATA[

      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: [service] <sip:[service]@[remote_ip]:[remote_port]>[peer_tag_param]
      Call-ID: [call_id]
      CSeq: 2 BYE
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Subject: Performance Test_[$mydest]
      Content-Length: 0

    ]]>
  </send> 

<recv response="200" crlf="true">
  </recv>

Note : Complete file be shared with on git link.

UAS Scenario:

1) An UAS scenario starts with a <recv> command, the scenario replies with 180 Ringing.

 <send>
    <![CDATA[

      SIP/2.0 180 Ringing
      [last_Via:]
      [last_From:]
      [last_To:];tag=[call_number]
      [last_Call-ID:]
      [last_CSeq:]
      Contact: <sip:[local_ip]:[local_port];transport=[transport]>
      Content-Length: 0

    ]]>
  </send>

2)  Now to answer the call send 200 OK and receive acknowledgement for the respective
Message.

<send retrans="500">
    <![CDATA[

      SIP/2.0 200 OK
      [last_Via:]
      [last_From:]
      [last_To:];tag=[call_number]
      [last_Call-ID:]
      [last_CSeq:]
      Contact: <sip:[local_ip]:[local_port];transport=[transport]>
      Content-Type: application/sdp
      Content-Length: [len]

      v=0
      o=sipp 87308505 1 IN IP[local_ip_type] [local_ip]
      s=-
      t=0 0
      m=audio [media_port] RTP/AVP 8 101
      c=IN IP[media_ip_type] [media_ip]
      a=rtpmap:8 PCMA/8000
      a=rtpmap:101 telephone-event/8000
      a=fmtp:101 0-15
      a=ptime:20

    ]]>
  </send>

<recv request="ACK" crlf="true">
  </recv>


3) Send DTMF using the tags as similarly send for uac

  <nop>
    <action>
        <exec play_pcap_audio="../pcap/dtmf_2833_1.pcap"/>
    </action>
  </nop>

  <!-- This delay can be customized by the -d command-line option       -->
  <!-- or by adding a 'milliseconds = "value"' option here.             -->
  <pause milliseconds="3000"/>
  <nop>
    <action>
        <exec play_pcap_audio="../pcap/dtmf_2833_2.pcap"/>
    </action>
  </nop>
  <pause milliseconds="3000"/>

4) At last we need to receive BYE and send ACK to hang up the call and receive its
acknowledgement from UAC.

 <recv request="BYE">
  </recv>

  <send>
    <![CDATA[

      SIP/2.0 200 OK
      [last_Via:]
      [last_From:]
      [last_To:]
      [last_Call-ID:]
      [last_CSeq:]
      Contact: <sip:[local_ip]:[local_port];transport=[transport]>
      Content-Length: 0

    ]]>
  </send>


Command to run SIPp on CLI : 

Command to run UAS : 

sudo sipp -sf <scenario file> -i <local ip> -p <local port> -m 1 -trace_msg -trace_err

Command to run UAC : 

sudo sipp -sf <scenario file> -set <key> <value>  -s <service> -i <local ip> <remote ip>:<remote
port> -m 10  -trace_err -trace_msg

Note : 

To add the variable using “ -set ” option, corresponding variable need to set as global variable
and reference variable in scenario file. Example added in the respective uac.xml.




Setup with Asterisk :
1) we need to create the IVR flow on which the stress testing will perform.

Filename: /etc/asterisk/extensions.conf

Asterisk context to handle the call (context will work for both inbound and outbound  case).

[SIPp]
exten =>_X!,1,Answer()
exten =>_X!,n,Verbose(1, SIPp)
; First DTMF
exten =>_X!,n,Read(dtmf,please-try-again,1,,,10)
exten =>_X!,n,GotoIf($["${dtmf}"==""]?invalid:)
exten =>_X!,n,GotoIf($[(${dtmf}>=1) & (${dtmf}<=2)]?:invalid)
exten =>_X!,n,GotoIf($["${dtmf}"=="1"]?:else)
; second DTMF
exten =>_X!,n,Read(dtmf_1,basic-pbx-ivr-main,1,,,10)
exten =>_X!,n,GotoIf($["${dtmf_1}"==""]?invalid:)
exten =>_X!,n,GotoIf($[(${dtmf_1}>=1) & (${dtmf}<=2)]?:invalid)
exten =>_X!,n,GotoIf($["${dtmf_1}"=="2"]?:else)

exten =>_X!,n,Playback(hello-world)
exten =>_X!,n,Goto(hangup)

exten =>_X!,n(else),Playback(auth-thankyou)
exten =>_X!,n,Goto(hangup)

exten =>_X!,n(invalid),Playback(/home/local/CORPORATE/naman/AirIndiaFlightStatus/invalidTryAgain)

exten =>_X!,n(hangup),verbose("call Complete")
;exten => _X!,n,Hangup()
exten =>_X!,n,Wait(10)

2) For outbound we need to create sip trunk as to communicate between SIPP and asterisk.

Filename: /etc/asterisk/sip.conf

[sipp_trunk]
host=127.0.0.1
port=5080
context=SIPp
type=peer
dtmfmode=rfc2833
insecure=very
canreinvite=no

3) Need to check if sip trunk get register successfully :

# sip show peers (on asterisk cli)



