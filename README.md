# jButtonFlash (WotLK 3.3.5a port)

Flashes a star animation on an action button when it is pressed. Works with the default Blizzard bars and Bartender4 (`BT4Button1..120`).

Port of [jButtonFlash](https://github.com/jwldnr) by **jwldnr** (retail/Classic) to the 3.3.5a client (Warmane and other WotLK servers).

This addon only adds the visual. To make keys fire on key *press*, use it alongside SnowfallKeyPress.

## Install
Copy the `jButtonFlash` folder into `Interface\AddOns`.

## Changes from the original
- Interface bumped to 30300.
- `Alpha` animation uses `SetChange` (no `SetFromAlpha/SetToAlpha` in 3.3.5a).
- Removed `GetActionButtonForID` and the `ActionButtonDown` hooks; buttons are hooked via `PreClick` instead, so Bartender4 works.
- Buttons are re-hooked on `PLAYER_ENTERING_WORLD` to catch late-created bars.

## Credits
Original addon by jwldnr. Check the upstream repository for its license terms.
