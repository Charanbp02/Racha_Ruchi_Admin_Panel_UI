class GeneralSettings {
  final String siteName;
  final String siteLogo;
  final String siteFavicon;
  final String siteDescription;
  final String siteKeywords;
  final String timezone;
  final String dateFormat;
  final String timeFormat;
  final String language;
  final bool maintenanceMode;
  final String maintenanceMessage;
  final bool siteEnabled;
  final String siteOfflineMessage;

  GeneralSettings({
    required this.siteName,
    required this.siteLogo,
    required this.siteFavicon,
    required this.siteDescription,
    required this.siteKeywords,
    required this.timezone,
    required this.dateFormat,
    required this.timeFormat,
    required this.language,
    required this.maintenanceMode,
    required this.maintenanceMessage,
    required this.siteEnabled,
    required this.siteOfflineMessage,
  });

  GeneralSettings copyWith({
    String? siteName,
    String? siteLogo,
    String? siteFavicon,
    String? siteDescription,
    String? siteKeywords,
    String? timezone,
    String? dateFormat,
    String? timeFormat,
    String? language,
    bool? maintenanceMode,
    String? maintenanceMessage,
    bool? siteEnabled,
    String? siteOfflineMessage,
  }) {
    return GeneralSettings(
      siteName: siteName ?? this.siteName,
      siteLogo: siteLogo ?? this.siteLogo,
      siteFavicon: siteFavicon ?? this.siteFavicon,
      siteDescription: siteDescription ?? this.siteDescription,
      siteKeywords: siteKeywords ?? this.siteKeywords,
      timezone: timezone ?? this.timezone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      language: language ?? this.language,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      siteEnabled: siteEnabled ?? this.siteEnabled,
      siteOfflineMessage: siteOfflineMessage ?? this.siteOfflineMessage,
    );
  }
}

class ProfileSettings {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String role;
  final String bio;
  final String website;
  final String location;
  final String company;
  final Map<String, dynamic> socialLinks;

  ProfileSettings({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.role,
    required this.bio,
    required this.website,
    required this.location,
    required this.company,
    required this.socialLinks,
  });

  ProfileSettings copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? role,
    String? bio,
    String? website,
    String? location,
    String? company,
    Map<String, dynamic>? socialLinks,
  }) {
    return ProfileSettings(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      location: location ?? this.location,
      company: company ?? this.company,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}

class SecuritySettings {
  final bool twoFactorAuth;
  final String twoFactorMethod;
  final bool loginNotifications;
  final bool deviceManagement;
  final int sessionTimeout;
  final bool ipWhitelistEnabled;
  final List<String> ipWhitelist;
  final bool passwordExpiry;
  final int passwordExpiryDays;
  final bool requireStrongPassword;
  final bool lockAfterFailedAttempts;
  final int maxFailedAttempts;
  final bool backupCodesEnabled;
  final List<String> backupCodes;

  SecuritySettings({
    required this.twoFactorAuth,
    required this.twoFactorMethod,
    required this.loginNotifications,
    required this.deviceManagement,
    required this.sessionTimeout,
    required this.ipWhitelistEnabled,
    required this.ipWhitelist,
    required this.passwordExpiry,
    required this.passwordExpiryDays,
    required this.requireStrongPassword,
    required this.lockAfterFailedAttempts,
    required this.maxFailedAttempts,
    required this.backupCodesEnabled,
    required this.backupCodes,
  });

  SecuritySettings copyWith({
    bool? twoFactorAuth,
    String? twoFactorMethod,
    bool? loginNotifications,
    bool? deviceManagement,
    int? sessionTimeout,
    bool? ipWhitelistEnabled,
    List<String>? ipWhitelist,
    bool? passwordExpiry,
    int? passwordExpiryDays,
    bool? requireStrongPassword,
    bool? lockAfterFailedAttempts,
    int? maxFailedAttempts,
    bool? backupCodesEnabled,
    List<String>? backupCodes,
  }) {
    return SecuritySettings(
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      twoFactorMethod: twoFactorMethod ?? this.twoFactorMethod,
      loginNotifications: loginNotifications ?? this.loginNotifications,
      deviceManagement: deviceManagement ?? this.deviceManagement,
      sessionTimeout: sessionTimeout ?? this.sessionTimeout,
      ipWhitelistEnabled: ipWhitelistEnabled ?? this.ipWhitelistEnabled,
      ipWhitelist: ipWhitelist ?? this.ipWhitelist,
      passwordExpiry: passwordExpiry ?? this.passwordExpiry,
      passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
      requireStrongPassword:
          requireStrongPassword ?? this.requireStrongPassword,
      lockAfterFailedAttempts:
          lockAfterFailedAttempts ?? this.lockAfterFailedAttempts,
      maxFailedAttempts: maxFailedAttempts ?? this.maxFailedAttempts,
      backupCodesEnabled: backupCodesEnabled ?? this.backupCodesEnabled,
      backupCodes: backupCodes ?? this.backupCodes,
    );
  }
}

class NotificationSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool orderUpdates;
  final bool paymentAlerts;
  final bool productUpdates;
  final bool systemAlerts;
  final bool marketingEmails;
  final bool newsletter;
  final bool dailyDigest;
  final bool weeklyReport;
  final String notificationSound;
  final bool desktopNotifications;
  final bool mobileNotifications;

  NotificationSettings({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.orderUpdates,
    required this.paymentAlerts,
    required this.productUpdates,
    required this.systemAlerts,
    required this.marketingEmails,
    required this.newsletter,
    required this.dailyDigest,
    required this.weeklyReport,
    required this.notificationSound,
    required this.desktopNotifications,
    required this.mobileNotifications,
  });

  NotificationSettings copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? orderUpdates,
    bool? paymentAlerts,
    bool? productUpdates,
    bool? systemAlerts,
    bool? marketingEmails,
    bool? newsletter,
    bool? dailyDigest,
    bool? weeklyReport,
    String? notificationSound,
    bool? desktopNotifications,
    bool? mobileNotifications,
  }) {
    return NotificationSettings(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      paymentAlerts: paymentAlerts ?? this.paymentAlerts,
      productUpdates: productUpdates ?? this.productUpdates,
      systemAlerts: systemAlerts ?? this.systemAlerts,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      newsletter: newsletter ?? this.newsletter,
      dailyDigest: dailyDigest ?? this.dailyDigest,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      notificationSound: notificationSound ?? this.notificationSound,
      desktopNotifications: desktopNotifications ?? this.desktopNotifications,
      mobileNotifications: mobileNotifications ?? this.mobileNotifications,
    );
  }
}

class PaymentSettings {
  final String currency;
  final String currencySymbol;
  final bool enablePayPal;
  final String payPalClientId;
  final String payPalSecret;
  final bool enableStripe;
  final String stripePublicKey;
  final String stripeSecretKey;
  final bool enableRazorpay;
  final String razorpayKeyId;
  final String razorpayKeySecret;
  final bool enableCashOnDelivery;
  final bool enableBankTransfer;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String routingNumber;
  final bool enableWallet;
  final double minWalletAmount;
  final double maxWalletAmount;

  PaymentSettings({
    required this.currency,
    required this.currencySymbol,
    required this.enablePayPal,
    required this.payPalClientId,
    required this.payPalSecret,
    required this.enableStripe,
    required this.stripePublicKey,
    required this.stripeSecretKey,
    required this.enableRazorpay,
    required this.razorpayKeyId,
    required this.razorpayKeySecret,
    required this.enableCashOnDelivery,
    required this.enableBankTransfer,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.routingNumber,
    required this.enableWallet,
    required this.minWalletAmount,
    required this.maxWalletAmount,
  });

  PaymentSettings copyWith({
    String? currency,
    String? currencySymbol,
    bool? enablePayPal,
    String? payPalClientId,
    String? payPalSecret,
    bool? enableStripe,
    String? stripePublicKey,
    String? stripeSecretKey,
    bool? enableRazorpay,
    String? razorpayKeyId,
    String? razorpayKeySecret,
    bool? enableCashOnDelivery,
    bool? enableBankTransfer,
    String? bankName,
    String? accountName,
    String? accountNumber,
    String? routingNumber,
    bool? enableWallet,
    double? minWalletAmount,
    double? maxWalletAmount,
  }) {
    return PaymentSettings(
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      enablePayPal: enablePayPal ?? this.enablePayPal,
      payPalClientId: payPalClientId ?? this.payPalClientId,
      payPalSecret: payPalSecret ?? this.payPalSecret,
      enableStripe: enableStripe ?? this.enableStripe,
      stripePublicKey: stripePublicKey ?? this.stripePublicKey,
      stripeSecretKey: stripeSecretKey ?? this.stripeSecretKey,
      enableRazorpay: enableRazorpay ?? this.enableRazorpay,
      razorpayKeyId: razorpayKeyId ?? this.razorpayKeyId,
      razorpayKeySecret: razorpayKeySecret ?? this.razorpayKeySecret,
      enableCashOnDelivery: enableCashOnDelivery ?? this.enableCashOnDelivery,
      enableBankTransfer: enableBankTransfer ?? this.enableBankTransfer,
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      routingNumber: routingNumber ?? this.routingNumber,
      enableWallet: enableWallet ?? this.enableWallet,
      minWalletAmount: minWalletAmount ?? this.minWalletAmount,
      maxWalletAmount: maxWalletAmount ?? this.maxWalletAmount,
    );
  }
}

class EmailSettings {
  final String smtpHost;
  final int smtpPort;
  final String smtpUser;
  final String smtpPassword;
  final String smtpEncryption;
  final bool smtpAuth;
  final String fromEmail;
  final String fromName;
  final String replyToEmail;
  final String bccEmail;
  final bool emailVerification;
  final bool welcomeEmail;
  final bool passwordResetEmail;
  final String emailTemplate;
  final String emailSignature;

  EmailSettings({
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpUser,
    required this.smtpPassword,
    required this.smtpEncryption,
    required this.smtpAuth,
    required this.fromEmail,
    required this.fromName,
    required this.replyToEmail,
    required this.bccEmail,
    required this.emailVerification,
    required this.welcomeEmail,
    required this.passwordResetEmail,
    required this.emailTemplate,
    required this.emailSignature,
  });

  EmailSettings copyWith({
    String? smtpHost,
    int? smtpPort,
    String? smtpUser,
    String? smtpPassword,
    String? smtpEncryption,
    bool? smtpAuth,
    String? fromEmail,
    String? fromName,
    String? replyToEmail,
    String? bccEmail,
    bool? emailVerification,
    bool? welcomeEmail,
    bool? passwordResetEmail,
    String? emailTemplate,
    String? emailSignature,
  }) {
    return EmailSettings(
      smtpHost: smtpHost ?? this.smtpHost,
      smtpPort: smtpPort ?? this.smtpPort,
      smtpUser: smtpUser ?? this.smtpUser,
      smtpPassword: smtpPassword ?? this.smtpPassword,
      smtpEncryption: smtpEncryption ?? this.smtpEncryption,
      smtpAuth: smtpAuth ?? this.smtpAuth,
      fromEmail: fromEmail ?? this.fromEmail,
      fromName: fromName ?? this.fromName,
      replyToEmail: replyToEmail ?? this.replyToEmail,
      bccEmail: bccEmail ?? this.bccEmail,
      emailVerification: emailVerification ?? this.emailVerification,
      welcomeEmail: welcomeEmail ?? this.welcomeEmail,
      passwordResetEmail: passwordResetEmail ?? this.passwordResetEmail,
      emailTemplate: emailTemplate ?? this.emailTemplate,
      emailSignature: emailSignature ?? this.emailSignature,
    );
  }
}

class IntegrationSettings {
  final bool enableGoogleAnalytics;
  final String googleAnalyticsId;
  final bool enableFacebookPixel;
  final String facebookPixelId;
  final bool enableTwitterAnalytics;
  final String twitterAnalyticsId;
  final bool enableMailchimp;
  final String mailchimpApiKey;
  final String mailchimpListId;
  final bool enableSlack;
  final String slackWebhookUrl;
  final String slackChannel;
  final bool enableDiscord;
  final String discordWebhookUrl;
  final bool enableZapier;
  final String zapierWebhookUrl;
  final bool enableCloudinary;
  final String cloudinaryCloudName;
  final String cloudinaryApiKey;
  final String cloudinaryApiSecret;

  IntegrationSettings({
    required this.enableGoogleAnalytics,
    required this.googleAnalyticsId,
    required this.enableFacebookPixel,
    required this.facebookPixelId,
    required this.enableTwitterAnalytics,
    required this.twitterAnalyticsId,
    required this.enableMailchimp,
    required this.mailchimpApiKey,
    required this.mailchimpListId,
    required this.enableSlack,
    required this.slackWebhookUrl,
    required this.slackChannel,
    required this.enableDiscord,
    required this.discordWebhookUrl,
    required this.enableZapier,
    required this.zapierWebhookUrl,
    required this.enableCloudinary,
    required this.cloudinaryCloudName,
    required this.cloudinaryApiKey,
    required this.cloudinaryApiSecret,
  });

  IntegrationSettings copyWith({
    bool? enableGoogleAnalytics,
    String? googleAnalyticsId,
    bool? enableFacebookPixel,
    String? facebookPixelId,
    bool? enableTwitterAnalytics,
    String? twitterAnalyticsId,
    bool? enableMailchimp,
    String? mailchimpApiKey,
    String? mailchimpListId,
    bool? enableSlack,
    String? slackWebhookUrl,
    String? slackChannel,
    bool? enableDiscord,
    String? discordWebhookUrl,
    bool? enableZapier,
    String? zapierWebhookUrl,
    bool? enableCloudinary,
    String? cloudinaryCloudName,
    String? cloudinaryApiKey,
    String? cloudinaryApiSecret,
  }) {
    return IntegrationSettings(
      enableGoogleAnalytics:
          enableGoogleAnalytics ?? this.enableGoogleAnalytics,
      googleAnalyticsId: googleAnalyticsId ?? this.googleAnalyticsId,
      enableFacebookPixel: enableFacebookPixel ?? this.enableFacebookPixel,
      facebookPixelId: facebookPixelId ?? this.facebookPixelId,
      enableTwitterAnalytics:
          enableTwitterAnalytics ?? this.enableTwitterAnalytics,
      twitterAnalyticsId: twitterAnalyticsId ?? this.twitterAnalyticsId,
      enableMailchimp: enableMailchimp ?? this.enableMailchimp,
      mailchimpApiKey: mailchimpApiKey ?? this.mailchimpApiKey,
      mailchimpListId: mailchimpListId ?? this.mailchimpListId,
      enableSlack: enableSlack ?? this.enableSlack,
      slackWebhookUrl: slackWebhookUrl ?? this.slackWebhookUrl,
      slackChannel: slackChannel ?? this.slackChannel,
      enableDiscord: enableDiscord ?? this.enableDiscord,
      discordWebhookUrl: discordWebhookUrl ?? this.discordWebhookUrl,
      enableZapier: enableZapier ?? this.enableZapier,
      zapierWebhookUrl: zapierWebhookUrl ?? this.zapierWebhookUrl,
      enableCloudinary: enableCloudinary ?? this.enableCloudinary,
      cloudinaryCloudName: cloudinaryCloudName ?? this.cloudinaryCloudName,
      cloudinaryApiKey: cloudinaryApiKey ?? this.cloudinaryApiKey,
      cloudinaryApiSecret: cloudinaryApiSecret ?? this.cloudinaryApiSecret,
    );
  }
}
