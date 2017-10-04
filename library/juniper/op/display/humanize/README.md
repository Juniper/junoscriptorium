# Humanize CLI Output

**Python script which humanizes the CLI output of a given command.**

This script replaces all numbers greater than 1.000 with a humanized
representation (e.g. 1337 --> 1.3K) without breaking the indentation.
Lines containing one of the exception keywords are skipped
(e.g index, address, mtu, vlan, cache, ...).

### Install

+ copy file `op/humanize.py` to `/var/db/scripts/op/humanize.py`
  + set file owner to root or some super-user
  + set file permissions to 644 (-rw-r--r--)
+ update config
  + `set system scripts language python`
  + `set system scripts op file humanize.py command humanize`


### Example

```
USER@DEVICE> op humanize ?
Possible completions:
  <[Enter]>            Execute this command
  <name>               Argument name
  command              mandatory cli command
  detail               Display detailed output
  invoke-debugger      Invoke script in debugger mode
  round                decimal places (default 1)
  |                    Pipe through a command


USER@DEVICE> op humanize command "show interface xe-0/2/0 extensive"
Physical interface: xe-0/2/0, Enabled, Physical link is Up
  Interface index: 260, SNMP ifIndex: 3203, Generation: 263
  Description: #m#uplink_lsr#to_rone_xe-1/3/0
  Link-level type: Ethernet, MTU: 4484, MRU: 4492, LAN-PHY mode, Speed: 10Gbps,
  BPDU Error: None, Loop Detect PDU Error: None, MAC-REWRITE Error: None,
  Loopback: None, Source filtering: Disabled, Flow control: Disabled
  Pad to minimum frame size: Disabled
  Device flags   : Present Running
  Interface flags: SNMP-Traps Internal: 0x4000
  CoS queues     : 8 supported, 8 maximum usable queues
  Schedulers     : 0
  Hold-times     : Up 2.0K ms, Down 0 ms
  Damping        : half-life: 0 sec, max-suppress: 0 sec, reuse: 0, suppress: 0, state: unsuppressed
  Current address: 84:18:88:91:90:a4, Hardware address: 84:18:88:91:90:a4
  Last flapped   : 2.0K-09-18 08:16:26 CEST (03:06:16 ago)
  Statistics last cleared: Never
  Traffic statistics:
   Input  bytes  :                54.2M                34.0K bps
   Output bytes  :                15.3M                    0 bps
   Input  packets:               111.6K                    4 pps
   Output packets:                61.0K                    0 pps
   IPv6 transit statistics:
    Input  bytes  :               35.8K
    Output bytes  :                   0
    Input  packets:                 487
    Output packets:                   0
  Ingress traffic statistics at Packet Forwarding Engine:
   Input  bytes  :                56.0M                 3.7K bps
   Input  packets:               111.6K                    2 pps
   Drop   bytes  :                    0                    0 bps
   Drop   packets:                    0                    0 pps
  Label-switched interface (LSI) traffic statistics:
   Input  bytes  :                    0                    0 bps
   Input  packets:                    0                    0 pps
  Dropped traffic statistics due to STP State:
   Input  bytes  :                    0
   Output bytes  :                    0
   Input  packets:                    0
   Output packets:                    0
  Input errors:
    Errors: 0, Drops: 0, Framing errors: 0, Runts: 0, Policed discards: 0,
    L3 incompletes: 0, L2 channel errors: 0, L2 mismatch timeouts: 0,
    FIFO errors: 0, Resource errors: 0
  Output errors:
    Carrier transitions: 1, Errors: 0, Drops: 0, Collisions: 0, Aged packets: 0,
    FIFO errors: 0, HS link CRC errors: 0, MTU errors: 0, Resource errors: 0
  Ingress queues: 8 supported, 8 in use
  Queue counters:       Queued packets  Transmitted packets      Dropped packets
    0                                0                    0                    0
    1                                0                    0                    0
    2                                0                    0                    0
    3                           111.6K               111.6K                    0
    4                                0                    0                    0
    5                                0                    0                    0
    6                                0                    0                    0
    7                                0                    0                    0
  Egress queues: 8 supported, 8 in use
  Queue counters:       Queued packets  Transmitted packets      Dropped packets
    0                               14                   14                    0
    1                                0                    0                    0
    2                                0                    0                    0
    3                            61.0K                61.0K                    0
    4                                0                    0                    0
    5                                0                    0                    0
    6                                0                    0                    0
    7                                0                    0                    0
  Queue number:         Mapped forwarding classes
    0                   BestEffort, Redirect, L2-BestEffort, L2-LowDelay, L2-Voice, L2-LowLoss
    1                   LowLoss, LowLoss-2
    2                   LowDelay
    3                   Control, Control-LowLoss
    4                   Voice, Voice-LowDelay
    5                   Scavenger
    6                   TransitControl
    7                   Multimedia
  Active alarms  : None
  Active defects : None
  PCS statistics                      Seconds
    Bit errors                             0
    Errored blocks                         0
  MAC statistics:                      Receive         Transmit
    Total octets                         56.1M            15.4M
    Total packets                       111.6K            61.0K
    Unicast packets                      97.4K            42.1K
    Broadcast packets                        5                6
    Multicast packets                    14.2K            18.9K
    CRC/Align errors                         0                0
    FIFO errors                              0                0
    MAC control frames                       0                0
    MAC pause frames                         0                0
    Oversized frames                         0
    Jabber frames                            0
    Fragment frames                          0
    VLAN tagged frames                       0
    Code violations                          0
    Total errors                             0                0
  Filter statistics:
    Input packet count                  111.6K
    Input packet rejects                     0
    Input DA rejects                         0
    Input SA rejects                         0
    Output packet count                                   61.0K
    Output packet pad count                                   0
    Output packet error count                                 0
    CAM destination filters: 0, CAM source filters: 0
  Packet Forwarding Engine configuration:
    Destination slot: 0 (0x00)
  CoS information:
    Direction : Output
    CoS transmit queue               Bandwidth               Buffer Priority   Limit
                              %            bps     %           usec
    0 BestEffort, Redirect, L2-BestEffort, L2-LowDelay, L2-Voice, L2-LowLoss  4      400.0M  4            0      low    none
    1 LowLoss, LowLoss-2     30           3.0G    30              0      low    none
    2 LowDelay               50           5.0G     0          10.0K      low    none
    3 Control, Control-LowLoss  1       100.0M     1              0      low    none
    4 Voice, Voice-LowDelay  15           1.5G     0           3.0K     high    none
    Direction : Input
    CoS transmit queue               Bandwidth               Buffer Priority   Limit
                              %            bps     %           usec
    0 BestEffort, Redirect, L2-BestEffort, L2-LowDelay, L2-Voice, L2-LowLoss 95        9.5G 95            0      low    none
    3 Control, Control-LowLoss  5       500.0M     5              0      low    none
  Preclassifier statistics:
    Traffic Class        Received Packets   Transmitted  Packets      Dropped Packets
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
    best-effort                         0                      0                    0
  Link Degrade :
    Link Monitoring                   :  Disable
  Interface transmit statistics: Disabled
  Logical interface xe-0/2/0.0 (Index 486) (SNMP ifIndex 3205) (Generation 295)
    Description: #m#uplink_lsr#to_rone_xe-1/3/0
    Flags: Up SNMP-Traps 0x4004000 Encapsulation: ENET2
    Traffic statistics:
     Input  bytes  :                54.2M
     Output bytes  :                14.9M
     Input  packets:               111.6K
     Output packets:                61.0K
     IPv6 transit statistics:
      Input  bytes  :               35.8K
      Output bytes  :                   0
      Input  packets:                 487
      Output packets:                   0
    Local statistics:
     Input  bytes  :                53.6M
     Output bytes  :                14.9M
     Input  packets:               108.8K
     Output packets:                61.0K
    Transit statistics:
     Input  bytes  :               581.3K                    0 bps
     Output bytes  :                 1.7K                    0 bps
     Input  packets:                 2.8K                    0 pps
     Output packets:                   14                    0 pps
     IPv6 transit statistics:
      Input  bytes  :               35.8K
      Output bytes  :                   0
      Input  packets:                 487
      Output packets:                   0
    Output Filters: re-classify
    Protocol inet, MTU: 4470
    Max nh cache: 75000, New hold nh limit: 75000, Curr nh cnt: 1,
    Curr new hold cnt: 0, NH drop cnt: 0
    Generation: 356, Route table: 0
      Flags: Sendbcast-pkt-to-re
      Input Filters: xe-0/2/0.0-i
      Addresses, Flags: Is-Preferred Is-Primary
        Destination: 11.0.100.108/30, Local: 11.0.100.109,
        Broadcast: 11.0.100.111, Generation: 193
    Protocol iso, MTU: 4467, Generation: 357, Route table: 0
    Protocol inet6, MTU: 4470
    Max nh cache: 75000, New hold nh limit: 75000, Curr nh cnt: 0,
    Curr new hold cnt: 0, NH drop cnt: 0
    Generation: 358, Route table: 0
      Addresses, Flags: Is-Preferred
        Destination: fe80::/64, Local: fe80::8618:88ff:fe91:90a4
    Protocol mpls, MTU: 4458, Maximum labels: 3, Generation: 195
    Protocol multiservice, MTU: Unlimited, Generation: 359, Route table: 0
    Generation: 360, Route table: 0
      Policer: Input: __default_arp_policer__


USER@DEVICE> op humanize command "show interface queue egress xe-0/2/0 forwarding-class BestEffort" round 10
Physical interface: xe-0/2/0, Enabled, Physical link is Up
  Interface index: 260, SNMP ifIndex: 3203
  Description: #m#uplink_lsr#to_rone_xe-1/3/0
Forwarding classes: 16 supported, 16 in use
Egress queues: 8 supported, 8 in use
Queue: 0, Forwarding classes: BestEffort, Redirect, L2-BestEffort, L2-LowDelay, L2-Voice, L2-LowLoss
  Queued:
    Packets              :                    14                     0 pps
    Bytes                :                1.998K                     0 bps
  Transmitted:
    Packets              :                    14                     0 pps
    Bytes                :                1.998K                     0 bps
    Tail-dropped packets :                     0                     0 pps
    RL-dropped packets   :                     0                     0 pps
    RL-dropped bytes     :                     0                     0 bps
    RED-dropped packets  :                     0                     0 pps
     Low                 :                     0                     0 pps
     Medium-low          :                     0                     0 pps
     Medium-high         :                     0                     0 pps
     High                :                     0                     0 pps
    RED-dropped bytes    :                     0                     0 bps
     Low                 :                     0                     0 bps
     Medium-low          :                     0                     0 bps
     Medium-high         :                     0                     0 bps
     High                :                     0                     0 bps
  Queue-depth bytes      :
    Average              :                     0
    Current              :                     0
    Peak                 :                     0
    Maximum              :             5.111808M
````
