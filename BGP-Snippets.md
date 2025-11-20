# BGP Snippets

Quick reference notes, configuration snippets

## LOCAL_PREF

Local Pref is an attribute 
1. Used inside AS to decide the preferred path for outbound traffic
2. Applied as soon as a route enters AS via EBGP

### Example 1: Routes from specific neighbour

The route is learnt via EBGP (may be an ISP)

```
protocol bgp ISP1 {
    local as 65000;
    neighbor 192.0.2.1 as 64500;

    import filter {
        bgp_local_pref = 200;    # Higher preference
        accept;
    };

    export all;
}
```

### Example 2: ISP1, ISP2 

```
protocol bgp ISP1 {
    local as 65000;
    neighbor 203.0.113.1 as 64501;

    import filter {
        bgp_local_pref = 300;     # Primary
        accept;
    };
}

protocol bgp ISP2 {
    local as 65000;
    neighbor 203.0.113.2 as 64502;

    import filter {
        bgp_local_pref = 100;     # Backup
        accept;
    };
}
```

ISP1 is preferred over ISP2

### Example 3: Conditional LOCAL_PREF

```
import filter {
    if net ~ 10.0.0.0/8 then {
        bgp_local_pref = 250;
    } else {
        bgp_local_pref = 100;
    }
    accept;
}
```

If route received from the BGP peer falls within the prefix 10.0.0.0/8.

### Example 4: AS-Path preference

```
if bgp_path ~ [ = 64512 * ] then bgp_local_pref = 50;
```

Set the preference for AS path containing 64512

### Example 4

router id 10.0.0.1;

protocol device {}

# Health check for DNS service (dummy route)
protocol static DNS_Anycast {
    route 203.0.113.53/32 via "lo";    # Announce only if reachable
}

# Upstream BGP
protocol bgp ISP_A {
    local as 65001;
    neighbor 198.51.100.1 as 65000;

    import none;  # Do not accept external prefixes into local routing
    export filter {
        if net = 203.0.113.53/32 then accept;
        reject;
    };
}


1. BGP Announcement of Anycast route.
2. All the POPs run the similar configuration - exporting the Anycast Route
   prefix 203.0.113.53/32
3. Advertise ONLY if the DNS server is functional


## Summary of LOCAL_PREF BIRD condition

Condition           | BIRD Condition Example
--------------------|-----------------------------------------------
Prefix              | net ~ 10.0.0.0/8
Community           | (65500,100) ~ bgp_community
ISP/Neighbor        | proto = "primary_isp"
AS-PATH             | bgp_path ~ [ = 64512 * ]
AS-PATH length      | bgp_path.len > 5
MED                 | bgp_med < 50
Origin type         | bgp_origin = ORIGIN_IGP
IGP metric          | ospf_metric
Next-hop            | bgp_next_hop = <ip>
Route type          | from = "<peer>"
RPKI state          | roa_check(...)
Prefix length       | net.len = 24


## BGP CDN Core - POP Router - ISP Peering

```
                     Internet
     ┌─────────────────┼───────────────────┐
     │                 │                   │
 ISP1 AS64501     ISP2 AS64502       ISP3 AS64503
     │                 │                   │
 +---+---+         +---+---+           +---+---+
 |  POP1 |         |  POP2 |           |  POP3 |
 |10.10.1.1        |10.20.1.1          |10.30.1.1
 +---+---+         +---+---+           +---+---+
     \                |                 /
      \               |                /
       \              |               /
        +-----------------------------+
                     |
                    CORE
                  10.1.1.1
```

* POPx <--> ISPx peering via eBGP
* POPx, CDN Core in same AS - iBGP peering
* Each of the POPx does the following
  + Install static route to Anycast IP 203.0.113.10/32
  + Next hop interface is "lo" - it never goes down
  ```
    protocol static {
        route 203.0.113.10/32 via "lo"
    }
  ```
  + The route is installed in the BGP RIB (not in Linux)

### BIRD Configuration - POP Router

* BIRD BGP configuration in POP1 router - IP 10.10.1.1
* Similar configuration across POP2 (10.20.1.1), POP3 (10.30.1.1)
* iBGP Peering with CDN Core Router (10.1.1.1)
```
router id 10.10.1.1;

protocol device {}
protocol kernel { persist; export all; }
protocol direct {}

# Anycast prefix (local origin)
protocol static anycast {
    route 203.0.113.10/32 via "lo";
}

# iBGP to CORE
protocol bgp CORE {
    local as 65000;
    neighbor 10.1.1.1 as 65000;

    source address 10.10.1.1;

    import all;
    export filter {
        if net = 203.0.113.10/32 then accept;
        reject;
    };
}

# eBGP to ISP1
protocol bgp ISP1 {
    local as 65000;
    neighbor 192.0.2.1 as 64501;

    source address 10.10.1.1;

    # Export only Anycast
    export filter {
        if net = 203.0.113.10/32 then accept;
        reject;
    };

    import all;   # Learn upstream routes (optional)
}
```

## Per Packet Flow

How a single HTTP request starting from the user workstation flows
through till the Origin Server, the reverse path
```
  Step 1: User sends request to Anycast IP (203.0.113.10)
  -------------------------------------------------------
  User
    |
    | 1) DNS resolves to same Anycast IP globally
    |
    | 2) Packet leaves user's ISP → global routers choose shortest AS path
    |
    v
+--------+
| POP-N  |
| nearest|
+--------+

  Step 2: POP forwards internally to CDN Core
  --------------------------------------------
    |
    | 3) POP → internal BGP → learns best path to Origin via CORE
    |
    v
+---------+
|  CORE   |
+---------+

  Step 3: Core sends request to Origin servers
  --------------------------------------------
    |
    | 4) CORE → RIB/FIB → backend VPC/DC
    |
    v
+----------+
| ORIGIN   |
+----------+

  Step 4: Response takes reverse path
  -----------------------------------
    |
    v
+---------+    5) CORE → POP (closest to user)
|  CORE   |
+---------+
    |
    v
+--------+    6) POP returns content to the user
| POP-N  |
+--------+
    |
    v
  User

```
