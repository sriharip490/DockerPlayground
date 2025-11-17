# DNS Snippets

### DNS Resolution flow

Client
  |
  |--> Local Resolver  (Caching, reduces latency)
          |
          |--> Root DNS (.)
                 |
                 |--> TLD (".com") (Top Level Domain)
                        |
                        |--> Authoritative (google.com)
                                  |
                                  |--> Respond with A/AAAA record

## Anycast IP

### Anycast DNS

Route to DNS IP 203.0.113.53/32 - BGP sees multiple routes to same DNS IP
prefix.

              Same IP advertised from 3 locations
             203.0.113.53/32  (Anycast DNS IP)

        +-----------+       +-----------+       +-----------+
        | DNS Node  |       | DNS Node  |       | DNS Node  |
        |   US      |       |  Europe   |       |   Asia    |
        +-----------+       +-----------+       +-----------+
              \                 |                 /
               \                |                /
                \               |               /
                 --------- BGP Internet ---------

User in US → routed to US node  
User in EU → routed to EU node  
User in Asia → routed to Asia node

Each DNS node responds with the same authoritative DNS data.


## DNS Threats

1. DNS Spoofing
2. DNS Cache Poisoning
   [ Both of above manipulate DNS responses, so clients may get redirected
     to malicious sites ]
3. DDoS attack on DNS servers
4. DNS Tunneling

