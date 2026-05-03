import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { 
  Settings as SettingsIcon, 
  User, 
  Shield, 
  Bell, 
  CreditCard, 
  Mail, 
  Plug, 
  ChevronRight,
  Save,
  Globe,
  Lock,
  Smartphone
} from "lucide-react";

function Settings() {
  const navigate = useNavigate();

  const settingsMenus = [
    { id: 1, name: "General Settings", icon: SettingsIcon, path: "/settings/general", description: "Basic site configuration", color: "bg-blue-100 text-blue-600" },
    { id: 2, name: "Profile Settings", icon: User, path: "/settings/profile", description: "Manage your profile information", color: "bg-green-100 text-green-600" },
    { id: 3, name: "Security", icon: Shield, path: "/settings/security", description: "Password and security options", color: "bg-red-100 text-red-600" },
    { id: 4, name: "Notifications", icon: Bell, path: "/settings/notifications", description: "Configure notification preferences", color: "bg-yellow-100 text-yellow-600" },
    { id: 5, name: "Payment Settings", icon: CreditCard, path: "/settings/payment", description: "Payment gateway configuration", color: "bg-purple-100 text-purple-600" },
    { id: 6, name: "Email Settings", icon: Mail, path: "/settings/email", description: "Email server configuration", color: "bg-indigo-100 text-indigo-600" },
    { id: 7, name: "Integrations", icon: Plug, path: "/settings/integrations", description: "Third-party integrations", color: "bg-pink-100 text-pink-600" },
  ];

  const [showNotification, setShowNotification] = useState(false);

  const stats = {
    lastBackup: "2026-05-02 10:30 AM",
    version: "2.5.0",
    environment: "Production"
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Settings saved successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-gray-700 to-gray-900 bg-clip-text text-transparent">
            Settings
          </h1>
          <p className="text-gray-500 mt-2">Manage your application settings and preferences</p>
        </div>

        {/* System Info Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Last Backup</p>
                <p className="text-sm font-semibold text-gray-800 mt-1">{stats.lastBackup}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                <Save className="w-5 h-5 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Version</p>
                <p className="text-sm font-semibold text-gray-800 mt-1">{stats.version}</p>
              </div>
              <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
                <Globe className="w-5 h-5 text-green-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Environment</p>
                <p className="text-sm font-semibold text-gray-800 mt-1">{stats.environment}</p>
              </div>
              <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                <Lock className="w-5 h-5 text-purple-600" />
              </div>
            </div>
          </div>
        </div>

        {/* Settings Menu Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {settingsMenus.map((menu) => {
            const IconComponent = menu.icon;
            return (
              <div
                key={menu.id}
                onClick={() => navigate(menu.path)}
                className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all cursor-pointer group"
              >
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-4">
                    <div className={`w-12 h-12 ${menu.color} rounded-xl flex items-center justify-center`}>
                      <IconComponent className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="text-lg font-bold text-gray-800">{menu.name}</h3>
                      <p className="text-sm text-gray-500 mt-1">{menu.description}</p>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-gray-400 group-hover:text-gray-600 transition-all" />
                </div>
              </div>
            );
          })}
        </div>

        {/* Quick Actions */}
        <div className="mt-8 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Quick Actions</h3>
          <div className="flex flex-wrap gap-4">
            <button className="px-4 py-2 bg-blue-50 text-blue-700 rounded-xl text-sm font-medium hover:bg-blue-100 transition-all">
              Backup Database
            </button>
            <button className="px-4 py-2 bg-green-50 text-green-700 rounded-xl text-sm font-medium hover:bg-green-100 transition-all">
              Clear Cache
            </button>
            <button className="px-4 py-2 bg-red-50 text-red-700 rounded-xl text-sm font-medium hover:bg-red-100 transition-all">
              View Logs
            </button>
            <button className="px-4 py-2 bg-purple-50 text-purple-700 rounded-xl text-sm font-medium hover:bg-purple-100 transition-all">
              System Status
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Settings;