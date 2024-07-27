import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


/*
The `CERTIFICATE_VERIFY_FAILED` error in Flutter occurs because the SSL certificate of the server is not trusted by the device or emulator. This is common when using self-signed certificates or certificates from unknown authorities. Here are a few approaches to handle this:

### 1. Trust All Certificates (Development Only)
For development purposes, you can bypass SSL certificate validation. This should **not** be used in production as it makes your app vulnerable to man-in-the-middle attacks.

Add the following code to create an HTTP client that ignores certificate errors:

```dart
import 'dart:io';

import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}
```

### 2. Use a Trusted SSL Certificate
For production, you should always use a trusted SSL certificate issued by a Certificate Authority (CA). If you're using a self-signed certificate for testing, consider creating and using a certificate from a trusted CA when deploying your app.

### 3. Add Certificate to Trusted Store
If you have a specific certificate that you want to trust, you can add it to the trusted store of your application. Here’s how you can do it:

#### Android
1. Place the certificate file in the `android/app/src/main/res/raw` directory.
2. Modify your `AndroidManifest.xml` to use the custom SSL configuration:

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
    ...
</application>
```

3. Create `network_security_config.xml` in `android/app/src/main/res/xml/`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">ani14-wound-detect.hf.space</domain>
        <trust-anchors>
            <certificates src="@raw/your_certificate"/>
        </trust-anchors>
    </domain-config>
</network-security-config>
```

#### iOS
1. Place the certificate in the `ios/Runner` directory.
2. Modify the `Info.plist` to include the certificate:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>ani14-wound-detect.hf.space</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
            <key>NSRequiresCertificateTransparency</key>
            <false/>
        </dict>
    </dict>
</dict>
```

### 4. Use Dart's HTTP Client with Custom Certificates
For a more controlled approach, you can use Dart's HTTP client with your custom certificates:

1. Add the `http` and `http/io` packages to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^0.13.3
  http_io: ^0.3.0
```

2. Create a custom HTTP client that trusts your certificate:

```dart
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

Future<http.Client> createHttpClient() async {
  final context = SecurityContext.defaultContext;
  // Load your certificate
  final cert = await rootBundle.load('assets/your_certificate.pem');
  context.setTrustedCertificatesBytes(cert.buffer.asUint8List());

  final client = HttpClient(context: context)
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

  return IOClient(client);
}
```

Then use this client to make your HTTP requests:

```dart
void main() async {
  final client = await createHttpClient();
  final response = await client.get(Uri.parse('https://ani14-wound-detect.hf.space/analyze_wound'));

  print(response.body);
}
```

### Summary
1. For **development**: Bypass SSL certificate validation.
2. For **production**: Use a trusted SSL certificate or add your certificate to the trusted store.

Always prioritize security in production environments.
*/