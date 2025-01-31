# Privacy Policy for Nexus Tools

Nexus Tools is committed to respecting your privacy and being transparent about the collected data. This policy outlines what information is transmitted during the installation and use of Nexus Tools, how it is used, and how you can control the collection.

## Information collected by Nexus Tools

Nexus Tools uses the privacy-friendly Plausible Analytics, which is subject to the [Plausible Analytics Privacy Policy](https://plausible.io/privacy). Nexus Tools transmits the following information over an encrypted HTTPS connection:

- **Operating system:** The type of operating system, such as Linux or WSL.
- **CPU architecture:** x86, ARM, etc.
- **IP address**: This is used to identify your country and region.

This data is only collected when installing or updating the Android SDK Platform Tools, and it is anonymized by Plausible Analytics. For example, your IP address is not visible to the developers of Nexus Tools.

Nexus Tools downloads the Android SDK Platform Tools package directly from Google's servers, which is subject to the [Android Studio terms and conditions](https://developer.android.com/studio/terms).

## How Nexus Tools uses your information

Nexus Tools uses analytics data to determine which operating systems and CPU architectures are used the most often, which helps prioritize development. The data can also help identify problems with certain platforms.

The analytics data is stored in Plausible Analytics and is not shared or sold.

## How to control data collection in Nexus Tools

If you prefer not to transmit any analytics data, you can disable this feature in the Nexus Tools command. This setting is not stored.

To install Nexus Tools without sending any analytics data, use the `--no-analytics` flag in your installation command:

```bash
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/main/install.sh) --no-analytics
```

If you're running Nexus Tools from a local installation, use the following command:

```bash
nexustools --no-analytics
```

## Contact information

If you have any questions or concerns regarding this Privacy Policy, please submit a question or report an issue through the [GitHub issues page](https://github.com/corbindavenport/nexus-tools/issues). You can also send an email to [corbindavenport at outlook.com](mailto:corbindavenport@outlook.com?subject=Nexus%20Tools%20Privacy).

## Changes to the Privacy Policy

This Privacy Policy may be updated from time to time. Any changes will be reflected on this page.