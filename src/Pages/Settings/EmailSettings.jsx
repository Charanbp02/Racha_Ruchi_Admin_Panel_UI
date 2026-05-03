import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Save, Mail, Send, Server, MailCheck, Users } from "lucide-react";

function EmailSettings() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [emailSettings, setEmailSettings] = useState({
    smtpHost: "smtp.gmail.com",
    smtpPort: "587",
    smtpUser: "admin@racharuchi.com",
    smtpPassword: "",
    encryption: "TLS",
    fromEmail: "noreply@racharuchi.com",
    fromName: "Racha Ruchi",
    sendWelcomeEmail: true,
    sendOrderEmail: true,
    sendPaymentEmail: true,
    sendNewsletter: false,
    testEmail: ""
  });

  const [testEmailSent, setTestEmailSent] = useState(false);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setEmailSettings({
      ...emailSettings,
      [name]: type === "checkbox" ? checked : value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const sendTestEmail = () => {
    if (emailSettings.testEmail) {
      setTestEmailSent(true);
      setTimeout(() => setTestEmailSent(false), 3000);
    } else {
      alert("Please enter a test email address");
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Email settings saved successfully
        </div>
      )}
      {testEmailSent && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Test email sent successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-gray-700 to-gray-900 bg-clip-text text-transparent">
            Email Settings
          </h1>
          <p className="text-gray-500 mt-2">Configure email server and notification settings</p>
        </div>

        <div className="max-w-4xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* SMTP Configuration */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Server className="w-5 h-5 text-blue-600" />
                SMTP Configuration
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">SMTP Host</label>
                  <input
                    type="text"
                    name="smtpHost"
                    value={emailSettings.smtpHost}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">SMTP Port</label>
                  <input
                    type="text"
                    name="smtpPort"
                    value={emailSettings.smtpPort}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">SMTP Username</label>
                  <input
                    type="text"
                    name="smtpUser"
                    value={emailSettings.smtpUser}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">SMTP Password</label>
                  <input
                    type="password"
                    name="smtpPassword"
                    value={emailSettings.smtpPassword}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Encryption</label>
                  <select
                    name="encryption"
                    value={emailSettings.encryption}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="TLS">TLS</option>
                    <option value="SSL">SSL</option>
                    <option value="None">None</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Email Content Settings */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Mail className="w-5 h-5 text-green-600" />
                Email Content Settings
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">From Email</label>
                  <input
                    type="email"
                    name="fromEmail"
                    value={emailSettings.fromEmail}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">From Name</label>
                  <input
                    type="text"
                    name="fromName"
                    value={emailSettings.fromName}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
            </div>

            {/* Email Notifications */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <MailCheck className="w-5 h-5 text-purple-600" />
                Email Notifications
              </h2>
              <div className="space-y-3">
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Welcome Email</p>
                    <p className="text-sm text-gray-500">Send welcome email to new users</p>
                  </div>
                  <input
                    type="checkbox"
                    name="sendWelcomeEmail"
                    checked={emailSettings.sendWelcomeEmail}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Order Confirmation</p>
                    <p className="text-sm text-gray-500">Send order confirmation emails</p>
                  </div>
                  <input
                    type="checkbox"
                    name="sendOrderEmail"
                    checked={emailSettings.sendOrderEmail}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Payment Notifications</p>
                    <p className="text-sm text-gray-500">Send payment status emails</p>
                  </div>
                  <input
                    type="checkbox"
                    name="sendPaymentEmail"
                    checked={emailSettings.sendPaymentEmail}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Newsletter</p>
                    <p className="text-sm text-gray-500">Send newsletter to subscribers</p>
                  </div>
                  <input
                    type="checkbox"
                    name="sendNewsletter"
                    checked={emailSettings.sendNewsletter}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
              </div>
            </div>

            {/* Test Email */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Send className="w-5 h-5 text-orange-600" />
                Test Email
              </h2>
              <div className="flex flex-col md:flex-row gap-4">
                <input
                  type="email"
                  name="testEmail"
                  value={emailSettings.testEmail}
                  onChange={handleChange}
                  placeholder="Enter email address to send test"
                  className="flex-1 px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
                <button
                  type="button"
                  onClick={sendTestEmail}
                  className="px-6 py-2 bg-orange-500 text-white rounded-xl font-medium hover:bg-orange-600 transition-all"
                >
                  Send Test Email
                </button>
              </div>
            </div>

            {/* Buttons */}
            <div className="flex gap-4">
              <button
                type="button"
                onClick={() => navigate("/settings")}
                className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-all"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="flex-1 px-6 py-3 bg-gradient-to-r from-gray-700 to-gray-900 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center justify-center gap-2"
              >
                <Save className="w-5 h-5" />
                Save Email Settings
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default EmailSettings;