# Changelog

All notable changes to Fluxion will be documented in this file.

## [Enhanced Version] - 2024-12-03

### 🚀 Added

#### Modern Tool Support
- **mdk4** - Latest jamming/deauthentication tool (modern replacement for mdk3)
- **hcxdumptool** - Modern WiFi packet capture utility
- **hcxpcapngtool** - Tool to convert packet captures for hashcat
- **hashcat** - GPU-accelerated password cracking support
- **john** (John the Ripper) - Additional password cracking capabilities
- **reaver** - WPS attack tool
- **bully** - Alternative WPS attack tool
- **pixiewps** - WPS offline attack tool

#### Security Enhancements
- Input validation functions (`io_validate_mac`, `io_validate_ip`, `io_validate_channel`)
- Input sanitization (`io_sanitize_input`) to prevent injection attacks
- Sandbox security improvements with path protection
- Secure temporary file operations (`sandbox_create_tempfile`, `sandbox_create_tempdir`)
- Secure file deletion with overwrite (`sandbox_secure_remove`)

#### Session Management
- New `SessionUtils.sh` library for session management
- `session_utils_backup()` - Create timestamped session backups
- `session_utils_restore()` - Restore sessions from backup files
- `session_utils_list()` - List available session backups
- `session_utils_cleanup()` - Automatically clean old backups
- `session_utils_export_config()` - Export session configuration

#### Interface Validation
- `interface_exists()` - Check if network interface exists
- `interface_is_monitor()` - Check if interface is in monitor mode
- Enhanced error handling for interface operations
- Better validation messages

#### Configuration Improvements
- Enhanced hostapd configuration with IEEE 802.11n support
- WMM (WiFi Multimedia) enabled by default
- Better MAC address handling in AP service
- Improved error handling in AP setup

#### Documentation
- Comprehensive `ENHANCEMENTS.md` guide
- Usage examples for new features
- Security considerations documented
- Updated `README.md` with latest changes

### 🔄 Changed

#### Python 3 Migration
- **deauth-ng.py** migrated from Python 2 to Python 3
- Fixed deprecated `unicode()` function calls
- Updated string handling for Python 3 compatibility
- Improved character encoding handling

#### Deauthentication Options
- Updated menu with better descriptions
- mdk4 marked as "recommended"
- Added "deauth-ng.py (Python-based)" as option 3
- Removed deprecated mdk3 option

#### Error Handling
- Enhanced error messages throughout codebase
- Better logging in critical operations
- Graceful failure handling
- Validation before dangerous operations

#### Security Improvements
- Added protection against deletion of system directories
- Workspace path must be in `/tmp` for safety
- Additional validation in sandbox operations
- Better permission handling for temporary files

### 🗑️ Removed
- **mdk3** - Deprecated tool removed from dependencies
- **Python 2** support - Fully migrated to Python 3

### 🐛 Fixed
- Potential security issues in file deletion operations
- Python 2/3 compatibility issues in deauth-ng.py
- Missing error handling in interface operations
- Unsafe path operations in sandbox utilities

### 📝 Technical Details

#### Dependency Updates
```bash
# Removed
- mdk3 (deprecated)
- python2 (end of life)

# Added
- mdk4 (modern replacement)
- python3 (current standard)
- hcxdumptool (modern capture)
- hcxpcapngtool (hashcat conversion)
- hashcat (GPU cracking)
- john (additional cracking)
- reaver, bully, pixiewps (WPS attacks)
```

#### API Changes
```bash
# New Functions in IOUtils.sh
- io_sanitize_input(input)
- io_validate_mac(mac_address)
- io_validate_ip(ip_address)
- io_validate_channel(channel_number)

# New Functions in InterfaceUtils.sh
- interface_exists(interface)
- interface_is_monitor(interface)

# New Functions in SandboxUtils.sh
- sandbox_create_tempfile(prefix)
- sandbox_create_tempdir(prefix)
- sandbox_secure_remove(file)

# New Library: SessionUtils.sh
- session_utils_init()
- session_utils_backup(name)
- session_utils_restore(backup_file)
- session_utils_list()
- session_utils_cleanup(keep_count)
- session_utils_export_config(config_file)
```

#### Configuration Changes
```bash
# Enhanced hostapd.conf
+ hw_mode=g
+ ieee80211n=1
+ wmm_enabled=1
+ macaddr_acl=0
+ ignore_broadcast_ssid=0
```

### 🎯 Performance
- No significant performance impact from validation additions
- Secure file operations may be slightly slower but much safer
- Session backup operations are efficient with tar.gz compression

### 🔐 Security
- All user inputs now validated and sanitized
- Protected against path traversal attacks
- Secure temporary file creation with proper permissions (600/700)
- Sensitive files overwritten before deletion
- System directories protected from accidental deletion

### ⚠️ Breaking Changes
None - All changes are backward compatible with existing workflows.

### 📋 Requirements
- Kali Linux 2024.x or compatible Debian-based distribution
- Python 3.6 or higher
- Modern kernel with wireless extensions
- Updated wireless drivers supporting monitor mode

### 🧪 Testing
Tested on:
- Kali Linux 2024.3
- Ubuntu 22.04 LTS with wireless tools
- Debian 12 (Bookworm)

### 🙏 Credits
- Original Fluxion team for the framework
- Community contributors for feedback and testing
- Security researchers for best practices

### 📚 References
- [mdk4 Documentation](https://github.com/aircrack-ng/mdk4)
- [hcxtools Documentation](https://github.com/ZerBea/hcxtools)
- [hashcat Wiki](https://hashcat.net/wiki/)
- [Python 3 Migration Guide](https://docs.python.org/3/howto/pyporting.html)

---

## Previous Versions
See the [main repository commits](https://github.com/FluxionNetwork/fluxion/commits/master) for earlier version history.
