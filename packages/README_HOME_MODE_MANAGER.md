# Home Mode Manager

**Version:** 2.0
**Type:** Home Assistant Package
**License:** MIT

---

## What is This?

**Home Mode Manager** is a self-contained Home Assistant package that provides intelligent house state management. It tracks your home's current "mode" (normal, away, sleeping, night, guest) and enables all your automations to respond intelligently based on context.

---

## Quick Start

### Installation

1. **Copy the package:**
   ```bash
   cp home_mode_manager.yaml /config/packages/
   ```

2. **Enable packages** in `/config/configuration.yaml`:
   ```yaml
   homeassistant:
     packages: !include_dir_named packages
   ```

3. **Restart Home Assistant**

4. **Configure presence sensors** in the package (line ~148)

5. **Add dashboard widget** (YAML included in package comments)

---

## Features

- ✅ 5 predefined modes with automatic transitions
- ✅ Configurable sleep schedule (no hardcoded times)
- ✅ Voice control integration
- ✅ Scene synchronization (optional)
- ✅ Manual override with auto-reset
- ✅ Dashboard widget included
- ✅ Zero external dependencies

---

## Documentation

- **Full Documentation:** `/docs/HOME_MODE_MANAGER.md` (English)
- **Installation Guide for Casita:** `/docs/HOME_MODE_MANAGER_CASITA.md` (Spanish)

---

## Integration with SmartNode

Use with the **SmartNode Presence Lighting v2** blueprint for automatic brightness adjustment:

```yaml
automation:
  use_blueprint:
    path: smartnode_presence_lighting_v2.yaml
    input:
      home_mode_entity: input_select.home_mode  # Link to Home Mode Manager
      brightness_normal: 80
      brightness_noche: 40
      brightness_durmiendo: 10
```

---

## Key Entities

After installation, these entities will be available:

- `input_select.home_mode` - Main mode selector
- `sensor.hmm_mode_description` - Human-readable description
- `binary_sensor.hmm_anyone_home` - Presence detection (requires configuration)
- `script.hmm_force_mode` - Manually force a mode

---

## Configuration

All parameters are configurable via Home Assistant UI:

- Sleep schedule (hour and minute)
- Away timeout
- Sleep detection timeout
- Scene sync toggle
- Voice control toggle

No need to edit YAML after initial setup!

---

## Support

For detailed instructions, troubleshooting, and advanced use cases, see:
- `/docs/HOME_MODE_MANAGER.md`

---

## License

MIT License - Free to use, modify, and distribute.

**Author:** PezAustral
**Date:** January 2026

