# BGP Snippets

Quick reference notes, configuration snippets

## LOCAL_PREF

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
