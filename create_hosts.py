import sys
import json


private_ips = [
  [
    "172.31.10.140",
    "172.31.8.36",
    "172.31.9.38",
  ],
]
public_ips = [
  [
    "54.180.131.201",
    "3.34.144.59",
    "13.125.37.214",
  ],
]


def get_first(hosts, host):
    h = hosts[0]
    if h == host:
        return ""
    return f"ngrinder_master_addr={h[1]}:8080"


def print_ngrinder(hosts):
    print_group("ngrinder", hosts, 1, get_first)


def print_group(group_name, hosts, start_host_idx = 1, addfunc=None):
    print(f"[{group_name}]")
    for host in hosts:
        line = f"{host[0]} internal_hostname=host{start_host_idx} internal_ip={host[1]}"
        if addfunc:
            line += " "
            line += addfunc(hosts, host)

        start_host_idx += 1

        print(line)


def print_prometheus_config(name, hosts, port):
    print(f"{name}:")
    for host in hosts:
        print(f"  - {host[1]}:{port}")


hosts = list(zip(public_ips[0], private_ips[0]))

print_ngrinder(hosts)
print_group("prometheus", hosts[0:1])
print_group("grafana", hosts[0:1])
print_group("geoip", hosts[1:],2)


print_prometheus_config("nodes", hosts, 9100)
print_prometheus_config("prometheus_node", hosts[0:1], 9090)
print_prometheus_config("geoip_nodes", hosts[1:], 7001)
