# Changelog

## 1.0.1
- Fix: the flash did not work on every Bartender4 bar. Bartender4 only creates the buttons of enabled bars, and the scan stopped at the first missing button, so the bars after a disabled one were skipped. It now checks every button, also hooks buttons a bar creates later (enabling a bar, changing profile), and covers the pet and stance bars.

## 1.0.0
- Initial 3.3.5a port.
