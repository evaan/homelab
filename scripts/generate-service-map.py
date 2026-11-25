#!/usr/bin/env python3
"""Draw direct machines/*/configuration.nix service imports as an SVG.

Run: python3 scripts/generate-service-map.py
Output: build/service-map/services.svg (published by GitHub Pages, not committed).
Only conventional ../../services/<name> imports are included, not services
enabled inline or indirectly through other modules. No Nix evaluation is needed.
"""

import re
from pathlib import Path
from xml.etree import ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
SERVICE_IMPORT = re.compile(
    r"^[ \t]*\.\./\.\./services/([\w-]+)(?:/default\.nix|/)?[ \t]*(?:#.*)?$",
    re.MULTILINE,
)
LABELS = {
    "adguardhome": "AdGuard Home",
    "cloudflare-ddns": "Cloudflare DDNS",
}


def discover_services(root):
    hosts = {}
    for configuration in sorted((root / "machines").glob("*/configuration.nix")):
        imports = re.search(
            r"\bimports\s*=\s*\[(.*?)\];", configuration.read_text(), re.DOTALL
        )
        if imports is None:
            raise ValueError(f"No imports list found in {configuration}")
        hosts[configuration.parent.name] = sorted(
            set(SERVICE_IMPORT.findall(imports.group(1)))
        )
    if not hosts:
        raise ValueError(f"No machine configurations found in {root / 'machines'}")
    return hosts


def render_svg(hosts):
    node_width, node_height, gap, margin = 160, 40, 16, 24
    row_height = 168
    columns = max(1, max(map(len, hosts.values())))
    width = columns * (node_width + gap) - gap + 2 * margin
    height = len(hosts) * row_height + 2 * margin
    svg = ET.Element(
        "svg",
        {
            "xmlns": "http://www.w3.org/2000/svg",
            "viewBox": f"0 0 {width} {height}",
            "width": str(width),
            "height": str(height),
            "role": "img",
            "aria-labelledby": "title description",
        },
    )
    ET.SubElement(svg, "title", id="title").text = "Homelab services"
    ET.SubElement(svg, "desc", id="description").text = "; ".join(
        f"{host}: {', '.join(LABELS.get(s, s.replace('-', ' ').title()) for s in services)}"
        for host, services in hosts.items()
    )
    ET.SubElement(svg, "style").text = """
        svg { background: #ffffff; color: #1f2328; }
        rect { fill: #f6f8fa; stroke: #59636e; }
        .host { fill: #ddf4ff; stroke: #0969da; }
        path { fill: none; stroke: #59636e; stroke-width: 1.5; }
        marker path { fill: #59636e; stroke: none; }
        text { fill: currentColor; font: 14px system-ui, sans-serif; }
        .host-label { font-weight: 600; }
        @media (prefers-color-scheme: dark) {
            svg { background: #0d1117; color: #f0f6fc; }
            rect { fill: #151b23; stroke: #9198a1; }
            .host { fill: #121d2f; stroke: #4493f8; }
            path { stroke: #9198a1; }
            marker path { fill: #9198a1; stroke: none; }
        }
    """
    marker = ET.SubElement(
        ET.SubElement(svg, "defs"),
        "marker",
        id="arrow",
        viewBox="0 0 10 10",
        refX="10",
        refY="5",
        markerWidth="6",
        markerHeight="6",
        orient="auto",
    )
    ET.SubElement(marker, "path", d="M 0 0 L 10 5 L 0 10 Z")

    def node(x, y, label, host=False):
        ET.SubElement(
            svg, "rect", x=str(x), y=str(y),
            width=str(node_width), height=str(node_height),
            rx="6", attrib={"class": "host" if host else "service"},
        )
        ET.SubElement(
            svg, "text", x=str(x + node_width / 2), y=str(y + node_height / 2),
            attrib={
                "text-anchor": "middle",
                "dominant-baseline": "middle",
                "class": "host-label" if host else "service-label",
            },
        ).text = label

    for row, (host, services) in enumerate(hosts.items()):
        top = margin + row * row_height
        center = width / 2
        service_y = top + 96
        start = (width - (len(services) * (node_width + gap) - gap)) / 2
        for column, service in enumerate(services):
            x = start + column * (node_width + gap)
            ET.SubElement(
                svg, "path",
                d=f"M {center} {top + node_height} L {x + node_width / 2} {service_y}",
                attrib={"marker-end": "url(#arrow)"},
            )
            node(x, service_y, LABELS.get(service, service.replace("-", " ").title()))
        node(center - node_width / 2, top, host.title(), host=True)

    ET.indent(svg)
    return ET.tostring(svg, encoding="unicode") + "\n"


if __name__ == "__main__":
    output = ROOT / "build" / "service-map" / "services.svg"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(render_svg(discover_services(ROOT)))
    print(f"Generated {output.relative_to(ROOT)}")
