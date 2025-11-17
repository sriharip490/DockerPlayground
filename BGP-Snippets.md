# BGP Snippets

Quick reference notes, configuration snippets

## LOCAL_PREF

### Example 1: Routes from specific neighbour

The route is learnt via EBGP (may be an ISP)

protocol bgp ISP1 {
    local as 65000;
    neighbor 192.0.2.1 as 64500;

    import filter {
        bgp_local_pref = 200;    # Higher preference
        accept;
    };

    export all;
}
