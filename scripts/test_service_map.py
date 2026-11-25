import importlib.util
import tempfile
import unittest
from pathlib import Path
from xml.etree import ElementTree as ET


spec = importlib.util.spec_from_file_location(
    "service_map", Path(__file__).with_name("generate-service-map.py")
)
service_map = importlib.util.module_from_spec(spec)
spec.loader.exec_module(service_map)


class ServiceMapTests(unittest.TestCase):
    def test_discovers_direct_imports_without_duplicates_or_comments(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            configuration = root / "machines" / "example" / "configuration.nix"
            configuration.parent.mkdir(parents=True)
            configuration.write_text("""
                {
                  imports = [
                    ./hardware-configuration.nix
                    ../../modules/containers.nix
                    # ../../services/disabled
                    ../../services/plex
                    ../../services/adguardhome/default.nix # DNS
                    ../../services/plex/
                  ];
                }
            """)
            self.assertEqual(
                service_map.discover_services(root),
                {"example": ["adguardhome", "plex"]},
            )

    def test_missing_machines_fails(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(ValueError):
                service_map.discover_services(Path(directory))

    def test_renders_valid_accessible_svg_with_one_arrow_per_service(self):
        hosts = {"cerberus": ["adguardhome", "caddy"], "sotetseg": ["plex"]}
        result = service_map.render_svg(hosts)
        svg = ET.fromstring(result)
        ns = {"s": "http://www.w3.org/2000/svg"}
        self.assertEqual(svg.attrib["role"], "img")
        self.assertEqual(len(svg.findall("s:path", ns)), 3)
        self.assertEqual(len(svg.findall("s:rect", ns)), 5)
        self.assertIn("AdGuard Home", result)
        self.assertEqual(result, service_map.render_svg(hosts))

    def test_escapes_labels(self):
        result = service_map.render_svg({"test&host": ["test<service"]})
        ET.fromstring(result)
        self.assertIn("&amp;", result)
        self.assertIn("&lt;", result)


if __name__ == "__main__":
    unittest.main()
