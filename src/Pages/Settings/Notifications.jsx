import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Save, Bell, Mail, MessageSquare, ShoppingBag, Users, AlertCircle, Megaphone } from "lucide-react";

function Notifications() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [notifications, setNotifications] = useState({
    emailNotifications: true,
    pushNotifications: true,
    smsNotifications: false,
    orderUpdates: true,
    paymentAlerts: true,
    productAlerts: true,
    userActivity: false,
    systemAlerts: true,
    marketingEmails: false,
    dailyDigest: true,
    weeklyReport: true
  });

  const handleChange = (e) => {
    const { name, checked } = e.target;
    setNotifications({ ...notifications, [name]: checked });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Notification settings saved successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-gray-700 to-gray-900 bg-clip-text text-transparent">
            Notification Settings
          </h1>
          <p className="text-gray-500 mt-2">Manage how you receive notifications</p>
        </div>

        <div className="max-w-4xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Notification Channels */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Bell className="w-5 h-5 text-blue-600" />
                Notification Channels
              </h2>
              <div className="space-y-3">
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Email Notifications</p>
                    <p className="text-sm text-gray-500">Receive notifications via email</p>
                  </div>
                  <input
                    type="checkbox"
                    name="emailNotifications"
                    checked={notifications.emailNotifications}
                    onChange={handleChange}
                    className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Push Notifications</p>
                    <p className="text-sm text-gray-500">Receive browser push notifications</p>
                  </div>
                  <input
                    type="checkbox"
                    name="pushNotifications"
                    checked={notifications.pushNotifications}
                    onChange={handleChange}
                    className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">SMS Notifications</p>
                    <p className="text-sm text-gray-500">Receive notifications via SMS</p>
                  </div>
                  <input
                    type="checkbox"
                    name="smsNotifications"
                    checked={notifications.smsNotifications}
                    onChange={handleChange}
                    className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
                  />
                </label>
              </div>
            </div>

            {/* Business Notifications */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <ShoppingBag className="w-5 h-5 text-green-600" />
                Business Notifications
              </h2>
              <div className="space-y-3">
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Order Updates</p>
                    <p className="text-sm text-gray-500">New orders, status changes, deliveries</p>
                  </div>
                  <input
                    type="checkbox"
                    name="orderUpdates"
                    checked={notifications.orderUpdates}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Payment Alerts</p>
                    <p className="text-sm text-gray-500">Payment received, failed, refunds</p>
                  </div>
                  <input
                    type="checkbox"
                    name="paymentAlerts"
                    checked={notifications.paymentAlerts}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Product Alerts</p>
                    <p className="text-sm text-gray-500">Low stock, new products, price changes</p>
                  </div>
                  <input
                    type="checkbox"
                    name="productAlerts"
                    checked={notifications.productAlerts}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
              </div>
            </div>

            {/* System Notifications */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <AlertCircle className="w-5 h-5 text-yellow-600" />
                System Notifications
              </h2>
              <div className="space-y-3">
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">User Activity</p>
                    <p className="text-sm text-gray-500">New registrations, logins, user actions</p>
                  </div>
                  <input
                    type="checkbox"
                    name="userActivity"
                    checked={notifications.userActivity}
                    onChange={handleChange}
                    className="w-5 h-5 text-yellow-600 rounded focus:ring-yellow-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">System Alerts</p>
                    <p className="text-sm text-gray-500">Maintenance, errors, security alerts</p>
                  </div>
                  <input
                    type="checkbox"
                    name="systemAlerts"
                    checked={notifications.systemAlerts}
                    onChange={handleChange}
                    className="w-5 h-5 text-yellow-600 rounded focus:ring-yellow-500"
                  />
                </label>
              </div>
            </div>

            {/* Email Subscriptions */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Mail className="w-5 h-5 text-purple-600" />
                Email Subscriptions
              </h2>
              <div className="space-y-3">
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Marketing Emails</p>
                    <p className="text-sm text-gray-500">Promotions, offers, newsletters</p>
                  </div>
                  <input
                    type="checkbox"
                    name="marketingEmails"
                    checked={notifications.marketingEmails}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Daily Digest</p>
                    <p className="text-sm text-gray-500">Summary of daily activities</p>
                  </div>
                  <input
                    type="checkbox"
                    name="dailyDigest"
                    checked={notifications.dailyDigest}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Weekly Report</p>
                    <p className="text-sm text-gray-500">Weekly performance report</p>
                  </div>
                  <input
                    type="checkbox"
                    name="weeklyReport"
                    checked={notifications.weeklyReport}
                    onChange={handleChange}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                </label>
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
                Save Preferences
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default Notifications;