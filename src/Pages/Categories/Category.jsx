import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function Category() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState("");

  const showNotificationMessage = (message) => {
    setNotificationMessage(message);
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const categories = [
    { id: 1, name: "Breakfast", recipeCount: 45, status: "Active" },
    { id: 2, name: "Lunch", recipeCount: 68, status: "Active" },
    { id: 3, name: "Dinner", recipeCount: 72, status: "Active" },
    { id: 4, name: "Desserts", recipeCount: 34, status: "Active" },
    { id: 5, name: "Snacks", recipeCount: 52, status: "Active" },
  ];

  return (
    <div className="min-h-screen">
      {/* Notification */}
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-gray-800 text-white px-6 py-3 rounded-xl shadow-lg">
          {notificationMessage}
        </div>
      )}

      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Category Management</h2>
        <p className="text-gray-500">Manage your recipe categories</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Quick Stats */}
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Category Stats</h3>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Total Categories</span>
              <span className="font-bold text-xl text-gray-800">12</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Active Categories</span>
              <span className="font-bold text-xl text-green-600">10</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Inactive Categories</span>
              <span className="font-bold text-xl text-red-600">2</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-600">Total Recipes</span>
              <span className="font-bold text-xl text-orange-600">271</span>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Quick Actions</h3>
          <div className="space-y-3">
            <button
              onClick={() => navigate("/category/add")}
              className="w-full bg-gradient-to-r from-orange-500 to-red-500 text-white py-2 rounded-xl font-medium"
            >
              + Add New Category
            </button>
            <button
              onClick={() => navigate("/category/manage")}
              className="w-full bg-gray-100 text-gray-800 py-2 rounded-xl font-medium hover:bg-gray-200"
            >
              Manage Categories
            </button>
            <button
              onClick={() => navigate("/category/sub")}
              className="w-full bg-gray-100 text-gray-800 py-2 rounded-xl font-medium hover:bg-gray-200"
            >
              Manage Sub Categories
            </button>
            <button
              onClick={() => navigate("/category/settings")}
              className="w-full bg-gray-100 text-gray-800 py-2 rounded-xl font-medium hover:bg-gray-200"
            >
              Category Settings
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Category;