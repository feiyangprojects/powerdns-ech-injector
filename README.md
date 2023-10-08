# PowerDNS Recursor ECH Injector

## Usage

### Install

Clone this repository with submodules to `/etc/pdns/ech-injector` (due to limitation of Lua and PowerDNS, changing path requires modifing `L1` and `L5` in `ech-injector.lua`).

```
# cd /etc/pdns
# git clone --recurse-submodules https://github.com/feiyangprojects/powerdns-ech-injector.git ech-injector
```

### Setup

Obtain a copy of Maxmind GeoLite2 ASN database with `mmdb` format [here](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data), then upload it to your server.

Copy and edit the configuration file, set ech config and maxmind database path.

```
# cd /etc/pdns/ech-injector
# cp config.example.json config.json
# vim config.json
```

Enable this script for PowerDNS Recursor.

```
# echo 'lua-dns-script=/etc/pdns/ech-injector/ech-injector.lua' >> /etc/pdns/recursor.conf
```

## License

GNU Affero General Public License Version 3
