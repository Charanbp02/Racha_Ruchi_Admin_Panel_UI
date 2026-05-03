import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Lock, Check, X, Shield, Users, Video, Package, ShoppingCart, Settings, Save } from "lucide-react";

function Permissions() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [selectedRole, setSelectedRole] = useState("Admin");

  const roles = ["Admin", "Chef", "User", "Moderator"];

  const [permissions, setPermissions] = useState({
    Admin: {
      dashboard: true, users: true, products: true, orders: true, videos: true, categories: true, settings: true
    },
    Chef: {
      dashboard: true, users: false, products: false, orders: false, videos: true, categories: true, settings: false
    },
    User: {
      dashboard: true, users: false, products: false, orders: false, videos: false, categories: false, settings: false
    },
    Moderator: {
      dashboard: true, users: true, products: false, orders: false, videos: true, categories: true, settings: false
    }
  });

  const permissionModules = [
    { id: "dashboard", name: "Dashboard Access", icon: Users },
    { id: "users", name: "User Management", icon: Users },
    { id: "products", name: "Product Management", icon: Package },
    { id: "orders", name: "Order Management", icon: ShoppingCart },
    { id: "videos", name: "Video Management", icon: Video },
    { id: "categories", name: "Category Management", icon: Shield },
    { id: "settings", name: "Settings Access", icon: Settings },
  ];

  const handleToggle = (module) => {
    setPermissions({
      ...permissions,
      [selectedRole]: {
        ...permissions[selectedRole],
        [module]: !permissions[selectedRole][module]
      }
    });
  };

  const handleSave = () => {
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const getModuleIcon = (icon) => {
    const IconComponent = icon;
    return <IconComponent className="w-5 h-5" />;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Permissions saved successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Permissions
          </h1>
          <p className="text-gray-500 mt-2">Manage role-based access permissions</p>
        </div>

        {/* Role Selector */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <label className="block text-sm font-medium text-gray-700 mb-2">Select Role</label>
          <div className="flex flex-wrap gap-3">
            {roles.map(role => (
              <button
                key={role}
                onClick={() => setSelectedRole(role)}
                className={`px-5 py-2 rounded-xl font-medium transition-all ${
                  selectedRole === role
                    ? "bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-md"
                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                }`}
              >
                {role}
              </button>
            ))}
          </div>
        </div>

        {/* Permissions Grid */}
        <div className="bg-white rounded-2xl shadow-sm overflow-hidden">
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 px-6 py-4">
            <h2 className="text-xl font-bold text-white">{selectedRole} Permissions</h2>
            <p className="text-blue-100 text-sm mt-1">Configure access permissions for {selectedRole} role</p>
          </div>
          <div className="divide-y divide-gray-100">
            {permissionModules.map(module => {
              const IconComponent = module.icon;
              const isEnabled = permissions[selectedRole][module.id];
              return (
                <div key={module.id} className="flex items-center justify-between p-5 hover:bg-gray-50 transition-all">
                  <div className="flex items-center gap-4">
                    <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${
                      isEnabled ? "bg-green-100" : "bg-gray-100"
                    }`}>
                      {getModuleIcon(IconComponent)}
                    </div>
                    <div>
                      <h3 className="font-medium text-gray-800">{module.name}</h3>
                      <p className="text-xs text-gray-500 mt-0.5">
                        {isEnabled ? "Access granted" : "Access restricted"}
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={() => handleToggle(module.id)}
                    className={`relative inline-flex h-6 w-11 items-center rounded-full transition-all ${
                      isEnabled ? "bg-green-600" : "bg-gray-300"
                    }`}
                  >
                    <span
                      className={`inline-block h-4 w-4 transform rounded-full bg-white transition-all ${
                        isEnabled ? "translate-x-6" : "translate-x-1"
                      }`}
                    />
                  </button>
                </div>
              );
            })}
          </div>
          <div className="p-6 border-t border-gray-100 bg-gray-50">
            <div className="flex gap-4">
              <button
                type="button"
                onClick={() => navigate("/users")}
                className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-medium hover:bg-gray-100 transition-all"
              >
                Cancel
              </button>
              <button
                onClick={handleSave}
                className="flex-1 px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center justify-center gap-2"
              >
                <Save className="w-5 h-5" />
                Save Permissions
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Permissions;