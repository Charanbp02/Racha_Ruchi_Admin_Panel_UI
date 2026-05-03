import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function CategorySettings() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState("");
  const [settings, setSettings] = useState({
    defaultStatus: "Active",
    allowMultipleCategories: true,
    showSubCategories: true,
    autoGenerateSlug: true,
    requireDescription: false,
    maxCategories: "Unlimited",
    sortBy: "Name",
    displayFormat: "Grid"
  });

  const showNotificationMessage = (message) => {
    setNotificationMessage(message);
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setSettings({
      ...settings,
      [name]: type === "checkbox" ? checked : value
    });
  };

  const handleSave = () => {
    showNotificationMessage("Settings saved successfully!");
    setTimeout(() => navigate("/category"), 1500);
  };

  return (
    <div className="min-h-screen">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-gray-800 text-white px-6 py-3 rounded-xl shadow-lg">
          {notificationMessage}
        </div>
      )}

      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Category Settings</h2>
        <p className="text-gray-500">Configure category preferences and display options</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* General Settings */}
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <h3 className="text-lg font-bold text-gray-800 mb-4">General Settings</h3>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Default Category Status</label>
              <select
                name="defaultStatus"
                value={settings.defaultStatus}
                onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              >
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Maximum Categories</label>
              <select
                name="maxCategories"
                value={settings.maxCategories}
                onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              >
                <option value="Unlimited">Unlimited</option>
                <option value="10">10</option>
                <option value="20">20</option>
                <option value="50">50</option>
                <option value="100">100</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Sort Categories By</label>
              <select
                name="sortBy"
                value={settings.sortBy}
                onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              >
                <option value="Name">Name</option>
                <option value="Date">Date Created</option>
                <option value="Recipe Count">Recipe Count</option>
              </select>
            </div>
          </div>
        </div>

        {/* Display Settings */}
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Display Settings</h3>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Display Format</label>
              <select
                name="displayFormat"
                value={settings.displayFormat}
                onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              >
                <option value="Grid">Grid View</option>
                <option value="List">List View</option>
              </select>
            </div>

            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">Allow multiple categories per recipe</span>
              <input
                type="checkbox"
                name="allowMultipleCategories"
                checked={settings.allowMultipleCategories}
                onChange={handleChange}
                className="w-5 h-5 text-orange-500 rounded"
              />
            </label>

            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">Show sub categories</span>
              <input
                type="checkbox"
                name="showSubCategories"
                checked={settings.showSubCategories}
                onChange={handleChange}
                className="w-5 h-5 text-orange-500 rounded"
              />
            </label>

            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">Auto generate slug from name</span>
              <input
                type="checkbox"
                name="autoGenerateSlug"
                checked={settings.autoGenerateSlug}
                onChange={handleChange}
                className="w-5 h-5 text-orange-500 rounded"
              />
            </label>

            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">Require description for categories</span>
              <input
                type="checkbox"
                name="requireDescription"
                checked={settings.requireDescription}
                onChange={handleChange}
                className="w-5 h-5 text-orange-500 rounded"
              />
            </label>
          </div>
        </div>
      </div>

      {/* Save Button */}
      <div className="mt-6 flex justify-end">
        <button
          onClick={handleSave}
          className="px-6 py-3 bg-gradient-to-r from-orange-500 to-red-500 text-white rounded-xl font-medium shadow-lg hover:shadow-xl transition-all"
        >
          Save Settings
        </button>
      </div>
    </div>
  );
}

export default CategorySettings;