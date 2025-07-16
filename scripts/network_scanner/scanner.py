import json
import platform
import subprocess
from dataclasses import dataclass, field
from typing import Dict, List, Any, Optional


@dataclass
class ScanResult:
    danger_ports: Dict[str, List[int]] = field(default_factory=dict)
    open_port_count: Dict[str, int] = field(default_factory=dict)
    netbios: Dict[str, bool] = field(default_factory=dict)
    smbv1: Dict[str, bool] = field(default_factory=dict)
    upnp: Dict[str, bool] = field(default_factory=dict)
    geoip: Dict[str, str] = field(default_factory=dict)
    intl_traffic_ratio: Optional[float] = None
    http_ratio: Optional[float] = None
    dns_fail_rate: Optional[float] = None
    external_comm_warnings: List[str] = field(default_factory=list)
    ssl: Dict[str, str] = field(default_factory=dict)
    defender_enabled: Optional[bool] = None
    firewall_enabled: Optional[bool] = None
    os_version: str = platform.platform()
    dhcp: Optional[bool] = None
    arp_spoofing: Optional[bool] = None
    ip_conflict: Optional[bool] = None
    unknown_mac_ratio: Optional[float] = None
    device_count: Optional[int] = None


class NetworkSecurityScanner:
    def __init__(self, targets: List[str]):
        self.targets = targets

    def _run_command(self, cmd: List[str]) -> str:
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, check=False)
            return result.stdout
        except FileNotFoundError:
            return ""

    def scan_danger_ports(self) -> Dict[str, List[int]]:
        danger_port_list = ["3389", "445", "23"]
        result = {}
        for target in self.targets:
            output = self._run_command(["nmap", "-Pn", "-p", ",".join(danger_port_list), target])
            open_ports = []
            for line in output.splitlines():
                if "/tcp" in line and "open" in line:
                    port = int(line.split("/")[0].strip())
                    open_ports.append(port)
            result[target] = open_ports
        return result

    def scan_open_port_count(self) -> Dict[str, int]:
        counts = {}
        for target in self.targets:
            output = self._run_command(["nmap", "-Pn", target])
            count = 0
            for line in output.splitlines():
                if "/tcp" in line and "open" in line:
                    count += 1
            counts[target] = count
        return counts

    def check_netbios(self) -> Dict[str, bool]:
        results = {}
        for target in self.targets:
            output = self._run_command(["nmap", "-Pn", "-p", "137", target])
            results[target] = "open" in output
        return results

    def check_smbv1(self) -> Dict[str, bool]:
        results = {}
        for target in self.targets:
            output = self._run_command(["nmap", "--script", "smb-protocols", "-p", "445", target])
            results[target] = "SMBv1" in output
        return results

    def check_upnp(self) -> Dict[str, bool]:
        results = {}
        for target in self.targets:
            output = self._run_command(["nmap", "-Pn", "-p", "1900", target])
            results[target] = "open" in output
        return results

    def get_os_version(self) -> str:
        return platform.platform()

    def check_defender(self) -> Optional[bool]:
        cmd = ["powershell", "-Command", "(Get-MpComputerStatus).RealTimeProtectionEnabled"]
        output = self._run_command(cmd)
        if output:
            return output.strip().lower() == "true"
        return None

    def check_firewall(self) -> Optional[bool]:
        cmd = ["powershell", "-Command", "(Get-NetFirewallProfile | Select-Object -First 1).Enabled"]
        output = self._run_command(cmd)
        if output:
            return output.strip() == "True"
        return None

    def run_all(self) -> Dict[str, Any]:
        res = ScanResult()
        res.danger_ports = self.scan_danger_ports()
        res.open_port_count = self.scan_open_port_count()
        res.netbios = self.check_netbios()
        res.smbv1 = self.check_smbv1()
        res.upnp = self.check_upnp()
        res.defender_enabled = self.check_defender()
        res.firewall_enabled = self.check_firewall()
        res.os_version = self.get_os_version()
        return res.__dict__


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Network security scanner")
    parser.add_argument("targets", nargs="+", help="Target hosts to scan")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    args = parser.parse_args()

    scanner = NetworkSecurityScanner(args.targets)
    result = scanner.run_all()
    if args.json:
        print(json.dumps(result, indent=2, ensure_ascii=False))
    else:
        print(result)
