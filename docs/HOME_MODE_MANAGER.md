# Home Mode Manager

**Version:** 2.0
**Author:** PezAustral
**License:** MIT
**Date:** January 2026

---

## Overview

**Home Mode Manager** is a comprehensive Home Assistant package that tracks and manages global house states (modes) to enable intelligent, context-aware home automations.

Instead of each automation making independent decisions, Home Mode Manager provides a single source of truth about your home's current state, allowing all automations to respond intelligently based on context.

### The Problem It Solves

**Before (without modes):**
```yaml
# Each automation acts independently
automation:
  - trigger: { platform: state, entity_id: binary_sensor.motion }
    action:
      - service: light.turn_on
        data:
          brightness_pct: 80  # Always 80%, even at 3 AM!
```

**After (with Home Mode Manager):**
```yaml
# Automations respect global context
automation:
  - trigger: { platform: state, entity_id: binary_sensor.motion }
    action:
      - service: light.turn_on
        data:
          brightness_pct: >
            {% if is_state('input_select.home_mode', 'sleeping') %} 10
            {% elif is_state('input_select.home_mode', 'night') %} 40
            {% else %} 80 {% endif %}
```

---

## Features

### 🎯 Core Features
- ✅ **5 predefined modes:** normal, away, sleeping, night, guest
- ✅ **Automatic transitions** based on time, sun position, and presence
- ✅ **Manual override** with auto-reset (prevents getting stuck in manual mode)
- ✅ **Voice control integration** (customizable commands)
- ✅ **Scene synchronization** (optional, link modes to scenes)
- ✅ **Highly configurable** (all parameters adjustable via UI)
- ✅ **Dashboard widget included** (copy-paste ready)
- ✅ **Zero dependencies** (works standalone)

### 🎨 Use Cases
- Smart lighting that adjusts brightness based on time and activity
- Energy saving by turning off devices when away
- Do-not-disturb mode when sleeping
- Security automations when house is empty
- Guest mode with different behavior

---

## Available Modes

| Mode | Description | When Activated | Typical Use |
|------|-------------|----------------|-------------|
| **normal** | House occupied, normal activity | Sunrise + presence | Full brightness, all automations active |
| **night** | Night time but awake | Sunset + presence | Reduced brightness (30-50%) |
| **sleeping** | Everyone sleeping | Configured time or no activity | Minimal brightness (5-15%), silent notifications |
| **away** | Nobody home | No presence for X minutes | Lights off, security active, energy saving |
| **guest** | Guest mode | Manual activation | Special behavior for visitors |

---

## Installation

### Prerequisites
- Home Assistant 2023.1 or newer
- Packages enabled in `configuration.yaml`

### Step 1: Enable Packages

Edit your `/config/configuration.yaml`:

```yaml
homeassistant:
  packages: !include_dir_named packages
```

### Step 2: Install the Package

Copy `home_mode_manager.yaml` to your `/config/packages/` folder:

```bash
cp home_mode_manager.yaml /config/packages/
```

### Step 3: Restart Home Assistant

```
Settings → System → Restart
```

### Step 4: Configure Presence Detection

Edit `/config/packages/home_mode_manager.yaml` around line 148 and add your presence sensors:

```yaml
template:
  - binary_sensor:
      - name: "HMM Anyone Home"
        state: >
          {# Add your presence sensors here #}
          {% set bedroom = is_state('binary_sensor.smartnode1_presence', 'on') %}
          {% set living = is_state('binary_sensor.motion_living', 'on') %}
          {% set kitchen = is_state('binary_sensor.motion_kitchen', 'on') %}

          {{ bedroom or living or kitchen }}
```

### Step 5: Add Dashboard Widget

Copy the dashboard YAML from the package (bottom section) to your Lovelace dashboard.

Or use this minimal version:

```yaml
type: entities
title: 🏠 Home Mode
entities:
  - entity: input_select.home_mode
    name: Current Mode
  - entity: sensor.hmm_mode_description
    name: Status
```

---

## Configuration

All settings are adjustable via the Home Assistant UI after installation.

### Sleep Schedule

Configure when the system should automatically enter sleeping mode:

- **Sleep Time Start:** Hour and minute (default: 23:30)
- **Wake Time:** Hour and minute (default: 07:00)

Go to: `Settings → Devices & Services → Helpers` and search for "HMM"

### Timeouts

- **Away Timeout:** Minutes without presence before switching to away mode (default: 15)
- **Sleep Detection:** Minutes of no activity during sleep hours to enter sleeping mode (default: 30)

### Optional Features

Enable/disable via toggles in the dashboard:

- **Manual Control:** When enabled, automatic transitions are paused (auto-resets after 2 hours)
- **Scene Sync:** Link mode changes to scenes (requires scene configuration)
- **Voice Control:** Enable/disable voice commands

---

## Voice Control

### Included Commands

| Command | Action | Mode |
|---------|--------|------|
| "Ta mañana" | Good night | → sleeping |
| "Buenos días" / "Buen día" | Good morning | → normal |
| "Nos vamos" / "Me voy" / "Salimos" | Leaving | → away |

### Adding Custom Commands

Edit the package and add new automations:

```yaml
automation:
  - id: hmm_voice_custom
    alias: "[HMM] Voice - Custom Command"
    trigger:
      - platform: conversation
        command: "Your custom phrase"
    condition:
      - condition: state
        entity_id: input_boolean.hmm_enable_voice_control
        state: "on"
    action:
      - service: script.hmm_force_mode
        data:
          mode: normal  # or any other mode
```

---

## Scene Integration

### How It Works

When **Scene Sync** is enabled, mode changes automatically trigger corresponding scenes.

### Default Mappings

| Mode Change | Scene Triggered |
|-------------|----------------|
| → sleeping | `scene.nueva_escena` |
| → night | `scene.anocheser` |
| → normal (at sunrise) | `scene.amanecer` |

### Customizing Scene Mappings

Edit the `hmm_scene_sync` automation in the package:

```yaml
- conditions:
    - condition: template
      value_template: "{{ trigger.to_state.state == 'night' }}"
  sequence:
    - service: scene.turn_on
      target:
        entity_id: scene.your_night_scene  # Change this
```

---

## Integration with SmartNode Lighting

Use the **SmartNode Presence Lighting v2** blueprint to automatically adjust light brightness based on the current mode.

### Configuration Example

```yaml
automation:
  - alias: "SmartNode - Bedroom with Mode Manager"
    use_blueprint:
      path: smartnode_presence_lighting_v2.yaml
      input:
        presence_sensor: binary_sensor.smartnode1_presence
        brightness_sensor: sensor.smartnode1_illuminance
        light_entity: light.bedroom
        estado_casa_entity: input_select.home_mode
        brightness_normal: 80
        brightness_noche: 40
        brightness_durmiendo: 10
```

---

## API Usage

### Check Current Mode

```python
# Python
mode = hass.states.get('input_select.home_mode').state
```

```jinja
{# Jinja2 Template #}
{{ states('input_select.home_mode') }}
```

### Change Mode Programmatically

```yaml
# In automations or scripts
- service: input_select.select_option
  target:
    entity_id: input_select.home_mode
  data:
    option: sleeping
```

### Force Mode with Manual Override

```yaml
- service: script.hmm_force_mode
  data:
    mode: sleeping
```

This enables manual control and auto-resets after 2 hours.

---

## Advanced Use Cases

### Example 1: Climate Control Based on Mode

```yaml
automation:
  - alias: "Climate - Adjust by Mode"
    trigger:
      - platform: state
        entity_id: input_select.home_mode
    action:
      - choose:
          - conditions: "{{ trigger.to_state.state == 'normal' }}"
            sequence:
              - service: climate.set_temperature
                data: { temperature: 22 }

          - conditions: "{{ trigger.to_state.state == 'away' }}"
            sequence:
              - service: climate.turn_off

          - conditions: "{{ trigger.to_state.state == 'sleeping' }}"
            sequence:
              - service: climate.set_preset_mode
                data: { preset_mode: eco }
```

### Example 2: Silent Notifications When Sleeping

```yaml
automation:
  - alias: "Doorbell - Respect Sleep Mode"
    trigger:
      - platform: state
        entity_id: binary_sensor.doorbell
        to: "on"
    action:
      - choose:
          - conditions:
              - condition: state
                entity_id: input_select.home_mode
                state: sleeping
            sequence:
              - service: notify.mobile_app
                data:
                  message: "Doorbell (silent)"
                  data:
                    push: { sound: none }
        default:
          - service: notify.mobile_app
            data:
              message: "Doorbell!"
```

### Example 3: Security Alerts When Away

```yaml
automation:
  - alias: "Security - Alert When Away"
    trigger:
      - platform: state
        entity_id: binary_sensor.front_door
        to: "on"
    condition:
      - condition: state
        entity_id: input_select.home_mode
        state: away
    action:
      - service: notify.mobile_app
        data:
          title: "🚨 Security Alert"
          message: "Front door opened while away!"
```

---

## Troubleshooting

### Mode Doesn't Change Automatically

**Symptoms:** Mode stays stuck, doesn't transition

**Diagnose:**
1. Check if manual control is enabled:
   ```
   Developer Tools → States → input_boolean.hmm_manual_control
   ```
   Should be `off` for automatic transitions

2. Verify presence sensor is working:
   ```
   Developer Tools → States → binary_sensor.hmm_anyone_home
   ```
   Should show `on` when you're home

3. Check logs:
   ```
   Settings → System → Logs
   Filter: "Home Mode Manager"
   ```

**Solution:**
- Disable manual control via dashboard
- Fix presence sensor configuration in package
- Adjust timeouts if transitions happen too quickly

### Voice Commands Don't Work

**Diagnose:**
1. Check if voice control is enabled:
   ```
   input_boolean.hmm_enable_voice_control → on
   ```

2. Verify conversation integration is set up in HA

**Solution:**
- Enable voice control toggle in dashboard
- Configure Home Assistant's conversation integration
- Check microphone permissions

### Presence Sensor Always Shows "Unknown"

**Cause:** You haven't configured your presence sensors

**Solution:**
Edit the package at line ~148 and add your sensors:

```yaml
- name: "HMM Anyone Home"
  state: >
    {% set room1 = is_state('binary_sensor.your_sensor', 'on') %}
    {% set room2 = is_state('binary_sensor.your_sensor2', 'on') %}
    {{ room1 or room2 }}
```

---

## Customization

### Adding New Modes

1. Edit the package, add your mode to the options:
   ```yaml
   input_select:
     home_mode:
       options:
         - normal
         - away
         - sleeping
         - night
         - guest
         - party  # Your new mode
   ```

2. Add description:
   ```yaml
   - name: "HMM Mode Description"
     state: >
       {% set mode = states('input_select.home_mode') %}
       {% if mode == 'party' %}
         Party Mode - Let's dance!
       {% elif ...
   ```

3. Create automation for the new mode

### Adjusting Transition Logic

Edit automations in the package to change when modes activate. For example, to make "away" activate faster:

```yaml
- id: hmm_to_away
  trigger:
    - platform: state
      entity_id: binary_sensor.hmm_anyone_home
      to: "off"
      for:
        minutes: 5  # Changed from 15 to 5
```

---

## FAQ

### Q: Does this replace scenes?
**A:** No, it complements them. Scenes apply instant configurations, while modes track persistent state. You can link them together with Scene Sync.

### Q: Can I use this without SmartNodes?
**A:** Yes! It works with any presence detection (motion sensors, person tracking, etc.)

### Q: What happens if I restart Home Assistant?
**A:** The current mode is preserved across restarts.

### Q: Can I have different sleep times on weekends?
**A:** Not by default, but you can add conditions to the automations checking `now().weekday()`.

### Q: Does this work with Google Home / Alexa?
**A:** Yes, if you have those integrations configured in Home Assistant. The voice commands use HA's conversation system.

---

## Technical Details

### Entities Created

**Input Select:**
- `input_select.home_mode` - The main mode selector

**Input Booleans:**
- `input_boolean.hmm_manual_control` - Manual override flag
- `input_boolean.hmm_night_detected` - Night time detection
- `input_boolean.hmm_enable_scene_sync` - Scene sync toggle
- `input_boolean.hmm_enable_voice_control` - Voice control toggle

**Input Numbers:**
- `input_number.hmm_sleep_hour_start` - Sleep start hour
- `input_number.hmm_sleep_minute_start` - Sleep start minute
- `input_number.hmm_wake_hour` - Wake hour
- `input_number.hmm_wake_minute` - Wake minute
- `input_number.hmm_away_timeout` - Away timeout in minutes
- `input_number.hmm_sleep_detection_timeout` - Sleep detection timeout

**Binary Sensors:**
- `binary_sensor.hmm_anyone_home` - Presence detection (requires configuration)
- `binary_sensor.hmm_sleep_time` - Is it sleep time?

**Sensors:**
- `sensor.hmm_mode_description` - Human-readable mode description
- `sensor.hmm_time_in_mode` - Time since last mode change
- `sensor.hmm_sleep_time_formatted` - Formatted sleep schedule

**Automations:**
10 automations for mode transitions and voice control

**Scripts:**
- `script.hmm_force_mode` - Force a specific mode
- `script.hmm_auto_mode` - Re-enable automatic mode

---

## Changelog

### Version 2.0 (2026-01-07)
- ✅ Complete rewrite with configurable parameters
- ✅ Voice control integration
- ✅ Scene synchronization
- ✅ Dashboard widget included
- ✅ Manual override with auto-reset
- ✅ Improved automation logic

### Version 1.0
- Initial release with basic mode management

---

## Credits

Created by **PezAustral** for the Home Assistant community.

Inspired by common practices in the HA community for managing house states.

---

## Support

For issues, questions, or contributions:
- Check the documentation first
- Review the troubleshooting section
- Examine logs in Home Assistant
- Customize the package to your needs

---

## License

MIT License - Free to use, modify, and distribute.

```
MIT License

Copyright (c) 2026 PezAustral

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

