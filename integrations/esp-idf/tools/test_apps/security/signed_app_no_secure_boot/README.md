| Supported Targets | ESP32-C2 | ESP32-C3 |
| ----------------- | -------- | -------- |

# Secure Signed On Update No Secure Boot

This examples verifies the case when CONFIG*SECURE*SIGNED*ON*UPDATE*NO*SECURE_BOOT is selected and application is not signed. The application should abort its execution with the logs:

```
secure_boot_v2: No signatures were found for the running app
secure_boot: This app is not signed, but check signature on update is enabled in config. It won't be possible to verify any update.
```